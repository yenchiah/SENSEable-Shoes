import processing.serial.*;
import controlP5.*;
import javax.swing.JFrame;

//////////////// OSC variables//////////////////////
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 11000;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12000;
String myConnectPattern = "/shoes";
String myDisconnectPattern = "/server/disconnect";
String predictedLabel = "test";
/////////////////////////////////////////////////////

JFrame frame;

PApplet snakesApp;
PApplet slidesApp;
PApplet robotApp;

ControlP5 controlP5;
ControlFont font;

PFont sergueUI;

int dataNum = 12;

String scaleMode;

FootWindow leftFootWindow;
FootWindow rightFootWindow;

LineWindow leftLineWindow;
LineWindow rightLineWindow;


PostureWindow postureWindow; 

//GestureWindow rightGestureWindow;

FootData[] footDatas = new FootData[dataNum];

FootData leftMeanData;
FootData rightMeanData;

long packetCount = 0;

int currentGestureStatus = -1;

int counter = 0;
int start = 0;

int counter1 = 0;
int start1 = 0;

int footstatus = 0;  

String path;

Serial myPort;    // The serial port: 
  
void setup()
{
  //////////////// OSC variables//////////////////////
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(25);
  ////////////////////////////////////////////////////
  
  //frameRate(24);
  for (int i=0; i<dataNum; i++)
  {
    footDatas[i] = new FootData();
  }
  leftMeanData = new FootData();
  rightMeanData = new FootData();
  
  // initial UI

  size(1200, 700);
  smooth();  

  //set up controls
  controlP5 = new ControlP5(this);
  controlP5.setColorLabel(color(255));
  controlP5.setColorForeground(color(100));
  controlP5.setColorActive(color(0));
  controlP5.setColorBackground(color(242, 140, 62));
  controlP5.addButton("Save & Exit", 255, width/5+20, height/70, 60, 30).setId(0);
  controlP5.addButton("Exit without Save", 255, width/5+20+60+10, height/70, 90, 30).setId(1);
  controlP5.addButton("Snakes", 255, width-40-15, height/70, 40, 30).setId(2);
  controlP5.addButton("Slides", 255, width-70-30, height/70, 35, 30).setId(3);
  controlP5.addButton("Robot", 255, width- 100-45, height/70, 35, 30).setId(4);
  
  sergueUI = loadFont("SegoeUI-Light-30.vlw");

  leftFootWindow = new FootWindow(10, 50, width/5, "left");
  rightFootWindow = new FootWindow(10+width/5, 50, width/5, "right");

  rightLineWindow = new LineWindow(10+2*width/5, height/2-100+45, width/2+90, height/2-100, "right");
  leftLineWindow = new LineWindow(10+2*width/5, 50, width/2+90, height/2-100, "left");
//  
  postureWindow = new PostureWindow(10+2*width/5, height-170, width/2+95, 120);

  // = new GestureWindow(width/2+width/7+width/10, 45, width/7, rightFootWindow.h);

  background(240, 240, 240);

  textFont(sergueUI, 12);
  fill(0);
  text("Powered by Huaishu & Yen-Chia, CoDe Lab, Carnegie Mellon University", width-370, height-12);

  textFont(sergueUI, 19);
  fill(242, 140, 62);
  text("SENSEable Shoes Monitor", 15, 30);

   path = sketchPath;
   
   //myPort = new Serial(this, Serial.list()[4], 115200);
    myPort = new Serial(this, "COM17", 115200);
}

void stop() {
  if(myPort!=null)
  {
    myPort.clear();
    myPort.stop();
  }
}
/*
void UpdateGesture()
{
  if (footDatas[2].GetLatestPoint().value>600 && footDatas[3].GetLatestPoint().value>300 && footDatas[4].GetLatestPoint().value<150 && footDatas[5].GetLatestPoint().value<700)
    currentGestureStatus = 0;

  else if (footDatas[2].GetLatestPoint().value<550 && footDatas[3].GetLatestPoint().value<150 && footDatas[5].GetLatestPoint().value>750)
    currentGestureStatus = 1;

  else if (footDatas[2].GetLatestPoint().value>600 && footDatas[5].GetLatestPoint().value>600 && footDatas[3].GetLatestPoint().value<50)
    currentGestureStatus = 2;

  else if (footDatas[0].GetLatestPoint().value<200 && footDatas[1].GetLatestPoint().value<500 && footDatas[3].GetLatestPoint().value>500 && footDatas[4].GetLatestPoint().value>500)
    currentGestureStatus = 3;
  
//  else if
  else
    currentGestureStatus = -1;
}
*/

void draw()
{
  leftFootWindow.update();
  leftFootWindow.draw();

  rightFootWindow.update();
  rightFootWindow.draw();
  
  leftLineWindow.update();
  leftLineWindow.draw();
  
  rightLineWindow.update();
  rightLineWindow.draw();

  postureWindow.update();
  postureWindow.draw();

  //UpdateGesture();
  //rightGestureWindow.update();
  //rightGestureWindow.draw();


//  println(footDatas[2].peak.extrema);
//  print("delta: ");



}

