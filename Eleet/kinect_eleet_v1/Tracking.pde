String track() {
  depth = kinect.getRawDepth();

  if (depth == null) return;

  if (checkLeftField(depth)) {
    timeElapsedLeft += 1;
    if (timeElapsedLeft >= timeToConfirm) return "confirm";
  } else timeElapsedLeft = 0;

  if (checkRightField(depth)) {
    timeElapsedRight += 1;
    if (timeElapsedRight >= timeToConfirm) return "confirm";
  } else timeElapsedRight = 0;

  checkFrontField(depth); //miten hoidetaan ??

  if (checkBackField(depth)) {
    timeElapsedBack += 1;
    if (timeElapsedBack >= timeToConfirm) return "return";
  } else timeElapsedBack = 0;

}

boolean checkLeftField() {

}
