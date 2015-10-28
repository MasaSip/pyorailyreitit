import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;

// We'll use a lookup table so that we don't have to repeat the math over and over
float[] depthLookUp = new float[2048];

float floorDistance = 3.0; // in meters
float distanceBuffer = 1.0; // in meters
float timeToConfirm = 100; // amount of times draw is called
int areaToConfirm = 100; // minimum amount of points
float timeElapsedLeft;
float timeElapsedRight;
float timeElapsedBack; //timeElapsedFront not needed

//limits in order: l,r,f,b
float leftFieldLimits[4] = [kinect.width/6, kinect.width/3, kinect.height*2/5, kinect.height*3/5];
float rightFieldLimits[4] = [kinect.width*2/3, kinect.width*5/6, kinect.height*2/5, kinect.height*3/5];
float frontFieldLimits[4] = [kinect.width*1/6, kinect.width*5/6, kinect.height/10, kinect.height*2/5];
float backFieldLimits[4] = [kinect.width*1/3, kinect.width*2/3, kinect.height*3/5, kinect.height*4/5];

float horizontalInitPoint;
float horizontalCursor;
float verticalRefPoint;
float verticalCursor;

void setup() {
  size(640, 520);
  kinect = new Kinect(this);
  kinect.initDepth();

  // Lookup table for all possible depth values (0 - 2047)
  for (int i = 0; i < depthLookUp.length; i++) {
    depthLookUp[i] = rawDepthToMeters(i);
  }
}

void draw() {
  String action = track();

  if (action == "confirm") {

  } else if (action == "return") {

  } else if (action == "move horizontal") {

  } else if (action == "move vertical") {

  }

}

float rawDepthToMeters(int depthValue) {
  if (depthValue < 2047) {
    return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
  }
  return 0.0f;
}
