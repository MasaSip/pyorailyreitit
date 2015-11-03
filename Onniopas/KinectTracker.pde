import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect = new Kinect(this);

class KinectTracker {
  // Kinect Library object
  // We'll use a lookup table so that we don't have to repeat the math over and over
  float[] depthLookUp = new float[2048];

  float floorDistance = 3.0; // in meters
  float distanceBuffer = 1.0; // in meters
  int timeToConfirm = 60; // amount of times draw is called
  int timeToReturn = 80;
  int areaToConfirm = 300; // minimum amount of points
  boolean recognizedGesture = false;
  float timeElapsedLeft;
  float timeElapsedRight;
  float timeElapsedBack; // timeElapsedFront not needed
  int timer = 0;

  int trackSkip = 2; // how many points to skip when tracking gestures
  int trackArea = 70; // how big an area does the monitorField average

  //limits in order: l,r,f,b
  int[] leftFieldLimits;
  int[] rightFieldLimits;
  int[] frontFieldLimits;
  int[] backFieldLimits;

  float horizontalRefPoint;
  float horizontalCursor;
  float horizontalResult;
  float horizontalScaled;
  float verticalRefPoint;
  float verticalCursor;
  float verticalResult;
  float verticalScaled;

  KinectTracker() {
    kinectSetup();
  }

  void kinectSetup() {
    kinect.initDepth();
    // Lookup table for all possible depth values (0 - 2047)
    for (int i = 0; i < depthLookUp.length; i++) {
      depthLookUp[i] = rawDepthToMeters(i);
    }
    leftFieldLimits = new int[]{kinect.width/10, kinect.width/4, kinect.height*1/2, kinect.height*4/5};
    rightFieldLimits = new int[]{kinect.width*3/4, kinect.width*9/10, kinect.height*1/2, kinect.height*4/5};
    frontFieldLimits = new int[]{kinect.width*1/6, kinect.width*5/6, kinect.height/10, kinect.height*2/5};
    backFieldLimits = new int[]{kinect.width*1/3, kinect.width*2/3, kinect.height*4/5, kinect.height};
  }

  String listenKinectGestures(String monitor) {

    String action = track(monitor);

    if (action == "horizontal") {
      horizontalResult = horizontalCursor - (kinect.width/2);
      horizontalScaled = max(0, min((horizontalResult + 100) / 2, 100));
    } else if (action == "vertical") {
      verticalResult = verticalCursor - verticalRefPoint;
      if (verticalResult < -0.05) verticalScaled = -1;
      else if (verticalResult > 0.05) verticalScaled = 1;
      else verticalScaled = 0;
    }

    return action;
  }

  float getVerticalScaled() {
    return verticalScaled;
  }

  float getHorizontalScaled() {
    return horizontalScaled;
  }

  float rawDepthToMeters(int depthValue) {
    if (depthValue < 2047) {
      return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
    }
    return 0.0f;
  }

  String track(String trackCursor) {
   int[] depthValues = kinect.getRawDepth();

   if (depthValues == null) return "none";

   //println("startleft");
   if (checkField(depthValues, leftFieldLimits)) {
     timeElapsedLeft += 1;
     if (timeElapsedLeft == timeToConfirm && !recognizedGesture) {
       //timeElapsedLeft = 0;
       recognizedGesture = true;
       return "confirm";
     }
   } else {
     timeElapsedLeft = 0;
     recognizedGesture = false;
   }

   //println("startright");
   if (checkField(depthValues, rightFieldLimits)) {
     timeElapsedRight += 1;
     if (timeElapsedRight == timeToConfirm && !recognizedGesture) {
       //timeElapsedRight = 0;
       recognizedGesture = true;
       return "confirm";
     }
   } else {
     timeElapsedRight = 0;
     recognizedGesture = false;
   }

   //println("startback");
   if (checkField(depthValues, backFieldLimits)) {
     timeElapsedBack += 1;
     if (timeElapsedBack == timeToReturn && !recognizedGesture) {
       //timeElapsedBack = 0;
       recognizedGesture = true;
       return "return";
     }
   } else {
     recognizedGesture = false;
     timeElapsedBack = 0;
   }

   //println("startfront");
   if (trackCursor == "vertical") {
     if (monitorField(depthValues, frontFieldLimits, "vertical")) return "vertical";
   } else if (trackCursor == "horizontal") {
     if (monitorField(depthValues, frontFieldLimits, "horizontal")) return "horizontal";
   }

   return "none";
  }


  boolean checkField(int[] depthValues, int[] fieldLimits) {

    int areaVisible = 0;

    for (int y = fieldLimits[2]; y < fieldLimits[3]; y += trackSkip) {
      for (int x = fieldLimits[0]; x < fieldLimits[1]; x += trackSkip) {

        int location = kinect.width*(y-1) + x;
        // if (location > 306875 || location < 1000) {
        //   println("location: " + location); //307412
        // //  println("depthvalues: " + depthValues.length);
        //   println(fieldLimits); //106, 213, 192, 320
        //   println(" - width: " + kinect.width + " - height: " + kinect.height);
        //   println("x: "+x + "  y: "+y); //106, 289
        // }
        float depth = depthLookUp[depthValues[location]]; //arrayIndexOutOfBoundsException: 307412

        if (0.1 < depth && depth < floorDistance - distanceBuffer) {
          areaVisible += 1;
          //point(x,y);
        }
        // timer += 1;
        // if (timer >= 1000000 && x == 150 && y == 250) {
        //   timer = 0;
        //   println(depth);
        // } else if (timer == 900000) println("---");
        // if (x == 150 && y == 250) ellipse(x,y,5,5);
      }
    }
    return areaVisible >= areaToConfirm;
  }


  boolean monitorField(int[] depthValues, int[] fieldLimits, String direction) {

   int areaVisible = 0;
   int count = 0;
   int refCount = 0;
   int xSumCursor = 0;
   float depthSumCursor = 0;
   int xSumRef = 0;
   float depthSumRef = 0;

   for (int y = fieldLimits[2]; y < fieldLimits[3]; y += trackSkip) {
     for (int x = fieldLimits[0]; x < fieldLimits[1]; x += trackSkip) {

       int location = kinect.width*(y-1) + x;
       float depth = depthLookUp[depthValues[location]];

       if (0.1 < depth && depth < floorDistance - distanceBuffer) {

         //point(x,y);

         areaVisible += 1;

         if (count < trackArea) {
           xSumCursor += x;
           depthSumCursor += depth;
           count += 1;
           //ellipse(x,y,2,2);
         }

         if (y >= fieldLimits[3] - trackSkip) {
           xSumRef += x;
           depthSumRef += depth;
           //println(depth);
           refCount += 1;
           //ellipse(x,y,2,2);
         }

       }

     }
   }

   if (areaVisible > areaToConfirm) {
     if (direction == "horizontal") {
       horizontalCursor = xSumCursor / trackArea;
       if (refCount != 0) {
         horizontalRefPoint = xSumRef / refCount;
         //println(horizontalRefPoint + " - " + xSumRef + "  -  " + refCount);
       }
     } else if (direction == "vertical") {
       verticalCursor = depthSumCursor / trackArea;
       if (refCount != 0) {
         verticalRefPoint = depthSumRef / refCount;
         //println(verticalRefPoint + " - " + depthSumRef + "  -  " + refCount);
       }
     }
     return true;
   } else return false;
  }

}
