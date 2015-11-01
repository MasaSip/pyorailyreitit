String track(String trackCursor) {
 int[] depthValues = kinect.getRawDepth();

 if (depthValues == null) return "none";

 //println("startleft");
 if (checkField(depthValues, leftFieldLimits)) {
   timeElapsedLeft += 1;
   if (timeElapsedLeft >= timeToConfirm) {
     timeElapsedLeft = 0;
     return "confirm";
   }
 } else timeElapsedLeft = 0;

 //println("startright");
 if (checkField(depthValues, rightFieldLimits)) {
   timeElapsedRight += 1;
   if (timeElapsedRight >= timeToConfirm) {
     timeElapsedRight = 0;
     return "confirm";
   }
 } else timeElapsedRight = 0;

 //println("startback");
 if (checkField(depthValues, backFieldLimits)) {
   timeElapsedBack += 1;
   if (timeElapsedBack >= timeToConfirm) {
     timeElapsedBack = 0;
     return "return";
   }
 } else timeElapsedBack = 0;

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
        point(x,y);
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
 int depthSumCursor = 0;
 int xSumRef = 0;
 int depthSumRef = 0;

 for (int y = fieldLimits[2]; y < fieldLimits[3]; y += trackSkip) {
   for (int x = fieldLimits[0]; x < fieldLimits[1]; x += trackSkip) {

     int location = kinect.width*(y-1) + x;
     float depth = depthLookUp[depthValues[location]];

     if (0.1 < depth && depth < floorDistance - distanceBuffer) {

       point(x,y);

       areaVisible += 1;

       if (count < trackArea) {
         xSumCursor += x;
         depthSumCursor += depth;
         count += 1;
         ellipse(x,y,2,2);
       }

       if (y >= fieldLimits[3] - trackSkip) {
         xSumRef += x;
         depthSumRef += depth;
         refCount += 1;
         ellipse(x,y,2,2);
       }

     }

   }
 }

 if (areaVisible > areaToConfirm) {
   if (direction == "horizontal") {
     horizontalCursor = xSumCursor / trackArea;
     if (refCount != 0) {
       verticalRefPoint = xSumRef / refCount;
       println(xSumRef + "  -  " + refCount);
     }
   } else if (direction == "vertical") {
     verticalCursor = depthSumCursor / trackArea;
     if (refCount != 0) verticalRefPoint = depthSumRef / refCount;
   }
   return true;
 } else return false;
}
