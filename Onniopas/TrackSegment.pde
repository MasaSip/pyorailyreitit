class TrackSegment {
  
  ArrayList<Coordinate> coordinates;
  float length;
  String type;
  
  TrackSegment(ArrayList<Coordinate> coordinates, float length, String type){
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
}