class Track {
	/*
	
	atribuuteja
		Array Waypointeista, jotka muodostavat reitin
		Array uuden segment aloittavista waypointeista

	metodeja
		getterit ja setterit
		palauta array reitin varrella käytetyistä päällysteistä (pavement), niitä esim. street, tarmac, sand

	*/

  ArrayList<Waypoint> waypoints;
  Waypoint start;
  Waypoint end;

	Track(Waypoint start){
    this.start = start;
    this.waypoints = new ArrayList<Waypoint>();
    waypoints.add(start);
  }

}