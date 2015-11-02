class TrackSegment {
  
  ArrayList<Coordinate> coordinates;
  float length;
  String type;
  float averageHeight;
  
  TrackSegment(ArrayList<Coordinate> coordinates, float length, String type){
    this.coordinates = coordinates;
    this.length = length;
    this.type = type;
    calculateAverageHeight();
    println(this.averageHeight);
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
      this.averageHeight += coordinates.get(i).getHeight()/coordinates.size();
    }
  }

  String getType() {
    return this.type;
  }

  String toString() {
    return this.type + " TrackSegment including " + coordinates.size() + " coordinates with total length of " + this.length;
  }
}