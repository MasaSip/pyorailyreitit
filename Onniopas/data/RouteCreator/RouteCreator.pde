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

String numbers = "1234567890";
int closestRoute1Index = 0;
float closestRoute1Length = 1000;
int closestRoute2Index = 0;
Float closestRoute2Length = 1000;
String[] route1String;
String[] route2String;
int highestPoint = 0;

void getRoutes(float targetLength) { // VAIHDA LOPUKSI TYYPPIIN String[] !!!

  String[] allRoutes = loadStrings("routesTargetFormat.txt");

  for (int i = 0; i < allRoutes.length; i++) {
    println(allRoutes[i]);
  }

  for (int i = 0; i < allRoutes.length; i++) { //etsitään kaksi lähintä reittiä
    for (int j = 0; i < numbers.length; i++) {

      if (allRoutes[i] == numbers[j]) {

        float thisLength = new Float(allRoutes[i]);

        if (abs(thisLength - targetLength) < abs(closestRoute1Length - targetLength)) {
          closestRoute1Index = i;
          closestRoute1Length = thisLength;
        } else if (abs(thisLength - targetLength) < abs(closestRoute2Length - targetLength)) {
          closestRoute2Index = i;
          closestRoute2Length = thisLength;
        }

      }

    }
  }

  for (int i = closestRoute1Index + 1; i < closestRoute1Index + 10; i++) { //kasataan palautettavat reitit

    String[] parts = split(allRoutes[i], '-');

    route1String = append(route1String, parts[0]);
    route1String = append(route1String, "-");

    int height = int(parts[1]); //toimiiko??

    if (height < )
    route1String = append(route1String, parts[1])

  }
}
