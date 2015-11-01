class Track {

  ArrayList<TrackSegment> trackSegments;
  float totalLength;
  float lengthWithKnownPavement;
	
  Track(String dataPath){
  
    JSONObject route = loadJSONObject(dataPath);
    this.totalLength = route.getFloat("length");

    JSONArray path = route.getJSONArray("path");

    this.trackSegments = new ArrayList<TrackSegment>();
  
    for (int i = 0; i < path.size(); i++){
      JSONObject pathObject = path.getJSONObject(i);

      JSONArray points = pathObject.getJSONArray("points");
      ArrayList<Coordinate> coordinates = new ArrayList<Coordinate>();
        
      for (int j = 0; j < points.size(); j++) {
        JSONObject coordinate = points.getJSONObject(j);
        Coordinate coord = new Coordinate(coordinate.getFloat("x"), coordinate.getFloat("y"), coordinate.getFloat("z"));
        coordinates.add(coord);
      }

      String type = pathObject.getString("type");
      float length = pathObject.getFloat("length");
      TrackSegment trackSegment = new TrackSegment(coordinates, length, type);
      this.trackSegments.add(trackSegment);
      
      if (!type.equals("unknown")){
        lengthWithKnownPavement += length;
      }
    }
  }

  ArrayList<TrackSegment> getTrackSegments() {
    return this.trackSegments;  
  }

  float getTotalLength() {
    return this.totalLength;
  }

  float getLengthWithKnownPavement() {
    return this.lengthWithKnownPavement;
  }
}
