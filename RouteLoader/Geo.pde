class Coordinate implements Cloneable, Comparable<Coordinate> {
  double longitude, latitude, height;
  Object extraData;
  
  Coordinate(double longitude, double latitude, double height) {
    this.longitude=longitude; this.latitude=latitude; this.height=height;
  }
  int compareTo(Coordinate p) {
    return Double.compare(this.longitude,p.longitude);
  }
  String toString() {
    return Double.toString(longitude)+":"+Double.toString(latitude); 
  }
  public Coordinate clone() {
    try {
      return (Coordinate)super.clone();
    } catch (CloneNotSupportedException e) {
      return null; 
    }
  }
}

interface GeoDrawable {
  void drawGeo(GeoPointMapper mapper);
}

class GeoPointMapper {
  double originLongitude, originLatitude;
  int offsetx, offsety;
  float scale;
  GeoPointMapper(Track t) {
    double minLongitude = t.minLongitude;
    double maxLongitude = t.maxLongitude;
    double minLatitude = t.minLatitude;
    double maxLatitude = t.maxLatitude;
    originLongitude = (minLongitude+maxLongitude)/2;
    originLatitude = (minLatitude+maxLatitude)/2;    
    scale = 1;
  }
  GeoPointMapper(Track t, float width, float height) {
    double minLongitude = t.minLongitude;
    double maxLongitude = t.maxLongitude;
    double minLatitude = t.minLatitude;
    double maxLatitude = t.maxLatitude;
    originLongitude = (minLongitude+maxLongitude)/2;
    originLatitude = (minLatitude+maxLatitude)/2;
    
    double longitudeRange = Math.cos(originLatitude*(Math.PI/180))*(maxLongitude-minLongitude); //<>// //<>//
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
  PVector map(Coordinate g) {
    double deltaLongitude = g.longitude - originLongitude;
    double deltaLatitude = g.latitude - originLatitude;
    PVector p = new PVector(offsetx+(float)(scale*deltaLongitude*Math.cos(originLatitude*(Math.PI/180))),offsety-(float)(scale*deltaLatitude));
    return p;
  }
}


class GeoPointSet implements GeoDrawable {
  java.util.TreeSet<Coordinate> points;
  GeoPointSet() {
    points = new java.util.TreeSet<Coordinate>(); 
  }
  void drawGeo(GeoPointMapper mapper) {
     for (Coordinate g : points) {
       if (g.extraData != null && g.extraData instanceof GeoDrawable) {
         GeoDrawable gd = (GeoDrawable)g.extraData;
         gd.drawGeo(mapper);
       } else {
       PVector p = mapper.map(g);
       stroke(#ff0000);
       fill(#ff0000);
       ellipse(p.x,p.y,5,5);
       }
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
      Coordinate p = new Coordinate(Double.parseDouble(longitude),Double.parseDouble(latitude),0);
      pointset.points.add(p);
    }
    return pointset;
}

Track testTrack;
GeoPointMapper mapper;

void setupGeoTest() {
  testTrack = new Track("../RouteLoader/data/smt-otsolahdenRanta-westendinMaki.json");
  mapper = new GeoPointMapper(testTrack,1280,720);
  mapper.offsetx=1280/2;
  mapper.offsety=720/2;
}

void drawGeoTest() {
  background(#ffffff);
  testTrack.drawGeo(mapper);
  GeoPointSet filtered = filterToTrackBounds(testTrack,crossings);
  analyzeCrossings(testTrack,filtered);
  filtered.drawGeo(mapper);
}
