// Snakes
// By: Anson Liang
// This is a classic snake game, just made it for fun.
//

// Modefied by Nuno


class SnakesApplet extends PApplet {
  color col=color(255, 255, 192);
  color foodColor = color(255, 0, 0);
  float speed = 100;
  int cx, cy;

  int moveX = 0;
  int moveY = 0;
  int snakeX = 0;
  int snakeY = 0;
  int foodX = -1;
  int foodY = -1;
  boolean check = true;
  int []snakesX;
  int []snakesY;
  int snakeSize = 1;
  int windowSize = 400;
  boolean gameOver = false;
  PFont Font = createFont("Arial", 20, true);

  public void setup()
  {
    size(int(windowSize), int(windowSize));

    background(0);
    speed = 10;
    speed=speed/frameRate;
    snakesX = new int[100];
    snakesY = new int[100];

    cx = width/2;
    cy = height/2;

    snakeX = cx-5;
    snakeY = cy-5;
    foodX = -1;
    foodY = -1;
    gameOver = false;
    check = true;
    snakeSize =1;
  }

  public void draw()
  {
    if (speed%50 == 0) {
      background(0);
      runGame();
    }
    speed++;
  }

  void reset() {
    snakeX = cx-5;
    snakeY = cy-5;
    gameOver = false;
    check = true;
    snakeSize =1;
    moveY = 0;
    moveX = 0;
  }
  void runGame() {
    if (gameOver== false) {
      ControlMove();
      drawfood();
      drawSnake();
      snakeMove();
      ateFood();
      checkHitSelf();
    }
    else {
      ControlMove();
      String modelString = "game over";
      textAlign (CENTER);
      textFont(Font);
      text(modelString, windowSize/2-20, windowSize/2-20, 40);
    }
  }
  void checkHitSelf() {
    for (int i = 1; i < snakeSize; i++) {
      if (snakeX == snakesX[i] && snakeY== snakesY[i]) {
        gameOver = true;
      }
    }
  }
  void ateFood() {
    if (foodX == snakeX && foodY == snakeY) {
      check = true;
      snakeSize++;
    }
  }
  void drawfood() {
    fill(foodColor);
    while (check) {
      int x = (int)random(1, windowSize/10);
      int y =  (int)random(1, windowSize/10);
      foodX = 5+x*10;
      foodY = 5+y*10;

      for (int i = 0; i < snakeSize; i++) {
        if (x == snakesX[i] && y == snakesY[i]) {
          check = true;
          i = snakeSize;
        }
        else {
          check = false;
        }
      }
    }

    rect(foodX-5, foodY-5, 10, 10);
  }
  void drawSnake() {
    fill(col);

    for (int i = 0; i < snakeSize; i++) {
      int X = snakesX[i];
      int Y = snakesY[i];
      rect(X-5, Y-5, 10, 10);
    }

    for (int i = snakeSize; i > 0; i--) {
      snakesX[i] = snakesX[i-1];
      snakesY[i] = snakesY[i-1];
    }
  }

  void snakeMove() {
    snakeX += moveX;
    snakeY += moveY;
    if (snakeX > windowSize-5 || snakeX < 5||snakeY > windowSize-5||snakeY < 5) {
      gameOver = true;
    }
    snakesX[0] = snakeX;
    snakesY[0] = snakeY;
  }

  void ControlMove() {
//    if (currentGestureStatus == 2) {  
    if (predictedLabel.equals("up")) {      
      if (snakesY[1] != snakesY[0]-10) {
        moveY = -10; 
        moveX = 0;
      }
    }
//    if (currentGestureStatus == 3) {  
    if (predictedLabel.equals("down")) {   
      if (snakesY[1] != snakesY[0]+10) {
        moveY = 10; 
        moveX = 0;
      }
    }
//    if (currentGestureStatus == 0) { 
    if (predictedLabel.equals("left")) { 
      if (snakesX[1] != snakesX[0]-10) {
        moveX = -10; 
        moveY = 0;
      }
    }
//    if (currentGestureStatus == 1) {
     if (predictedLabel.equals("right")) {  
      if (snakesX[1] != snakesX[0]+10) {
        moveX = 10; 
        moveY = 0;
      }
    }
//    if (gameOver == true && currentGestureStatus != -1) {
    if (gameOver == true && predictedLabel.equals("stand")) {      
      reset();
    }
  }
}

