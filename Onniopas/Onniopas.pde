/*
    Onniopas
*/

View[] views;
int currentView;
color bgColor;

void setup() {
  size(640, 320);
  basicSetup();
  createViews();
}

void basicSetup() {
  currentView = 0;
  views = new View[4];
  bgColor = color(140,221,225,1);
}

void createViews() {
  views[0] = new View(0, bgColor);
  views[1] = new View(1, color(255,140,248,1));
}

void draw() {
  drawBg();
}

void drawBg() {
  if (currentView == 0) {
    background(views[0].clr);
  }
  else if (currentView == 1) {
    background(views[1].clr);
  }
  
}

void mouseClicked() {
  if (currentView >= 0 && currentView < 1) {
    currentView++;
    println("Näkymä " + currentView);
  }
  else {
    currentView = 0;
    println("Näkymä " + currentView);
  }
}