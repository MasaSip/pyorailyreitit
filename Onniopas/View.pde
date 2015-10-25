/*
    UI views
*/

class View {
  
  int whichView;
  color clr;
  String title;
  String text;
  
  PImage img;
  
  View(int whichView, color clr, String title) {
    this.whichView = whichView;
    this.clr = clr;
    this.title = title;
    this.text = "";
  }
  
  View(int whichView, color clr, String title, String text) {
    this.whichView = whichView;
    this.clr = clr;
    this.title = title;
    this.text = text;
  }
  
  View(int whichView, color clr, PImage img) {
    this.whichView = whichView;
    this.clr = clr;
    this.img = img;
  }
}