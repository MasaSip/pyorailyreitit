class GeoPoint implements Comparable<GeoPoint> {
  double longitude, latitude, height;
  GeoPoint(double longitude, double latitude, double height) {
    this.longitude=longitude; this.latitude=latitude; this.height=height;
  }
  int compareTo(GeoPoint p) {
    return Double.compare(this.longitude,p.longitude);
  }
  String toString() {
    return Double.toString(longitude)+":"+Double.toString(latitude); 
  }
}

class Point {
  float x, y;
  Point(float x, float y) { this.x = x; this.y = y; }
  String toString() {
    return str(x)+":"+str(y); 
  }
}

interface GeoDrawable {
  void drawGeo(GeoPointMapper mapper);
}

class GeoPointMapper {
  double originLongitude, originLatitude; //<>//
  int offsetx, offsety;
  float scale;
  GeoPointMapper(Track t, int width, int height) {
    double minLongitude = t.minLongitude;
    double maxLongitude = t.maxLongitude;
    double minLatitude = t.minLatitude;
    double maxLatitude = t.maxLatitude;
    originLongitude = (minLongitude+maxLongitude)/2;
    originLatitude = (minLatitude+maxLatitude)/2;
    
    double longitudeRange = Math.cos(originLatitude*(Math.PI/180))*(maxLongitude-minLongitude); //<>//
    double latitudeRange = maxLatitude-minLatitude;
    float aspect = (float)(longitudeRange/latitudeRange);
    float viewAspect = ((float)width)/height;
    if (aspect > viewAspect) {
      // Leveys on rajoittava tekijä.
      scale = (float)(((double)width)/longitudeRange);
    } else {
      // Korkeus on rajoittava tekijä.
      scale = (float)(((double)height)/latitudeRange);
    }
  }
  Point map(GeoPoint g) {
    double deltaLongitude = g.longitude - originLongitude;
    double deltaLatitude = g.latitude - originLatitude;
    Point p = new Point(offsetx+(float)(scale*deltaLongitude*Math.cos(originLatitude*(Math.PI/180))),offsety-(float)(scale*deltaLatitude));
    return p;
  }
}


class GeoPointSet implements GeoDrawable {
  java.util.TreeSet<GeoPoint> points;
  GeoPointSet() {
    points = new java.util.TreeSet<GeoPoint>(); 
  }
  void drawGeo(GeoPointMapper mapper) {
     stroke(#ff0000);
     fill(#ff0000);
     for (GeoPoint g : points) {
       Point p = mapper.map(g);
       ellipse(p.x,p.y,5,5);
     }
  }  
}

GeoPointSet loadPointSet(String filename) {
    XML data = loadXML(filename);
    XML[] points = data.getChildren("Document/Folder/Placemark/Point/coordinates");
    GeoPointSet pointset = new GeoPointSet();
    for (int i=0; i < points.length; i++) {
      String coordinates = points[i].getContent();
      int separator = coordinates.indexOf(",");
      String longitude = coordinates.substring(0,separator);
      int separator2 = coordinates.indexOf(",",separator+1);
      String latitude = coordinates.substring(separator+1,separator2);
      GeoPoint p = new GeoPoint(Double.parseDouble(longitude),Double.parseDouble(latitude),0);
      pointset.points.add(p);
    }
    return pointset;
}

Track testTrack;
GeoPointMapper mapper;

void setupGeoTest() {
  testTrack = new Track("data/smt-otsolahdenRanta-westendinMaki.json");
  mapper = new GeoPointMapper(testTrack,1280,720);
  mapper.offsetx=1280/2;
  mapper.offsety=720/2;
}

void drawGeoTest() {
  background(#ffffff);
  testTrack.drawGeo(mapper);
  crossings.drawGeo(mapper);
}