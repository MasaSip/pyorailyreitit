String track(String trackCursor) {
  int[] depthValues = kinect.getRawDepth();

  if (depthValues == null) return;

  if (checkField(depthValues, leftFieldLimits)) {
    timeElapsedLeft += 1;
    if (timeElapsedLeft >= timeToConfirm) return "confirm";
  } else timeElapsedLeft = 0;

  if (checkField(depthValues, rightFieldLimits)) {
    timeElapsedRight += 1;
    if (timeElapsedRight >= timeToConfirm) return "confirm";
  } else timeElapsedRight = 0;

  if (checkField(depthValues, backFieldLimits)) {
    timeElapsedBack += 1;
    if (timeElapsedBack >= timeToConfirm) return "return";
  } else timeElapsedBack = 0;

  if (trackCursor == "vertical") { // To-do: ehto: jos ollaan tietyssä näkymässä
    if (monitorField(depthValues, frontFieldLimits, "vertical")) return "vertical";
  } else if (trackCursor == "horizontal") {
    if (monitorField(depthValues, frontFieldLimits, "horizontal")) return "horizontal";
  }
}

boolean checkField(int[] depthValues, float[] fieldLimits) {

  int areaVisible = 0;

  for (int x = fieldLimits[0]; x < fieldLimits[1]; x++) {
    for (int y = fieldLimits[2]; y < fieldLimits[3]; y++) {

      float depth = depthLookUp[depthValues];
      if (depth <= floorDistance - distanceBuffer) areaVisible += 1;

    }
  }
  return areaVisible >= areaToConfirm;
}

boolean monitorField(int[] depthValues, float[] fieldLimits, String direction) {
  // To-do !!
}
