String track(String trackCursor) {
 int[] depthValues = kinect.getRawDepth();

 if (depthValues == null) return "none";

 //println("startleft");
 if (checkField(depthValues, leftFieldLimits)) {
   timeElapsedLeft += 1;
   if (timeElapsedLeft >= timeToConfirm) return "confirm";
 } else timeElapsedLeft = 0;

 //println("startright");
 if (checkField(depthValues, rightFieldLimits)) {
   timeElapsedRight += 1;
   if (timeElapsedRight >= timeToConfirm) return "confirm";
 } else timeElapsedRight = 0;

 //println("startfront");
 if (checkField(depthValues, backFieldLimits)) {
   timeElapsedBack += 1;
   if (timeElapsedBack >= timeToConfirm) return "return";
 } else timeElapsedBack = 0;

 //println("startback");
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

      if (depth < floorDistance - distanceBuffer) {
        areaVisible += 1;
        point(x,y);
      }

    }
  }
  return areaVisible >= areaToConfirm;
}


boolean monitorField(int[] depthValues, int[] fieldLimits, String direction) {

 int areaVisible = 0;
 int count = 0;
 int xSumCursor = 0;
 int ySumCursor = 0;

 for (int y = fieldLimits[2]; y < fieldLimits[3]; y += trackSkip) {
   for (int x = fieldLimits[0]; x < fieldLimits[1]; x += trackSkip) {

     int location = kinect.width*(y-1) + x;
     float depth = depthLookUp[depthValues[location]];

     if (depth < floorDistance - distanceBuffer) {

       point(x,y);

       areaVisible += 1;

       if (count < trackArea) {
         xSumCursor += x;
         ySumCursor += y;
         count += 1;
         ellipse(x,y,2,2);
       }

     }

   }
 }

 if (areaVisible > areaToConfirm) {
   if (direction == "vertical") {
     verticalCursor = xSumCursor / trackArea;
   } else if (direction == "horizontal") {
     horizontalCursor = ySumCursor / trackArea;
   }
   return true;
 } else return false;
}
