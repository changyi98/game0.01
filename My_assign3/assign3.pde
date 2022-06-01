final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;
//------------------------------------------------------------------------------
PImage[][] soils;
int numFrames = 23;//圖片數量
PImage[] images = new PImage[numFrames];//圖片儲存
//------------------------------------------------------------------------------
final int SOIL_SIZE = 80;//泥土
float t, moveY = 0;//泥土
int x=0, y=0;//泥土
int[][] soilHealth;//泥土
//------------------------------------------------------------------------------
boolean cabbageStart;
int cabbageX, cabbageY, cabbageSize;//高麗菜
int soldierX, soldierX1, soldierY1, soldierY2, soldierY3, soldierSpeed, soldierSize;//兵士
//------------------------------------------------------------------------------
int xPos, yPos;//玩家
int playerSize, playerState;//玩家
boolean downPressed = false, leftPressed = false, rightPressed = false;//按鍵
final int Player_Idle = 1, Player_Down = 2, Player_Left = 3, Player_Right = 4;//玩家

int playerHealth = 0;//HP
float cameraOffsetY = 0;//攝影機

boolean debugMode = false;
//------------------------------------------------------------------------------
void setup()
{
  size(640, 480, P2D);

  images[0] = loadImage("img/bg.jpg");//天空
  images[1] = loadImage("img/title.jpg");//開始畫面
  images[2] = loadImage("img/gameover.jpg");//結束畫面
  images[3] = loadImage("img/startNormal.png");//開始按鈕
  images[4] = loadImage("img/startHovered.png");//開始按鈕（黃）
  images[5] = loadImage("img/restartNormal.png");//重新開始按鈕
  images[6] = loadImage("img/restartHovered.png");//重新開始按鈕（黃）
  images[7] = loadImage("img/soil8x24.png");//長泥土
  images[8] = loadImage("img/groundhogIdle.png");//地鼠
  images[9] = loadImage("img/groundhogDown.png");//地鼠（下）
  images[10] = loadImage("img/groundhogLeft.png");//地鼠（左）
  images[11] = loadImage("img/groundhogRight.png");//地鼠（右）
  images[12] = loadImage("img/stone1.png");//第一層石頭
  images[13] = loadImage("img/stone2.png");//第二層石頭
  images[14] = loadImage("img/life.png");//生命

  images[15] = loadImage("img/soil0.png");//soil(0
  images[16] = loadImage("img/soil1.png");//soil(1
  images[17] = loadImage("img/soil2.png");//soil(2
  images[18] = loadImage("img/soil3.png");//soil(3
  images[19] = loadImage("img/soil4.png");//soil(4
  images[20] = loadImage("img/soil5.png");//soil(4

  images[21] = loadImage("img/soldier.png");//兵士
  images[22] = loadImage("img/cabbage.png");//菜

  playerHealth = 5;

  xPos=0;
  yPos=0;
  playerSize=80;
  t=0.0;
  playerState = Player_Idle;
}

