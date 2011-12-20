class SlidesshowApp extends PApplet {
  int currentImg = 0;
  int imgNum = 3;
  String[] files;
  PImage img;
  int px, py;
  int s_normal = 0;
  int s_left = 1;
  int s_right = 2;
  int preTime;
  int currentTime;
  int interval = 2000;
  
  int instruction=s_right;
  void setup() {
    size(1200,900,P3D);

    files=new String[imgNum];
    for(int i=0; i<imgNum; i++)
    {
      files[i] = path + "/" + i + ".png";
      println(files[i]);
    }
    img=loadImage(files[currentImg]);
    px = width;
    py = 0;
    preTime = millis();
    currentTime = millis();
  }
   
  
   
  void draw() {
    
    switch(instruction)
    {
      case 0:  //normal
        px = 0;
        py = 0;
      break;
      case 1:  //left - get previousImg
        if(px!=0)
          px+=100;
        else
          instruction = s_normal;
      break;
      case 2:  //right  -get nextImg
        if(px!=0)
          px-=100;
        else
          instruction = s_normal;
      break;
    }

    if(img!=null)
    {
      image(img,px,py,width,height);
    }
    
    ControlMove();
  }
  
void slideLeft() {
  currentTime = millis();
  if(currentImg>0 && currentTime-preTime>interval)
  {
    currentImg--;
    img=loadImage(files[currentImg]);
    instruction = s_left;
    px = -width;
    preTime = millis();
  }
}

void slideRight() {
  currentTime = millis();
  if(currentImg<files.length-1 && currentTime-preTime>interval)
  {
    currentImg++;
    img=loadImage(files[currentImg]);
    instruction = s_right;
    px = width;
    preTime = millis();
  }
}

void ControlMove() {
  if (predictedLabel.equals("left")) { 
    slideLeft();
  }
  if (predictedLabel.equals("right")) {  
    slideRight();
  }
}

  void keyPressed() {
    if(keyCode == LEFT)
    {
      slideLeft();
    }
    if(keyCode == RIGHT)
    {
      slideRight(); 
    }
  }
}
