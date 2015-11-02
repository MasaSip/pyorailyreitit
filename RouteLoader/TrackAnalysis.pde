GeoPointSet filterToTrackBounds(Track t, GeoPointSet gs) {
  double tolerance = 0.0001; /* Leveyspiireissä tämä vastaa reilua kymmentä metriä */
  GeoPointSet res = new GeoPointSet();
  for (GeoPoint g : gs.points) {
    if (g.latitude > t.maxLatitude + tolerance) continue;
    if (g.latitude < t.minLatitude - tolerance) continue;
    if (g.longitude > t.maxLongitude + tolerance) continue;
    if (g.longitude < t.minLongitude - tolerance) continue;
    res.points.add((GeoPoint)g.clone());
  }
  return res;
}

class CrossingData implements GeoDrawable {
  GeoPoint crossingPoint;
  void drawGeo(GeoPointMapper mapper) {
    PVector p = mapper.map(crossingPoint);
    fill(#00ff00);
    stroke(#00ff00);
    ellipse(p.x,p.y,5,5);
  }
}

boolean assertNaN(PVector v) {
   if (Float.isNaN(v.x) || Float.isNaN(v.y)) {
     println("NaN-arvo "+v);
     return true;
   } else return false;
}

void analyzeCrossings(Track t, GeoPointSet crossings) {
   GeoPointMapper mapper = new GeoPointMapper(t);
   ArrayList<TrackSegment> trackSegments = t.trackSegments;
   println("Tuloste alkaa");
   for (int i = 0; i < trackSegments.size(); i++) {
     ArrayList<GeoPoint> coordinates = trackSegments.get(i).coordinates;
     PVector prev = null;
     for (int j = 0; j < coordinates.size(); j++) {
       PVector p = mapper.map(coordinates.get(j));
       if (prev != null) {
         PVector pathVector = PVector.sub(p,prev);
         float pathLen = pathVector.mag();
         PVector pathTangent = pathVector.normalize();
        for (GeoPoint cp : crossings.points) {
           float tolerance = 0.0003;
           PVector p2 = mapper.map(cp);
           PVector diff = PVector.sub(p2,prev);
           float tangential = pathTangent.dot(diff);
           PVector tangentComponent = PVector.mult(pathTangent,tangential);
           PVector normal = PVector.sub(diff,tangentComponent);
           float dist = normal.mag();
           float distp = PVector.sub(prev,p2).mag();
           float distp2 = PVector.sub(p,p2).mag();
           if ((tangential >= 0 && tangential <= pathLen && dist < tolerance) ||
                distp < tolerance ||
                distp2 < tolerance) {
                 if (cp.extraData == null) {
                  CrossingData data = new CrossingData();
                  data.crossingPoint = cp;
                  cp.extraData = data;
                  println("Osuma: "+dist+" / "+distp+" / "+distp2);
                 }
           }
         }
       }
       prev = p;
     }
   }
   println("Tuloste päättyy");
}