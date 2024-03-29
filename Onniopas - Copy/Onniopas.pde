/*
    Onniopas
*/

View[] views;
int currentView;
int prevView;
color bgColor1;
color bgColor2;
color accentColor;
color fontColor;
color rectColor;

Slider slider;
String[] route;

PImage[] route1img;
PImage[] route2img;
PImage earth;

int chosenRoute;

void setup() {
  size(1280, 720);
  basicSetup();
  createViews();
}

void basicSetup() {
  // Views setup
  currentView = 0;
  prevView = -1;
  views = new View[4];
  bgColor1 = color(140,221,225,1);
  bgColor2 = color(67,202,209,1);
  accentColor = color(247,148,29,1);
  fontColor = color(255,255,255,1);
  rectColor = color(140, 304, 100, 1);
  
  // Slider
  slider = new Slider("horizontal", 20, 50, 100, 390, 60, 1200, accentColor);

  // get from backend (road types)
  //route = loadRoutes();
  route = new String[]{"tarmac-low", "tarmac-up", "tarmac-high", "tarmac-high", "gravel-down", "gravel-low", "gravel-low", "gravel-low", "gravel-low", "tarmac-low"};

  // list for saving road images
  //images = new PImage[10];
  
  chosenRoute = 0;
}

void createViews() {
  // First view: start view with title
  views[0] = new View(0, bgColor1, loadImage("bike.png"), "NNIOPAS", "Paina CTRL siirtyäksesi valitsemaan reittejä.");
  
  // Second view: length of the route
  views[1] = new View(0, bgColor1, "Reitin pituus", "Paina CTRL nähdäksesi reitti.");
   
  // Third view: visualise the (three) best route(s)
  views[2] = new View(2, bgColor1, "Reitti");
  
  // show chosen route on the map
  views[3] = new View(3, bgColor1, "Valittu reitti kartalla");
  
}

void draw() {
  drawViews();
}

void drawViews() {
  
  // background
  background(views[1].clr);
  //drawBackground();
  
  if (currentView == 0) {
    // texts
    PFont font = createFont("calibri.ttf", 120);
    textFont(font);
    fill(255,255,255);
    text(views[0].title, 495, 325);
    PFont font1 = createFont("calibri.ttf", 30);
    textFont(font1);
    text(views[0].text, 400, 600);
    
    // bike
    rotate(PI/-4.0);
    image(views[0].img, 45, 370);
  }
  
  else if (currentView == 1) {
    // texts
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    fill(255,255,255);
    text(views[1].title, 10, 60);
    PFont font3 = createFont("calibri.ttf", 30);
    textFont(font3);
    fill(255,255,255);
    text(views[1].text, 400, 600);
    
    noStroke();
    fill(230,148,29);
    rect(50, 400, 1180, 30);
    // slider
    fill(247,110,29);
    slider.drawSlider();
  }
  
  else if (currentView == 2) {
    if (prevView < currentView) {
      // get two closest routes from backend
      //ArrayList<String[]> routes2 = new ArrayList<String[]>();
      //routes2 = getRoutes(slider.getSliderValue(3, 15));
      // save route images to images list
      route1img = getRouteImages();
      route2img = getRouteImages();
    }
    
    // texts
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    fill(255,255,255);
    text(views[2].title, 10, 60);
    
    // routes
    drawRoute(route1img, 1);
    drawRoute(route2img, 2);
  }
  
  else if (currentView == 3) {
    // background
    background(views[3].clr);
    
    // texts
    PFont font2 = createFont("calibri.ttf", 30);
    textFont(font2);
    fill(255,255,255);
    text(views[3].title, 10, 60);
    
    fill(15, 180, 150);
    rect(200, 120, 870, 500);
  }  
  
}

PImage[] getRouteImages() {
  PImage[] images = new PImage[10];
  for (int i = 0; i < route.length; i++) {
    float random = random(100);
    if (route[i].equals("tarmac-low") || route[i].equals("tarmac-high")) {
      if (random <= 15) {
        images[i] = loadImage("tarmac1.png");
      }
      else if (random > 15 && random < 85) {
        images[i] = loadImage("tarmac3.png");
      }
      else {
        images[i] = loadImage("tarmac2.png");
      }
    }
    else if (route[i].equals("tarmac-up")) {
      images[i] = loadImage("tarmac-up.png");
    }
    else if (route[i].equals("tarmac-down")) {
      images[i] = loadImage("tarmac-down.png");
    }
    else if (route[i].equals("gravel-low") || route[i].equals("gravel-high")) {
      if (random > 20) {
        images[i] = loadImage("gravel1.png");
      }
      else {
        images[i] = loadImage("gravel-xmas.png");
      }
    }
    else if (route[i].equals("gravel-up")) {
      images[i] = loadImage("gravel-up.png");
    }
    else if (route[i].equals("gravel-down")) {
      images[i] = loadImage("gravel-down.png");
    }
  }
  earth = loadImage("earth.png");
  return images;
}

void drawBackground() {
  int r = 140;
  int g = 221;
  int b = 225;
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < height; j++) {
        stroke(r, i+150, b);
        line(0,i,width,i);
    }
  }
}

void drawRoute(PImage[] images, int whichRoute) {
  for (int i = 0; i < route.length; i++) {
    if (route[i].equals("tarmac-high") || route[i].equals("gravel-high")) {
      //alkumaapalikka
      earth.resize(140, 52);
      image(earth, i*110.6+70, 88+whichRoute*200);
      //oikeapalikka
      images[i].resize(140, 140);
      image(images[i], i*110.6+70, -17+whichRoute*200);
    }
    else {
      images[i].resize(140, 140);
      image(images[i], i*110.6+70, 0+whichRoute*200);
    }
  }
}

void keyPressed() {
  // confirm: wave right or left arm
  if (keyCode == CONTROL) {
    if (currentView >= 0 && currentView < 3) {
      prevView = currentView;
      currentView++;
      println("Näkymä " + currentView);
    }
  }
  
  // return: step backwards
  else if (keyCode == ALT) {
    if (currentView <= 3 && currentView > 0) {
      prevView = currentView;
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