/*
    Onniopas
*/

View[] views;
int currentView;
color bgColor;
XML route;
Track track;

void setup() {
  size(640, 320);
  basicSetup();
  createViews();
  loadRoutes();
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

void loadRoutes() {
  route = loadXML("smtJmtKml.kml");
  XML nameXML = route.getChild("Document/name");
  String name = nameXML.getContent();
  XML[] placemarks = route.getChildren("Document/Placemark");
  track = new Track(new Waypoint());
 
  
  // koodin testausta
  Coordinate a = new Coordinate(24.83470903446,60.188652103573,8.285);
  println(a.getLongitude());
  println(name);
  getCoordinatesFromXmlTag(placemarks[2]);
  

  // Two firs placemarks are only dublicates of the first and last coordinates
  for (int i=2; i<placemarks.length; i++){

  }
}

Coordinate[] getCoordinatesFromXmlTag(XML placemark){
  String coordinateString = placemark.getChild("LineString/coordinates").getContent();
  String[] points = split(coordinateString, ' ');
  Coordinate[] coordinates = new Coordinate[points.length];
  
  // The last element is and empty at points array because coordinateString ends to a space
  println(points.length);
  for (int i = 0; i<points.length-1; i++){
    String[] logLatHeig = split(points[i], ',');
    coordinates[i] = new Coordinate(float(logLatHeig[0]), float(logLatHeig[1]), float(logLatHeig[2]));
  }
 
  return coordinates;
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