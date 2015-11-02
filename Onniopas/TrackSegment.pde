class TrackSegment implements GeoDrawable {
  
  ArrayList<GeoPoint> coordinates;
  float length;
  String type;
  
  TrackSegment(ArrayList<GeoPoint> coordinates, float length, String type){
    this.coordinates = coordinates;
    this.length = length;
    this.type = type;
  } 

  float getLength() {
    return this.length;
  }

  String getType() {
    return this.type;
  }

  String toString() {
    return this.type + " TrackSegment including " + coordinates.size() + " coordinates with total length of " + this.length;
  }
  
  void drawGeo(GeoPointMapper mapper) {
    PVector previous = null;
    stroke(#000000);
    for (int i=0; i<coordinates.size(); i++) {
       PVector p = mapper.map(coordinates.get(i));
       if (previous!=null) {
         line(previous.x,previous.y,p.x,p.y);
       }
       previous = p;
    }
  }
}