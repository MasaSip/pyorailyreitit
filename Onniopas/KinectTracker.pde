class KinectTracker {
  import org.openkinect.freenect.*;
  import org.openkinect.processing.*;

  // Kinect Library object
  Kinect kinect;
  // We'll use a lookup table so that we don't have to repeat the math over and over
  float[] depthLookUp = new float[2048];

  float floorDistance = 3.0; // in meters
  float distanceBuffer = 1.0; // in meters
  int timeToConfirm = 70; // amount of times draw is called
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
    kinect = new Kinect(this);
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

    String action = track("vertical");

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

}
