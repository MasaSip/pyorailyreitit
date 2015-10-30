class Coordinate {
	
  // Pituuspiiri
  double longitude;
  // Leveyspiiri
  double latitude;
  double height;
  
  Coordinate(double longitude, double latitude, double height){
    this.longitude = longitude;
    this.latitude = latitude;
    this.height = height;
  }
  
  String toString(){
    return this.longitude + ", " +  this.latitude + ", " + this.height;
  }

  double getLongitude(){
    return longitude;
  }

  double getLatitude(){
    return latitude;
  }

  double getHeight(){
    return height;
  }
}