String[] loadRoutes() {
  
  String[] trackPieces;
  int targetAmountOfPieces = 10;

  Track otaniemiOtsolahtiWestend = new Track("data/smt-otsolahdenRanta-westendinMaki.json");

  trackPieces = calculateTrackPieces(otaniemiOtsolahtiWestend, targetAmountOfPieces);
  return trackPieces;
  
}

String[] calculateTrackPieces(Track track, int targetAmountOfPieces) {

  ArrayList<TrackSegment> trackSegments = track.getTrackSegments();
  String[] trackPieces = new String[targetAmountOfPieces];
  int latestModifiedIndex = 0;
  // Calculates track length for segments with known type (gravel or tarmac)
  float lengthWithKnownPAvement = track.getLengthWithKnownPavement();
  

  float pieceLength = lengthWithKnownPAvement/targetAmountOfPieces;
  float tarmac = 0;
  float gravel = 0;

  for (int i=0; i < trackSegments.size(); i++) {
      TrackSegment segment = trackSegments.get(i);
      println(segment.getType());
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
