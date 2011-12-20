class PostureWindow
{
  int x, y, w, h;
//  int data = 0;
//  String postureLine[] = new String[2];
  
  PostureWindow(int _x, int _y, int _w, int  _h)
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    
//    postureLine[0] = "Sitting";
//    postureLine[1] = "Stand";

      
  }
  
  void update()
  {       
//    data = rightMeanData.GetLatestPoint().value;
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

//    if(data<550)
//      text(postureLine[0], w/2-40,h/2+10);
//    else
//      text(postureLine[1],w/2-40,h/2+10);

    text(predictedLabel, w/2-50,h/2+10);

    fill(0);
    textFont(sergueUI, 15);
    text("Posture", w-57, 23);
    popMatrix();
  }
  
}