void draw() {
  switch (gameState)
  {
    //------------------------------------------------------------------------------
  case GAME_START: // Start Screen
    image(images[1], 0, 0);
    playerState=Player_Idle;
    t=0.0;
    downPressed=false;
    leftPressed=false;
    rightPressed=false;

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY)
    {
      image(images[4], START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed)
      {
        gameState = GAME_RUN;
        mousePressed = false;
      }
    } else
    {
      image(images[3], START_BUTTON_X, START_BUTTON_Y);
    }
    //------------------------------------------------------------------------------
    soldierX = 0;
    soldierX1 = 0;
    soldierY1 = SOIL_SIZE*(int(random(4)+2));
    soldierY2 = SOIL_SIZE*(int(random(12)+4));
    soldierY3 = SOIL_SIZE*(int(random(18)+8));

    cabbageX = SOIL_SIZE*int(random(8));
    cabbageY = SOIL_SIZE*(int(random(12))+2);

    cabbageStart = true;

    break;
    //------------------------------------------------------------------------------
  case GAME_RUN: // In-Game
    // Background
    image(images[0], 0, 0);
    // Sun
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120);

    if (debugMode)
    {
      pushMatrix();
      translate(0, cameraOffsetY);
    }

    if (moveY > -1600)
    {
      moveY = SOIL_SIZE - yPos;
    }

    pushMatrix();
    translate(0, moveY);
    //泥土--------------------------------------------------------------------------------
    for (int i=0; i<width; i+=SOIL_SIZE) {
      for (int n=160; n<160+SOIL_SIZE*4; n+=SOIL_SIZE)
      {
        image(images[15], i, n);
      }
      for (int n=480; n<480+SOIL_SIZE*4; n+=SOIL_SIZE)
      {
        image(images[16], i, n);
      }
      for (int n=800; n<800+SOIL_SIZE*4; n+=SOIL_SIZE)
      {
        image(images[17], i, n);
      }
      for (int n=1120; n<1120+SOIL_SIZE*4; n+=SOIL_SIZE)
      {
        image(images[18], i, n);
      }
      for (int n=1440; n<1440+SOIL_SIZE*4; n+=SOIL_SIZE)
      {
        image(images[19], i, n);
      }
      for (int n=1760; n<1760 + SOIL_SIZE*4; n+=SOIL_SIZE)
      {
        image(images[20], i, n);
      }
    }

    //1~8石頭--------------------------------------------------------------------------------
    pushMatrix();
    translate(0, 160);
    y=0;
    x = SOIL_SIZE;
    for (int i=0; i<8; i++)
    {
      x = i*SOIL_SIZE;
      image(images[12], x, y);
      y += SOIL_SIZE;
    }

    popMatrix();

    //9~16-石頭-------------------------------------------------------------------------------
    pushMatrix();
    translate(0, 160+SOIL_SIZE*8);
    y=0;
    x = SOIL_SIZE;
    for (int i=0; i<4; i++)
    {
      for (int n=0; n<4; n++)
      {
        x = (i+1)*SOIL_SIZE;
        y = n*SOIL_SIZE;
        if (i>1)
        {
          x = (i+3)*SOIL_SIZE;
        }
        if (n>=1)
        {
          y = (n+2)*SOIL_SIZE;
        }
        if (n>=3)
        {
          y = (n+4)*SOIL_SIZE;
        }
        image(images[12], x, y);
      }
    }
    for (int i=0; i<4; i++)
    {
      for (int n=0; n<4; n++)
      {
        x = i*SOIL_SIZE;
        y = (n+1)*SOIL_SIZE;
        if (i>0)
        {
          x = (i+2)*SOIL_SIZE;
        }
        if (i==3)
        {
          x = (i+4)*SOIL_SIZE;
        }
        if (n>=2)
        {
          y = (n+3)*SOIL_SIZE;
        }
        image(images[12], x, y);
      }
    }
    popMatrix();

    //17~24-石頭-------------------------------------------------------------------------------
    pushMatrix();
    translate(-SOIL_SIZE*6, 160+SOIL_SIZE*16);
    y=0;
    x=0;
    for (int n=0; n<5; n++)
    {
      pushMatrix();
      translate(n*SOIL_SIZE*3, 0);
      for (int i=7; i>-1; i--)
      {
        int x1, x2;
        x1 = SOIL_SIZE*i;
        image(images[12], x1, y);
        x2 = SOIL_SIZE*(i+1);
        image(images[12], x2, y);
        image(images[13], x2, y);
        y += SOIL_SIZE;
      }
      y=0;
      popMatrix();
    }
    popMatrix();

    strokeWeight(15);
    stroke(24, 204, 25);
    line(0, 152.5, 640, 152.5);

    //玩家移動-player--------------------------------------------------------------------------------
    switch(playerState)
    {
    case Player_Idle:
      image(images[8], xPos, yPos);
      t=0.0;
      break;

    case Player_Down:
      image(images[9], xPos, yPos);
      yPos += (80.0/15.0);
      t++;
      break;

    case Player_Right:
      image(images[11], xPos, yPos);
      xPos += (80.0/15.0);
      t++;
      break;

    case Player_Left:
      image(images[10], xPos, yPos);
      xPos -= (80.0/15.0);
      t++;
      break;
    }
    if (xPos > width-playerSize)
    {
      xPos = width-playerSize;
    }
    if (xPos < 0)
    {
      xPos = 0;
    }
    if (yPos > 160+24*SOIL_SIZE-playerSize)
    {
      yPos = 160+24*SOIL_SIZE-playerSize;
    }
    if (yPos < 80)
    {
      yPos = 80;
    }

    if (t==15.0)
    {
      playerState=Player_Idle;
      if (xPos%SOIL_SIZE < 10)
      {
        xPos=xPos-xPos%SOIL_SIZE;
      } else {
        xPos=xPos-xPos%SOIL_SIZE+SOIL_SIZE;
      }
      if (yPos%SOIL_SIZE < 10)
      {
        yPos=yPos-yPos%SOIL_SIZE;
      } else
      {
        yPos=yPos-yPos%SOIL_SIZE+SOIL_SIZE;
      }
    }
    //白菜--------------------------------------------------------------------------------
    if (cabbageStart)
    {
      image(images[22], cabbageX, cabbageY);

      if (xPos<cabbageX+SOIL_SIZE && xPos+SOIL_SIZE>cabbageX
        && yPos<cabbageY+SOIL_SIZE && yPos+SOIL_SIZE>cabbageY)
      {
        cabbageStart=false;
        playerHealth++;
      }
    }
    //兵士--------------------------------------------------------------------------------
    image(images[21], soldierX-80, soldierY1);
    image(images[21], soldierX-80, soldierY2);
    image(images[21], soldierX1-80, soldierY3);

    soldierX += 3;
    soldierX1 += 12;
    soldierX %= 720;
    soldierX1 %= 720;

    if (xPos < soldierX-80+SOIL_SIZE && xPos+SOIL_SIZE > soldierX-80
      && yPos < soldierY1+SOIL_SIZE && yPos+SOIL_SIZE > soldierY1)
    {
      playerHealth--;
      playerState = Player_Idle;
    }
    if (xPos < soldierX-80+SOIL_SIZE && xPos+SOIL_SIZE > soldierX-80
      && yPos < soldierY2+SOIL_SIZE && yPos+SOIL_SIZE > soldierY2)
    {
      playerHealth--;
      playerState = Player_Idle;
    }
    if (xPos < soldierX1-80+SOIL_SIZE && xPos+SOIL_SIZE > soldierX1-80
      && yPos < soldierY3+SOIL_SIZE && yPos+SOIL_SIZE > soldierY3)
    {
      playerHealth--;
      playerState = Player_Idle;
    }
    //--------------------------------------------------------------------------------
    popMatrix();

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode)
    {
      popMatrix();
    }
    //HP--------------------------------------------------------------------------------
    if (playerHealth >= 5) playerHealth = 5;
    for (int i=0; i<playerHealth; i++)
    {
      image(images[14], 10+i*70, 10);
    }
    if (playerHealth == 0)
    {
      gameState = GAME_OVER;
    }
    break;
    //----------------------------------------------------------------------------------
  case GAME_OVER: // Gameover Screen
    image(images[2], 0, 0);
    downPressed=false;
    leftPressed=false;
    rightPressed=false;

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY)
    {
      image(images[6], START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        playerHealth = 5;
        mousePressed = false;
        moveY=0;
        xPos = 320;
        yPos = 80;
        playerState=Player_Idle;
        t=0.0;

        soldierY1 = 80*int(random(2, 6));
        soldierY2 = 80*int(random(8, 12));
        soldierY3 = 80*int(random(18, 20));
        cabbageX = 80*int(random(0, 8));
        cabbageY = 80*int(random(12, 18));
      }
    } else
    {
      image(images[5], START_BUTTON_X, START_BUTTON_Y);
    }
    break;
  }
}
    //----------------------------------------------------------------------------------
void keyPressed()
{
  if (key == CODED)
  {
    switch(keyCode)
    {
    case DOWN:
      if (playerState == Player_Idle)
      {
        downPressed=true;
        playerState = Player_Down;
        t=0.0;
      }
    case RIGHT:
      if (playerState == Player_Idle)
      {
        rightPressed=true;
        playerState = Player_Right;
        t=0.0;
      }
      break;

    case LEFT:
      if (playerState == Player_Idle)
      {
        leftPressed=true;
        playerState = Player_Left;
        t=0.0;
      }
      break;
    }
    switch(key) {
    }
  }
}
