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

float floorDistance = 1.5; // in meters
float distanceBuffer = 1.0; // in meters
float timeToConfirm = 70; // amount of times draw is called
int areaToConfirm = 100; // minimum amount of points
float timeElapsedLeft;
float timeElapsedRight;
float timeElapsedBack; // timeElapsedFront not needed

int trackSkip = 2; // how many points to skip when tracking gestures
int trackArea = 30; // how big an area does the monitorField average

//limits in order: l,r,f,b
int[] leftFieldLimits;
int[] rightFieldLimits;
int[] frontFieldLimits;
int[] backFieldLimits;

float horizontalRefPoint;
float horizontalCursor;
float verticalRefPoint;
float verticalCursor;

void draw() {

  leftFieldLimits = new int[]{kinect.width/6, kinect.width/3, kinect.height*2/5, kinect.height*2/3};
  rightFieldLimits = new int[]{kinect.width*2/3, kinect.width*5/6, kinect.height*2/5, kinect.height*2/3};
  frontFieldLimits = new int[]{kinect.width*1/6, kinect.width*5/6, kinect.height/10, kinect.height*2/5};
  backFieldLimits = new int[]{kinect.width*1/3, kinect.width*2/3, kinect.height*2/3, kinect.height*5/6};

  // println("  left " + leftFieldLimits[0]); //106, 213, 192, 320
  // println("  right " + rightFieldLimits[0]); //426, 533, 192, 320
  // println("  front " + frontFieldLimits[0]); //106, 533, 48, 192
  // println("  back " + backFieldLimits[0]); //213, 426, 320, 400

  fill(255);
  rect(0,0,kinect.width,kinect.height);
  fill(150, 0, 0);
  rect(leftFieldLimits[0], leftFieldLimits[2],
   leftFieldLimits[1]-leftFieldLimits[0], leftFieldLimits[3]-leftFieldLimits[2]);
  fill(0,150,0);
  rect(rightFieldLimits[0], rightFieldLimits[2],
   rightFieldLimits[1]-rightFieldLimits[0], rightFieldLimits[3]-rightFieldLimits[2]);
  fill(0,0,150);
  rect(frontFieldLimits[0], frontFieldLimits[2],
   frontFieldLimits[1]-frontFieldLimits[0], frontFieldLimits[3]-frontFieldLimits[2]);
  fill(100,100,100);
  rect(backFieldLimits[0], backFieldLimits[2],
   backFieldLimits[1]-backFieldLimits[0], backFieldLimits[3]-backFieldLimits[2]);

  String action = track("basic");

  if (action != "none") println(action);

  if (action == "confirm") {

  } else if (action == "return") {

  } else if (action == "horizontal") {

  } else if (action == "vertical") {

  }

}

float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}
