GeoPointSet crossings;

void setup() {
  size(1280,720);
    crossings = loadPointSet("Espoo_risteykset.kml");
    // setupGeoTest();

  loadRoutes();
  noLoop();
}

void draw() {
  println("Valmis");
  // drawGeoTest();
}