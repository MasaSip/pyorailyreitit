void loadRoutes() {
  String[] trackPieces;
  int targetAmountOfPieces = 10;

  JSONObject route = loadJSONObject("data/smt-otsolahdenRanta-westendinMaki.json");
  JSONArray path = route.getJSONArray("path");

  ArrayList<TrackSegment> trackSegments = new ArrayList<TrackSegment>();
  

  for (int i = 0; i < path.size(); i++){
    JSONObject pathObject = path.getJSONObject(i);

    JSONArray points = pathObject.getJSONArray("points");
    ArrayList<Coordinate> coordinates = new ArrayList<Coordinate>();
      
      for (int j = 0; j < points.size(); j++) {
        JSONObject coordinate = points.getJSONObject(j);
        Coordinate coord = new Coordinate(coordinate.getFloat("x"), coordinate.getFloat("y"), 0);
        coordinates.add(coord);
      }
    String type = pathObject.getString("type");
    float length = pathObject.getFloat("length");
    TrackSegment trackSegment = new TrackSegment(coordinates, length, type);
    trackSegments.add(trackSegment);
    println(trackSegment);
  }

  trackPieces = calculateTrackPieces(trackSegments, targetAmountOfPieces);
  println(trackPieces);
  
}


String[] calculateTrackPieces(ArrayList<TrackSegment> trackSegments, int targetAmountOfPieces) {

  String[] trackPieces = new String[targetAmountOfPieces];
  int latestModifiedIndex = 0;
  // Calculates track length for segments with known type (gravel or tarmac)
  float trackLength = 0;
  for (int i=0; i < trackSegments.size(); i++) {
    TrackSegment segment = trackSegments.get(i);
    if (!segment.getType().equals("unknown")){
      trackLength += segment.getLength();
    }
  }

  float pieceLength = trackLength/targetAmountOfPieces;
  float tarmac = 0;
  float gravel = 0;

  for (int i=0; i < trackSegments.size(); i++) {
      TrackSegment segment = trackSegments.get(i);
      println(segment.getType());
      if (segment.getType().equals("tarmac")){
        tarmac += segment.getLength();
        while (tarmac > pieceLength){
          trackPieces[latestModifiedIndex] = segment.getType();
          tarmac -= pieceLength;
          latestModifiedIndex++;
        }
      }
      if (segment.getType().equals("gravel")){
        gravel += segment.getLength();
        while (gravel > pieceLength){
          trackPieces[latestModifiedIndex] = segment.getType();
          gravel -= pieceLength;
          latestModifiedIndex++;
        }
      }
  }

  if (tarmac > gravel){
    trackPieces[targetAmountOfPieces-1] = "tarmac";
  } else {
    trackPieces[targetAmountOfPieces-1] = "gravel";
  }

  return trackPieces;
}
  

/*

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
}

float getWholeLength = function() {
  return 0;
}

boolean someRouteLeft = function() {
  return true;
}
*/