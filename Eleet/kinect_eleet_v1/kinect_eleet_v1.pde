import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;

void setup() {
  size(640, 480);
  kinect = new Kinect(this);
  kinect.initDepth();

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}

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

void draw() {

  leftFieldLimits = new int[]{kinect.width/10, kinect.width/4, kinect.height*1/2, kinect.height*4/5};
  rightFieldLimits = new int[]{kinect.width*3/4, kinect.width*9/10, kinect.height*1/2, kinect.height*4/5};
  frontFieldLimits = new int[]{kinect.width*1/6, kinect.width*5/6, kinect.height/100, kinect.height*2/5};
  backFieldLimits = new int[]{kinect.width*1/3, kinect.width*2/3, kinect.height*4/5, kinect.height};

  // println("  left " + leftFieldLimits[0]); //106, 213, 192, 320
  // println("  right " + rightFieldLimits[0]); //426, 533, 192, 320
  // println("  front " + frontFieldLimits[0]); //106, 533, 48, 192
  // println("  back " + backFieldLimits[0]); //213, 426, 320, 400

  fill(255);
  rect(0,0,kinect.width,kinect.height);
  fill(250, 100, 100);
  rect(leftFieldLimits[0], leftFieldLimits[2],
   leftFieldLimits[1]-leftFieldLimits[0], leftFieldLimits[3]-leftFieldLimits[2]);
  fill(100,250,100);
  rect(rightFieldLimits[0], rightFieldLimits[2],
   rightFieldLimits[1]-rightFieldLimits[0], rightFieldLimits[3]-rightFieldLimits[2]);
  fill(100,100,250);
  rect(frontFieldLimits[0], frontFieldLimits[2],
   frontFieldLimits[1]-frontFieldLimits[0], frontFieldLimits[3]-frontFieldLimits[2]);
  fill(200,200,200);
  rect(backFieldLimits[0], backFieldLimits[2],
   backFieldLimits[1]-backFieldLimits[0], backFieldLimits[3]-backFieldLimits[2]);

  String action = track("vertical");

  if (action != "none" && action != "vertical" && action != "horizontal") println(action);

  if (action == "confirm") {

  } else if (action == "return") {

  } else if (action == "horizontal") {
    //horizontalResult = horizontalCursor - horizontalRefPoint;
    horizontalResult = horizontalCursor - (kinect.width/2);
    horizontalScaled = max(0, min((horizontalResult + 100) / 2, 100));

    timer += 1;
    if (timer == 100) {
      timer = 0;
      println("H.res: " + horizontalScaled);
      //println(" - c: " + horizontalCursor + " - r: " + horizontalRefPoint);
    }
  } else if (action == "vertical") {
    verticalResult = verticalCursor - verticalRefPoint;
    if (verticalResult < -0.05) verticalScaled = -1;
    else if (verticalResult > 0.05) verticalScaled = 1;
    else verticalScaled = 0;

    timer += 1;
    if (timer == 100) {
      timer = 0;
      println("V.res: " + verticalScaled);
      //println(" - c: " + verticalCursor + " - r: " + verticalRefPoint);
    }
  }

}

float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}
