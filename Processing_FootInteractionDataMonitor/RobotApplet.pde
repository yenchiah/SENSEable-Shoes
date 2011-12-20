


class RobotApplet extends PApplet { 

  
  PFont myFont;     // The display font: 
  String inString;  // Input string from serial port: 
  int lf = 10;      // ASCII linefeed 
  
  
  final byte[] ROBOT_SAPIENS = new byte[] {0x2A, 0x49, 0x03, 0x49, 0x01, intToUnsignedByte(0x0D), 0x05, 0x02, 0x08, 0x06, intToUnsignedByte(0x83), 0x01, intToUnsignedByte(0xA0), 0x01, intToUnsignedByte(0xA0)};
  final byte[] MOVE_FORWARD = new byte[] {0x69, intToUnsignedByte(0x86),  0x00, 0x00};
  final byte[] MOVE_BACKWARD = new byte[] {0x69, intToUnsignedByte(0x87),  0x00, 0x00};
  final byte[] MOVE_LEFT = new byte[] {0x69, intToUnsignedByte(0x88),  0x00, 0x00};
  final byte[] MOVE_RIGHT = new byte[] {0x69, intToUnsignedByte(0x80),  0x00, 0x00};
  final byte[] MOVE_STOP = new byte[] {0x69, intToUnsignedByte(0x8E),  0x00, 0x00};
  
  int robotCondition;
  int CONDITION_STOP = 0;
  int CONDITION_LEFT = 1;
  int CONDITION_RIGHT = 2;
  int CONDITION_FORWARD = 3;
  int CONDITION_BACKWARD = 4;
  
  void setRobotCondition(int c)
  {
    robotCondition = c;
  }
  
  void setup() { 
    size(400,200); 
    // You'll need to make this font with the Create Font Tool 
    myFont = createFont("Arial", 20, true);
    textFont(myFont, 18); 
    // List all the available serial ports: 
    println(Serial.list()); 
    // I know that the first port in the serial list on my mac 
    // is always my  Keyspan adaptor, so I open Serial.list()[0]. 
    // Open whatever port is the one you're using. 
    
    
    myPort.bufferUntil(lf); 
    
    
    myPort.write(ROBOT_SAPIENS);
    background(0); 
    fill(255,255,255);
    text("Go Robosapien!", width/2-60,height/2-9);
  } 
   
  void stop() {
    if(robotCondition != CONDITION_STOP)
    {   
      for(int i=0;i<5;i++)
      {
        myPort.write(MOVE_STOP);
        delay(50);
      }
      setRobotCondition(CONDITION_STOP);
      println("STOP");
      background(0); 
      text("STOP", width/2-60,height/2-9); 
    }
  }
  
  void left() {
    if(robotCondition != CONDITION_LEFT)
    {
      
      for(int i=0;i<5;i++)
      {
        myPort.write(MOVE_LEFT);
        delay(50);
      }
      setRobotCondition(CONDITION_LEFT);
      println("LEFT");
      background(0); 
      text("LEFT", width/2-60,height/2-9); 
    }
  }
  
  void right() {
    if(robotCondition != CONDITION_RIGHT)
    {    
      for(int i=0;i<5;i++)
      {
        myPort.write(MOVE_RIGHT);
        delay(50);
      }
      setRobotCondition(CONDITION_RIGHT);
      println("RIGHT");
      background(0); 
      text("RIGHT", width/2-60,height/2-9); 
    }
  }
  
  void forward() {
    if(robotCondition != CONDITION_FORWARD)
    {
      for(int i=0;i<5;i++)
      {
        myPort.write(MOVE_FORWARD);
        delay(50);
      }
      setRobotCondition(CONDITION_FORWARD);
      println("FORWARD");
      background(0); 
      text("FORWARD", width/2-60,height/2-9); 
    }
  }
  
  void backward() {
    if(robotCondition != CONDITION_BACKWARD)
    {
      for(int i=0;i<5;i++)
      {
        myPort.write(MOVE_BACKWARD);
        delay(50);
      }
      setRobotCondition(CONDITION_BACKWARD);
      println("BACK");
      background(0); 
      text("BACKWARD", width/2-60,height/2-9); 
    }  
  }
  
  
  void draw() { 
    ControlMove();
    
  } 
  
  void ControlMove() {
    if (predictedLabel.equals("walkFront")) {      
      forward();
    }
    if (predictedLabel.equals("walkBack")) {   
      backward();
    }
    if (predictedLabel.equals("turnLeft")) { 
      left();
    }
     if (predictedLabel.equals("turnRight")) {  
      right();
    }
    if (predictedLabel.equals("stand")) {      
      stop();
    }
  }
  
  void keyPressed() {
    if(keyCode == UP )
    {
      forward();
    }
    else if(keyCode  == DOWN)
    {
      backward();
    }
    else if(keyCode  == LEFT)
    {
      left();
    }
    else if(keyCode  == RIGHT)
    {
      right();
    }
    else if(keyCode == CONTROL)
    {
      stop();
    }
  }
  
  public byte intToUnsignedByte(final int i)
  {
    if (i < 0)
    {
      return 0;
    }
    else if (i > 255)
    {
      return (byte)255;
    }
    
    return (byte)i;
  }
}

