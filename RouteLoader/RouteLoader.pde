GeoPointSet crossings;

void setup() {
  size(1280,720);
    crossings = loadPointSet("Espoo_risteykset.kml");
    setupGeoTest();

  String[] trackPieces = loadRoutes();
  saveStrings("../Onniopas/data/routes.txt", trackPieces);
}

void draw() {
  drawGeoTest();
}