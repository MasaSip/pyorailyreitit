void loadRoutes() {
  
  JSONObject json = loadJSONObject("data/smt-jmt.json");
  JSONArray path = json.getJSONArray("path");
  float sum = 0;
  JSONArray points = path.getJSONObject(0).getJSONArray("points");
  
  
  ArrayList<Coordinate> coordinates = new ArrayList<Coordinate>();
  for (int i = 0; i < points.size(); i++) {
    JSONObject coordinate = points.getJSONObject(i);
    Coordinate coord = new Coordinate(coordinate.getFloat("x"), coordinate.getFloat("y"), 0);
    coordinates.add(coord);
  }
  TrackSegment segment1 = new TrackSegment(coordinates);

  for (int i = 1; i < path.size()-1; i++){
    sum += path.getJSONObject(i).getFloat("length");
  }
  println(sum);

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

void sortRoadType = function() {
  //PSEUDO

  float wholeLength = getWholeLength();

  ArrayList<float> roads = new ArrayList<float>();
  ArrayList<String> types = new ArrayList<String>();
  

  while(someRouteLeft()) {
    if (isTarmac()) {
      
    }
    else if (isGravel()) {
      //
    }
    else {
      //unknown
    }
  }

}

float getWholeLength = function() {
  return 0;
}

boolean someRouteLeft = function() {
  return true;
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