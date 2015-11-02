// getRoutes
// parametrina float
// tulos: ArrayList, jossa 2x String[],
//
// tarmac-low
// tarmac-high
// tarmac-up
// tarmac-down
//
// samat gravelille
//
// kaikista mahdollista myös olla ...-sea

void setup() {
  getRoutes(3.7);
}

void getRoutes(float targetLength) { // VAIHDA LOPUKSI TYYPPIIN String[] !!!

  String[] allRoutes = loadStrings("routesTargetFormat.txt");

  for (int i = 0; i < allRoutes.length; i++) {
    println(allRoutes[i]);
  }

  for (int i = 0; i < allRoutes.length; i++) { //etsitään kaksi lähintä reittiä
    println(allRoutes[i]);
  }

  for (int i = 0; i < allRoutes.length; i++) {



  }
}
