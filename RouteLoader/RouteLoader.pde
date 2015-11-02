GeoPointSet crossings;

void setup() {
  size(1280,720);
    crossings = loadPointSet("Espoo_risteykset.kml");
    setupGeoTest();

  loadRoutes();
}

void draw() {
  drawGeoTest();
}