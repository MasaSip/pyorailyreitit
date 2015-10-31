/*
    Movable slider
*/

class Slider {
  
  String dir;
  color clr;
  float w, h, x, y;
  
  Slider(String dir, float w, float h, float x, float y, color clr) {
    this.dir = dir;
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
    this.clr = clr;
  }
  
  void slide(float newPos) {
    if (dir == "horizontal") {
      x = newPos;
    }
  }
  
  void drawSlider() {
    rect(x, y, w, h);
  }
}  