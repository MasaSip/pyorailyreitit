/*
    Onniopas
*/

View[] views;
int currentView;
color bgColor;
String[] route;
PImage[] images;

void setup() {
  size(1280, 720);
  basicSetup();
  createViews();
}

void basicSetup() {
  currentView = 0;
  views = new View[4];
  bgColor = color(140,221,225,1);

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
  views[0] = new View(0, bgColor, "Onniopas");
  
  // Second view: length of the route
  // Third view: other features of the route
  
  // Fourth view: visualise the (three) best route(s)
  views[1] = new View(1, bgColor, "Reitti");
  
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
    drawRoutes();
  }
  
}

void drawRoutes() {
  for (int i = 0; i < route.length; i++) {
    images[i].resize(140, 175);
    image(images[i], i*110.6+70, 0);
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