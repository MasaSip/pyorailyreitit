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
      if (newPos < width-70 || newPos > 50) {
        x = newPos;
      }
      else if (newPos >= width-70) {
        x = width-70;
      }
      else if (newPos <= 50) {
        x = 50;
      }
    }
  }
  
  void drawSlider() {
    rect(x, y, w, h);
  }
}  