void controlEvent(ControlEvent theEvent)
{
  switch(theEvent.controller().id())
  {
    case(0):
    SaveData();
    stop();
    exit();
    break;

    case(1):
    stop();
    exit();
    break;

    case(2):
      frame = new JFrame();
      snakesApp = new SnakesApplet();
      frame.getContentPane().add(snakesApp);
      frame.setVisible(true); 
      frame.setLocation(100,100);  
      snakesApp.init();
      frame.setSize(410,410);
    break;
    
    case(3):
      frame = new JFrame();
      slidesApp = new SlidesshowApp();
      frame.getContentPane().add(slidesApp);
      frame.setUndecorated(true);
      frame.setVisible(true);
      frame.setLocation(100,100);
      slidesApp.init();
      frame.setSize(1200,900);
    break;
    
    case(4):
      frame = new JFrame();
      robotApp = new RobotApplet();
      frame.getContentPane().add(robotApp);
      frame.setVisible(true);
      frame.setLocation(100,100);
      robotApp.init();
      frame.setSize(400,200);
    break;
  }
}

//void serialEvent(Serial myPort)
//{
//  String[] incomingValues = split(myPort.readString(), ',');
//
//  //println(incomingValues);
//
//  int leftTempMean = 0;
//  int rightTempMean = 0;
//  
//  if (incomingValues.length > 1) 
//  {
//    packetCount++;
//
//    if (packetCount > dataNum)
//    {
//      for (int i=0; i<incomingValues.length;i++)
//      {
//        int newValue = Integer.parseInt(incomingValues[i].trim());
//        if(i<incomingValues.length/2)
//          rightTempMean+=newValue;
//        else
//          leftTempMean += newValue;
//          
//        footDatas[i].AddDataPoint(newValue);
//        
//        if(i==2 && start == 1)
//          counter++;
//          
//        if(i==2 && start1 == 1)
//          counter1++;
//          
//        if(i==2)
//          footDatas[2].UpdateExtrema();
//      }
//
//      rightMeanData.AddDataPoint(rightTempMean/(incomingValues.length/2));
//      leftMeanData.AddDataPoint(leftTempMean/(incomingValues.length/2));
//
//    }
//  }
//}

void SaveData()
{
  String filename = Integer.toString(month()) + '-' 
    + Integer.toString(day()) + '-'
    + Integer.toString(year()) + '-'
    + Integer.toString(hour()) + '-'
    + Integer.toString(minute()) + '-'
    + Integer.toString(second())+".txt";

  String buffer = new String();
  if (footDatas.length>0)
  {
    for (int i=0; i<footDatas[0].size();i++)
    {
      for (int j=0; j<footDatas.length;j++)
      {
        FootPoint fp = footDatas[j].GetPoint(i);
        String tp = Integer.toString(fp.value) + '-' + fp.time + ';';
        buffer += tp;
      }
      buffer += '\n';
    }
    String[] data = split(buffer, '\n');
    saveStrings(filename, data);
  }
  print(filename);
}

void keyPressed()
{
  snakesApp.keyPressed();
}

//////////////// OSC function //////////////////////
void oscEvent(OscMessage theOscMessage)
{
  String printt = "";
  int leftTempMean = 0;
  int rightTempMean = 0;
  //theOscMessage.arguments()[i]
  //i=0~5 -> values from left shoe
  //i=6~11 -> values from right shoe
  //i=12 -> predicted label
  for(int i=0;i<theOscMessage.arguments().length-1;i++)
  {
    int value = Integer.parseInt(theOscMessage.arguments()[i].toString());
    footDatas[i].AddDataPoint(value);
    if(i<(theOscMessage.arguments().length-1)/2)
      rightTempMean += value;
    else
      leftTempMean += value;
    printt += theOscMessage.arguments()[i].toString();
    printt += ", ";
  }
  predictedLabel = theOscMessage.arguments()[theOscMessage.arguments().length-1].toString();
  rightMeanData.AddDataPoint(rightTempMean/(theOscMessage.arguments().length-1)/2);
  leftMeanData.AddDataPoint(leftTempMean/(theOscMessage.arguments().length-1)/2);
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern))
  {
    connect(theOscMessage.netAddress().address());
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern))
  {
    disconnect(theOscMessage.netAddress().address());
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddresList. 
   */
  else
  {
    oscP5.send(theOscMessage, myNetAddressList);
  }
}

//////////////// OSC function //////////////////////
private void connect(String theIPaddress)
{
  if (!myNetAddressList.contains(theIPaddress, myBroadcastPort))
  {
    myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
    println("### adding "+theIPaddress+" to the list.");
  }
  else 
  {
    //println("### "+theIPaddress+" is already connected.");
  }
  //println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
}

//////////////// OSC function //////////////////////
private void disconnect(String theIPaddress)
{
  if (myNetAddressList.contains(theIPaddress, myBroadcastPort))
  {
    myNetAddressList.remove(theIPaddress, myBroadcastPort);
    println("### removing "+theIPaddress+" from the list.");
  }
  else
  {
    println("### "+theIPaddress+" is not connected.");
  }
    println("### currently there are "+myNetAddressList.list().size());
}
