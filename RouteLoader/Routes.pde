int targetAmountOfPieces = 10;

String[] routeFilelist = {// "smt-otsolahdenRanta-westendinMaki.json",
  "11km, westendin rantalenkki",
  "12km, laahalahden ympari",
  "3km, otahallin ja rannan kautta",
  "5km, tapiolan kirkolla kaynti",
  "6km, otaniemen ympari",
  "8km, keilalahden ympari",
  "9km, villa elfvikille"};

void loadRoutes() {
  
  String savingPath = "../Onniopas/data/routes.txt";

  ArrayList<String[]> routeList = new ArrayList<String[]>();
  int outputLines = 0;

  for (String filename : routeFilelist) {
    Track t = new Track("data/"+filename);

    String[] pieceTypes = calculateTrackPieceTypes(t, targetAmountOfPieces);
  
    int[] pieceHeigths = calculateTrackPieceHeights(t, targetAmountOfPieces);
  
    String[] output = serializeRoute(t.getTotalLength(), pieceTypes, pieceHeigths, filename);
    outputLines += output.length;
    routeList.add(output);
  }
  String[] combined = new String[outputLines];
  int i=0;
  for (String[] route : routeList) {
    for (String line : route) {
      combined[i] = line;
      i++;
    }
  }
  saveStrings(savingPath, combined);
}

String[] calculateTrackPieceTypes(Track track, int targetAmountOfPieces) {

  ArrayList<TrackSegment> trackSegments = track.getTrackSegments();
  String[] trackPieces = new String[targetAmountOfPieces];
  int latestModifiedIndex = 0;
  // Calculates track length for segments with known type (gravel or tarmac)
  float lengthWithKnownPAvement = track.getLengthWithKnownPavement();
  

  float pieceLength = lengthWithKnownPAvement/targetAmountOfPieces;
  // first tarmac, second gravel
  
  float tarmac = 0;
  float gravel = 0;
  
  for (int i=0; i < trackSegments.size(); i++) {
      TrackSegment segment = trackSegments.get(i);
      // With two if loops, we avoid handling trackgegments with unkown type
      
      if (segment.getType().equals("tarmac")){
        tarmac += segment.getLength();
        
        while (tarmac > pieceLength){
          trackPieces[latestModifiedIndex] = segment.getType();
          tarmac -= pieceLength;
          latestModifiedIndex++;
        }
      }
      if (segment.getType().equals("gravel")){
        gravel += segment.getLength();

        while (gravel > pieceLength){
          trackPieces[latestModifiedIndex] = segment.getType();
          gravel -= pieceLength;
          latestModifiedIndex++;
        }
      }
  }

  if (tarmac > gravel){
    trackPieces[targetAmountOfPieces-1] = "tarmac";
  } else {
    trackPieces[targetAmountOfPieces-1] = "gravel";
  }

  return trackPieces;
}

  /*
  Piece heights are the average heights of track on piece
  */
int[] calculateTrackPieceHeights(Track track, int targetAmountOfPieces) {

  ArrayList<String> debugList = new ArrayList<String>();
  float unDevidedLength = 0;
  float unDevidedHeight = 0;
  
  ArrayList<TrackSegment> trackSegments = track.getTrackSegments();
  float pieceLength = track.getTotalLength()/targetAmountOfPieces;

  float[] pieceHeigths = new float[targetAmountOfPieces];
  int editNextIndex = 0;

  for (int i=0; i < trackSegments.size(); i++) {
      TrackSegment segment = trackSegments.get(i);
      
      unDevidedLength += segment.getLength();
      unDevidedHeight += segment.getAverageHeight()*segment.getLength();
      debugList.add(str(unDevidedLength) + " " + str(unDevidedHeight) + "===" + str(segment.getLength()) + "_" + str(segment.getAverageHeight()));

      // One trackSegment may cause us to cross several piece boundaries
      while (unDevidedLength > pieceLength) {
        float overLength = unDevidedLength - pieceLength;
        float overHeight = overLength*segment.getAverageHeight();
        debugList.add(str(overLength));
        debugList.add(str(overLength*segment.getAverageHeight()));
        debugList.add(str(overHeight));
        
        float lengthAtBoundary = unDevidedLength - overLength;
        float heightAtBoundary = unDevidedHeight - overHeight;
        float pieceHeigth = heightAtBoundary/lengthAtBoundary;
        pieceHeigths[editNextIndex] = pieceHeigth;
        debugList.add("*********");
        debugList.add(str(pieceHeigth));
        debugList.add("*********");
        editNextIndex++;
        unDevidedLength = overLength;
        unDevidedHeight = overHeight;
      }
  }

  saveArrayList(debugList);
  return int(pieceHeigths);
}

void saveArrayList(ArrayList<String> arrayList) {
  String[] list = new String[arrayList.size()];
  for (int i = 0; i < arrayList.size(); i++) {
    list[i] = arrayList.get(i);
  }
  saveStrings("debug.txt", list);
}

String[] serializeRoute(float length, String[] trackPieces, int[] pieceHeigths, String name){
  String[] route = new String[targetAmountOfPieces+3];
  route[0] = str(round(length/100)/10.0f);
  for (int i =0; i < trackPieces.length; i++) {
    route[1+i] = trackPieces[i] + "-" + pieceHeigths[i];
  }
  route[trackPieces.length + 1] = name;
  route[trackPieces.length + 2] = " ";

  return route;
}