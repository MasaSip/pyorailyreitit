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
      ArrayList<GeoPoint> coordinates = new ArrayList<GeoPoint>();
        
      for (int j = 0; j < points.size(); j++) {
        JSONObject coordinate = points.getJSONObject(j);
        GeoPoint coord = new GeoPoint(coordinate.getFloat("x"), coordinate.getFloat("y"), 0);
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
  void drawGeo(GeoPointMapper mapper) {
    for(int i=0; i<trackSegments.size();i++) {
      TrackSegment s = trackSegments.get(i);
      s.drawGeo(mapper);
    }
  }
}

GeoPointMapper geoPointMapperFromTrack(Track t, int width, int height) {
   double maxLatitude = Double.NEGATIVE_INFINITY;
   double minLatitude = Double.POSITIVE_INFINITY;
   double maxLongitude = Double.NEGATIVE_INFINITY;
   double minLongitude = Double.POSITIVE_INFINITY;
   ArrayList<TrackSegment> trackSegments = t.trackSegments;
   for (int i=0; i < trackSegments.size(); i++) {
     ArrayList<GeoPoint> coordinates = trackSegments.get(i).coordinates;
     for (int j=0; j<coordinates.size(); j++) {
       GeoPoint p = coordinates.get(j);
       if (p.longitude > maxLongitude) maxLongitude = p.longitude;
       if (p.longitude < minLongitude) minLongitude = p.longitude;
       if (p.latitude > maxLatitude) maxLatitude = p.latitude;
       if (p.latitude < minLatitude) minLatitude = p.latitude;
     }
   }
   GeoPointMapper m = new GeoPointMapper();
   m.setupMapper(width,height,minLongitude,maxLongitude,minLatitude,maxLatitude);
   return m;
}