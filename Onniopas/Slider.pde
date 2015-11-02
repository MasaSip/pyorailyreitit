/*
    Movable slider
*/

class Slider {
  
  String dir;
  color clr;
  float w, h, x, y, a, b;
  
  Slider(String dir, float w, float h, float x, float y, float a, float b, color clr) {
    this.dir = dir;
    this.w = w; //width
    this.h = h; //height
    this.x = x; //pos x
    this.y = y; //pos y
    this.a = a; //min pos
    this.b = b; //max pos
    this.clr = clr;
  }
  
  void slide(float newPos) {
    if (dir == "horizontal") {
      if (newPos < b || newPos > a) {
        x = newPos;
      }
      else if (newPos >= b) {
        x = b;
      }
      else if (newPos <= a) {
        x = a;
      }
    }
  }
  
  void drawSlider() {
    rect(x, y, w, h);
    println("drawSlider to " + str(x));
  }
  
  float getSliderValue(float minValue, float maxValue) {
    float values = maxValue - minValue;
    if ((x - a) != 0) {
      float relation = (b - a) / (x - a);
      return values / relation + minValue;
    }
    return minValue;
  }
}  