class LineWindow
{
  String footDirection;
  int x, y, w, h;
  long leftTime, rightTime;
  color [] displayColor = new color[dataNum];


  LineWindow(int _x, int _y, int _w, int _h, String s)
  {
    footDirection = s;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    displayColor[0] = color(0, 100, 0);
    displayColor[1] = color(255, 255, 0);
    displayColor[2] = color(255, 0, 0);
    displayColor[3] = color(160, 32, 140);
    displayColor[4] = color(30, 144, 255);
    displayColor[5] = color(154, 205, 50);
  }  

  void update()
  {
  }

  void draw()
  {

    pushMatrix();
    translate(x, y);
    strokeWeight(5);
    stroke(255);
    fill(220);
    rect(5, 0, w, h-5);

    //draw lines
    strokeWeight(2);
    noFill();
    rightTime = millis();

    leftTime = rightTime - w/100*1000;

    textFont(sergueUI, 15);

    //each foot pressure data
    for (int j=0; j<dataNum/2;j++)
    {

      beginShape();
      FootData thisData = null;

      if (footDirection == "right")
        thisData = footDatas[j];
      else if (footDirection == "left")
        thisData = footDatas[j+dataNum/2];

      stroke(displayColor[j]);

      for (int i=0; i<thisData.size();i++)
      {

        FootPoint thisPoint = thisData.GetPoint(i);

        if ((thisPoint.time>=leftTime) && (thisPoint.time <=rightTime))
        {
          int pointX = (int)mapLong(thisPoint.time, leftTime, rightTime, 10, w);
          int pointY = (int)map(thisPoint.value, 0, 1023, h-50, 50);

          curveVertex(pointX, pointY);
        }
      }
      endShape();
    }

    //mean data curve
    beginShape();
    stroke(0);
    strokeWeight(5);
    if (footDirection == "right")
    {    
      for (int i=0; i<rightMeanData.size();i++)
      {
        FootPoint thisPoint = rightMeanData.GetPoint(i);

        if ((thisPoint.time>=leftTime) && (thisPoint.time <=rightTime))
        {
          int pointX = (int)mapLong(thisPoint.time, leftTime, rightTime, 10, w);
          int pointY = (int)map(thisPoint.value, 0, 1023, h-50, 50);

          curveVertex(pointX, pointY);
        }
      }
    }
    else if (footDirection == "left")
    {    
      for (int i=0; i<rightMeanData.size();i++)
      {
        FootPoint thisPoint = leftMeanData.GetPoint(i);

        if ((thisPoint.time>=leftTime) && (thisPoint.time <=rightTime))
        {
          int pointX = (int)mapLong(thisPoint.time, leftTime, rightTime, 10, w);
          int pointY = (int)map(thisPoint.value, 0, 1023, h-50, 50);

          curveVertex(pointX, pointY);
        }
      }
    }
    endShape();

    //numbers
    for (int i=0; i<footDatas.length;i++)
    {
      fill(displayColor[i]);
      if(footDirection == "right" && i<footDatas.length/2)
      {
        fill(displayColor[i]);
        text(footDatas[i].GetLatestPoint().value, 20+i*40, 20);
      }
      else if(footDirection == "left" && i>=footDatas.length/2)
      {
        fill(displayColor[i-footDatas.length/2]);
        text(footDatas[i].GetLatestPoint().value, 20+(i-footDatas.length/2)*40, 20);
      }
    }
    fill(0);
    
    if(footDirection == "right")
      text(rightMeanData.GetLatestPoint().value, dataNum*30, 20);
    else if(footDirection == "left")
      text(leftMeanData.GetLatestPoint().value, dataNum*30, 20);      

    text(footDirection + " foot data", w-100, 20);

    popMatrix();
  }
}

long mapLong(long x, long in_min, long in_max, long out_min, long out_max) { 
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) +  out_min;
}

