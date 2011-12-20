class FootWindow
{
  String footDirection;
  int x, y, w, h;
  int footX, footY;
  PImage imgFoot;
  ArrayList sensors;
  FootWindow(int _x, int _y, int _w, String s)
  {
    //load foot img background
    footDirection = s;
    if (s == "left")
      imgFoot = loadImage("lfoot.png");
    else if (s == "right")
      imgFoot = loadImage("rfoot.png");

    //windows cordinates, height is based on the rato of the background img
    x = _x;
    y = _y;
    w = _w;
    h = w*imgFoot.height/imgFoot.width;

    //resize the image to fit window
    int tempImgW = round(w*.9);
    int tempImgH = round(h*tempImgW/w);
    //println(tempImgW);
    //println(tempImgH);
    imgFoot.resize(tempImgW, tempImgH);

    sensors = new ArrayList();

    if (s == "left")
    {                        
      sensors.add(new Point(w/12*10+5, h/7*2));//idx = 0
      sensors.add(new Point(w/11*8+5, h/11*9));//idx = 1
      sensors.add(new Point(w/11*4+5, h/11*9));//idx = 2
      sensors.add(new Point(w/11*2+5, h/3));//idx = 3
      sensors.add(new Point(w/11*6+5, h/8));//idx = 4
      sensors.add(new Point(w/11*9+5, h/9));//idx = 5
    }
    else if (s == "right")
    {
      sensors.add(new Point(w/11*3+5, h/9));//idx = 6
      sensors.add(new Point(w/11*8+5, h/11*9));//idx = 7
      sensors.add(new Point(w/11*4+5, h/11*9));//idx = 8
      sensors.add(new Point(w/11*9+5, h/5*2));//idx = 9
      sensors.add(new Point(w/11*2+5, h/3));//idx = 10
      sensors.add(new Point(w/11*6+5, h/8));//idx = 11                 
    }

    footX = (w-imgFoot.width)/2+5;
    footY = (h-imgFoot.height)/2+7;
  }

  void update()
  {
    //footDatas
  }

  void draw()
  {
    pushMatrix();
    translate(x, y);
    strokeWeight(5);
    stroke(255);
    fill(220);
    rect(5, 0, w, h-5);
    image(imgFoot, footX, footY);

    for (int i=0;i<sensors.size();i++)
    {
      Point s = (Point)sensors.get(i);
      int tp = 0;
      if (footDirection == "right")
        tp = ((FootPoint)footDatas[i].GetLatestPoint()).value;
      else if (footDirection == "left")
        tp = ((FootPoint)footDatas[i+dataNum/2].GetLatestPoint()).value;

      drawCircle(s.x, s.y, (int)map(tp, 0, 1023, 0, 9));
    }

    fill(0);
    textFont(sergueUI, 15);
    text(footDirection + " foot", w-60, 20);
    popMatrix();
  }

  void drawCircle(int x, int y, int intense) // intense should between 0-9
  {
    strokeWeight(2);
    stroke(255);
    ellipseMode(CENTER);
    float c = map(intense, 0, 9, 200, 0);
    float r = map(intense, 0, 9, 0, w*60/250);
    fill(c);
    ellipse(x, y, r, r);
  }
}

