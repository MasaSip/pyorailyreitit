class GeoPoint implements Comparable<GeoPoint> {
  double longitude, latitude, height;
  GeoPoint(double longitude, double latitude, double height) {
    this.longitude=longitude; this.latitude=latitude; this.height=height;
  }
  int compareTo(GeoPoint p) {
    return Double.compare(this.longitude,p.longitude);
  }
}

class Point {
  float x, y;
  Point(float x, float y) { this.x = x; this.y = y; }
}

interface GeoDrawable {
  void drawGeo(GeoPointMapper mapper);
}

class GeoPointMapper {
  double originLongitude, originLatitude;
  float scale;
  void setupMapper(int width, int height, double minLongitude, double maxLongitude, double minLatitude, double maxLatitude) {
    originLongitude = (minLongitude+maxLongitude)/2;
    originLatitude = (minLatitude+maxLatitude)/2;
    double longitudeRange = Math.cos(originLatitude)*(maxLongitude-minLongitude);
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
    Point p = new Point((float)(scale*deltaLongitude*Math.cos(originLatitude)),(float)(scale*deltaLatitude));
    return p;
  }
}


class GeoPointSet {
  java.util.TreeSet<GeoPoint> points;
  GeoPointSet() {
    points = new java.util.TreeSet<GeoPoint>(); 
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
  mapper = geoPointMapperFromTrack(testTrack,1280,720);
}

void drawGeoTest() {
  background(#ffffff);
  fill(#000000);
  pushMatrix();
  translate(1280/2,720/2);
  testTrack.drawGeo(mapper);
  popMatrix();
}