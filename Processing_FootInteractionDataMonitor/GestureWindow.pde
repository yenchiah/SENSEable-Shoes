class GestureWindow
{
  int x, y, w, h;

  String gestureLine [] = new String[4];
  GestureWindow(int _x, int _y, int _w, int _h)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    
    gestureLine[0] = "Left";
    gestureLine[1] = "Right";
    gestureLine[2] = "Up";
    gestureLine[3] = "Down";
  }
  
  void update()
  {

  }
  
  void draw()
  {
    pushMatrix();
    translate(x,y);
    strokeWeight(5);
    stroke(255);
    fill(220);
    rect(5, 5, w-5, h-5);
    
    fill(16,78,139);
    textFont(sergueUI,30);

    if(currentGestureStatus!=-1)
      text(gestureLine[currentGestureStatus], w/2-40,h/2+10);
      
    fill(0);
    textFont(sergueUI, 15);
    text("Gesture", w-55, 23);
    popMatrix();
  }
}
