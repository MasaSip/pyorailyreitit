class View {
  
  int whichView;
  color clr;
  PImage img;
  
  View(int whichView, color clr) {
    this.whichView = whichView;
    this.clr = clr;
  }
  
  View(int whichView, color clr, PImage img) {
    this.whichView = whichView;
    this.clr = clr;
    this.img = img;
  }
}