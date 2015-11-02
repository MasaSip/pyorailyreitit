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

//ArrayList<String[]> result;
ArrayList<String[]> result = new ArrayList<String[]>();

void setup() {
  getRoutes(10);
  //result = new ArrayList<String[]>();
}

String numbers = "1234567890";
int closestRoute1Index = 0;
float closestRoute1Length = 1000.0;
int closestRoute2Index = 0;
Float closestRoute2Length = 1000.0;
String[] route1String = new String[12];
String[] route2String = new String[12];
int highestPoint = 0;
int previousHeight = 0;
int seaLevel = 3;

ArrayList<String[]> getRoutes(float targetLength) { // VAIHDA LOPUKSI TYYPPIIN String[] !!!

  String[] allRoutes = loadStrings("routesTargetFormat.txt");

  //for (int i = 0; i < allRoutes.length; i++) {
  //  println(allRoutes[i]);
  //}

  for (int i = 0; i < allRoutes.length; i++) { //etsitään kaksi lähintä reittiä
    for (int j = 0; j < 10; j++) {

      //println(allRoutes[i]);

      if (allRoutes[i].length() != 0 && allRoutes[i].charAt(0) == numbers.charAt(j)) {

        float thisLength = new Float(allRoutes[i]);

        //println(i);

        if (abs(thisLength - targetLength) < abs(closestRoute1Length - targetLength)) {
          closestRoute2Index = closestRoute1Index;
          closestRoute2Length = closestRoute1Length;

          closestRoute1Index = i;
          closestRoute1Length = thisLength;
        } else if (abs(thisLength - targetLength) < abs(closestRoute2Length - targetLength)) {
          closestRoute2Index = i;
          closestRoute2Length = thisLength;
        }

      }

    }
  }

  for (int i = closestRoute1Index + 1; i < closestRoute1Index + 10; i++) { //etsitään korkein kohta

    String[] parts = split(allRoutes[i], '-');

    int height = int(parts[1]); //toimiiko??

    if (height > highestPoint) highestPoint = height;
  }

  for (int i = closestRoute2Index + 1; i < closestRoute2Index + 10; i++) { //kasataan palautettavat reitit

    String[] parts = split(allRoutes[i], '-');

    int height = int(parts[1]); //toimiiko??

    if (height > highestPoint) highestPoint = height;
  }


  for (int i = 0; i < 10; i++) { //kasataan palautettavat reitit

    String[] parts = split(allRoutes[i+closestRoute1Index+1], '-');

    route1String[i] = parts[0];
    route1String[i] += "-";

    int height = int(parts[1]); //toimiiko??

    if (height > highestPoint/2) {
      if (previousHeight > highestPoint/2) route1String[i] += "high";
      else route1String[i] += "up";

    } else if (previousHeight > highestPoint/2) route1String[i] += "down";
    else if (height <= seaLevel) route1String[i] += "low-sea";
    else route1String[i] += "low";

    previousHeight = height;
  }

  //println(route2String);

  for (int i = 0; i < 10; i++) { //kasataan palautettavat reitit

    String[] parts = split(allRoutes[i+closestRoute2Index+1], '-');

    route2String[i] = parts[0];
    route2String[i] += "-";

    //println(route2String[i]);

    int height = int(parts[1]); //toimiiko??

    if (height > highestPoint/2) {
      if (previousHeight > highestPoint/2) route2String[i] += "high";
      else route2String[i] += "up";

    } else if (previousHeight > highestPoint/2) route2String[i] += "down";
    else if (height <= seaLevel) route2String[i] += "low-sea";
    else route2String[i] += "low";

    previousHeight = height;
  }

  closestRoute1Length = new Float(allRoutes[closestRoute1Index]);
  closestRoute2Length = new Float(allRoutes[closestRoute2Index]);

  //route1String = append(route1String, allRoutes[closestRoute1Index+11]);
  //route1String = append(route1String, str(closestRoute1Length));

  //route2String = append(route2String, allRoutes[closestRoute2Index+11]);
  //route2String = append(route2String, str(closestRoute2Length));

  route1String[10] = allRoutes[closestRoute1Index+11];
  route1String[11] = str(closestRoute1Length);

  route2String[10] = allRoutes[closestRoute2Index+11];
  route2String[11] = str(closestRoute2Length);

  result.add(route1String);
  result.add(route2String);

  println(result);
  println(route1String);
  println(route2String);

  return result;
}
