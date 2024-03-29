class Track implements GeoDrawable {

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
        String sz = coordinate.getString("z","null");
        float z=0;
        if (!sz.equals("null")) z=coordinate.getFloat("z");
        
        Coordinate coord = new Coordinate(coordinate.getFloat("x"), coordinate.getFloat("y"), z);
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
    computeMinMax();
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
  void drawGeo(GeoPointMapper mapper) {
    for(int i=0; i<trackSegments.size();i++) {
      TrackSegment s = trackSegments.get(i);
      s.drawGeo(mapper);
    }
  }
  double minLatitude, maxLatitude, minLongitude, maxLongitude;
  void computeMinMax() {
     double maxLatitude = Double.NEGATIVE_INFINITY;
     double minLatitude = Double.POSITIVE_INFINITY;
     double maxLongitude = Double.NEGATIVE_INFINITY;
     double minLongitude = Double.POSITIVE_INFINITY;
     for (int i=0; i < trackSegments.size(); i++) {
       ArrayList<Coordinate> coordinates = trackSegments.get(i).coordinates;
       for (int j=0; j<coordinates.size(); j++) {
         Coordinate p = coordinates.get(j);
         if (p.longitude > maxLongitude) maxLongitude = p.longitude;
         if (p.longitude < minLongitude) minLongitude = p.longitude;
         if (p.latitude > maxLatitude) maxLatitude = p.latitude;
         if (p.latitude < minLatitude) minLatitude = p.latitude;
       }
     }
     this.maxLatitude = maxLatitude;
     this.minLatitude = minLatitude;
     this.maxLongitude = maxLongitude;
     this.minLongitude = minLongitude;
  }
}