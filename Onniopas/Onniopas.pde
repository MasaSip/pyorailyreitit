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
  // First view: start view with title
  views[0] = new View(0, bgColor, "Onniopas");
  
  // Second view: length of the route
  // Third view: other features of the route
  
  // Fourth view: visualise the (three) best route(s)
  views[1] = new View(1, color(255,140,248,1), "Reitti");
  
  // more exact visualisations on the chosen route
  // show chosen route on the map
}

void draw() {
  drawViews();
}

void drawViews() {
  if (currentView == 0) {
    background(views[0].clr);
    PFont font = createFont("calibri.ttf", 48);
    textFont(font);
    text(views[0].title, 10, 60);
  }
  else if (currentView == 1) {
    background(views[1].clr);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[1].title, 10, 60);
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