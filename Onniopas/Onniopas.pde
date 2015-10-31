/*
    Onniopas
*/

View[] views;
int currentView;
color bgColor;
color accentColor;
color fontColor;

Slider slider;
String[] route;
PImage[] images;

void setup() {
  size(1280, 720);
  basicSetup();
  createViews();
}

void basicSetup() {
  // Views setup
  currentView = 0;
  views = new View[4];
  bgColor = color(140,221,225,1);
  accentColor = color(247,148,29,1);
  fontColor = color(255,255,255,1);
  
  // Slider
  slider = new Slider("horizontal", 20, 50, 100, 100, accentColor);

  // get from backend (road types)
  route = new String[]{"tarmac", "tarmac", "tarmac", "tarmac", "gravel", "gravel", "gravel", "gravel", "tarmac", "tarmac"};

  // list for saving road images
  images = new PImage[10];

  // save route images to images list
  getRouteImages();
}

void getRouteImages() {
  for (int i = 0; i < route.length; i++) {
    if (route[i] == "tarmac") {
      images[i] = loadImage("tarmac1.png");
    }
    else if (route[i] == "gravel") {
      images[i] = loadImage("gravel1.png");
    }
  }
}

void createViews() {
  // First view: start view with title
  views[0] = new View(0, bgColor, loadImage("bike.png"), "NNIOPAS", "Paina CTRL siirtyäksesi valitsemaan reittejä.");
  
  // Second view: length of the route
  views[1] = new View(0, bgColor, "Reitin pituus", "Paina CTRL nähdäksesi reitti.");
  
  // Third view: other features of the route
  
  // Fourth view: visualise the (three) best route(s)
  views[2] = new View(2, bgColor, "Reitti");
  
  // more exact visualisations on the chosen route
  // show chosen route on the map
}

void draw() {
  drawViews();
}

void drawViews() {
  if (currentView == 0) {
    background(views[0].clr);
    PFont font = createFont("calibri.ttf", 120);
    textFont(font);
    text(views[0].title, 495, 325);
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    text(views[0].text, 400, 600);
    
    // draw bike
    rotate(PI/-4.0);
    image(views[0].img, 45, 370);
  }
  else if (currentView == 1) {
    background(views[1].clr);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[1].title, 10, 60);
    PFont font3 = createFont("calibri.ttf", 30);
    textFont(font3);
    text(views[1].text, 400, 600);
    
    // Draw slider
    slider.drawSlider();
  }
  else if (currentView == 2) {
    background(views[2].clr);
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    text(views[2].title, 10, 60);
    drawRoutes();
  }
  
}

void drawRoutes() {
  for (int i = 0; i < route.length; i++) {
    images[i].resize(140, 175);
    image(images[i], i*110.6+70, 0);
  }
}

void keyPressed() {
  // confirm: wave right or left arm
  if (keyCode == CONTROL) {
    if (currentView >= 0 && currentView < 2) {
      currentView++;
      println("Näkymä " + currentView);
    }
  }
  
  // return: step backwards
  else if (keyCode == ALT) {
    if (currentView <= 2 && currentView > 0) {
      currentView--;
      println("Näkymä " + currentView);
    }
  }
  
  // slide: move hand in front of the user
  else if (keyCode == SHIFT) {
    moveSlider();
  }
}

void moveSlider() {
  slider.slide(mouseX);
}