class TrackSegment implements GeoDrawable {
  
  ArrayList<Coordinate> coordinates;
  float length;
  String type;
  float averageHeight;
  
  TrackSegment(ArrayList<Coordinate> coordinates, float length, String type){
    this.coordinates = coordinates;
    this.length = length;
    this.type = type;
    calculateAverageHeight();
  } 

  float getLength() {
    return this.length;
  }

  float getAverageHeight() {
    return this.averageHeight;
  }

  void calculateAverageHeight() {
    this.averageHeight = 0;
    for (int i=0; i < coordinates.size(); i++) {
      this.averageHeight += coordinates.get(i).height/coordinates.size();
    }
  }

  String getType() {
    return this.type;
  }

  String toString() {
    return this.type + " TrackSegment including " + coordinates.size() + " coordinates with total length of " + this.length;
  }
  
  void drawGeo(GeoPointMapper mapper) {
    PVector previous = null;
    if (type.equals("gravel")) stroke(#a65e2e);
    else if (type.equals("tarmac")) stroke(#4c4c4c);
    else stroke(#3656CA);
    strokeWeight(2);
    for (int i=0; i<coordinates.size(); i++) {
       PVector p = mapper.map(coordinates.get(i));
       if (previous!=null) {
         line(previous.x,previous.y,p.x,p.y);
       }
       previous = p;
    }
    strokeWeight(1);
  }
}