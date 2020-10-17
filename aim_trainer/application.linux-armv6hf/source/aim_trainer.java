import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class aim_trainer extends PApplet {

//SETUP
final int MENUSCREEN = 1;
final int GAMESCREEN = 0;
int screenState = MENUSCREEN;
public void setup() {
  
  newTarget(2); // Make initial target41
  menuSetup();
}

//MAIN DRAW THREAD
public void draw() {
  if (screenState == MENUSCREEN) {
    drawMenu();
  } else if (screenState == GAMESCREEN) {
    drawGame();
  } else {
    println("Something went wrong!");
  }
}

//main keypressed input
public void keyPressed() {
  if (screenState == MENUSCREEN) {
    menukeyPressed();
  } else if (screenState == GAMESCREEN) {
    gamekeyPressed();
  } else {
    println("Something went wrong!");
  }
}

public void mousePressed(){
  if (screenState == MENUSCREEN) {
    menumousePressed();
  } else if (screenState == GAMESCREEN) {
    gamemousePressed();
  } else {
    println("Something went wrong!");
  }
}
Timer timer = new Timer();

class Timer {
  int time;
  int duration;
  Timer() {
    duration = 100;
    reset();
  }
  public void reset() {
    time = millis() + duration;
  }
  public boolean alarm() {
    if ( millis() > time ) {
      time = millis() + duration;
      return true;
    }
    return false;
  }
}
ColorPicker cp;
int col = 0xffffffff;

public class ColorPicker 
{
  int x, y, w, h, c;
  PImage cpImage;
  
  public ColorPicker ( int x, int y, int w, int h, int c )
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = c;
    
    cpImage = new PImage( w, h );
    
    init();
  }
  
  private void init ()
  {
    // draw color.
    int cw = w - 60;
    for( int i=0; i<cw; i++ ) 
    {
      float nColorPercent = i / (float)cw;
      float rad = (-360 * nColorPercent) * (PI / 180);
      int nR = (int)(cos(rad) * 127 + 128) << 16;
      int nG = (int)(cos(rad + 2 * PI / 3) * 127 + 128) << 8;
      int nB = (int)(Math.cos(rad + 4 * PI / 3) * 127 + 128);
      int nColor = nR | nG | nB;
      
      setGradient( i, 0, h/2, 0xFFFFFF, nColor );
      setGradient( i, (h/2), h/2, nColor, 0x000000 );
    }
    
    // draw black/white.
    drawRect( cw, 0,   30, h/2, 0xFFFFFF );
    drawRect( cw, h/2, 30, h/2, 0 );
    
    // draw grey scale.
    for( int j=0; j<h; j++ )
    {
      int g = 255 - (int)(j/(float)(h-1) * 255 );
      drawRect( w-30, j, 30, 1, color( g, g, g ) );
    }
  }

  private void setGradient(int x, int y, float h, int c1, int c2 )
  {
    float deltaR = red(c2) - red(c1);
    float deltaG = green(c2) - green(c1);
    float deltaB = blue(c2) - blue(c1);

    for (int j = y; j<(y+h); j++)
    {
      int c = color( red(c1)+(j-y)*(deltaR/h), green(c1)+(j-y)*(deltaG/h), blue(c1)+(j-y)*(deltaB/h) );
      cpImage.set( x, j, c );
    }
  }
  
  private void drawRect( int rx, int ry, int rw, int rh, int rc )
  {
    for(int i=rx; i<rx+rw; i++) 
    {
      for(int j=ry; j<ry+rh; j++) 
      {
        cpImage.set( i, j, rc );
      }
    }
  }
  
  public void render ()
  {
    image( cpImage, x, y );
    if( mousePressed &&
  mouseX >= x && 
  mouseX < x + w &&
  mouseY >= y &&
  mouseY < y + h )
    {
      c = get( mouseX, mouseY );
    }
    fill( c );
    col = color(c);
    rect( x, y+h+10, 20, 20 );
  }
}
//SETUP
float x,y,s;

//DRAW GAME TO SCREEN
public void drawGame() {
  if (counter < targets-1) {
    background(0);
    fill(col);
    circle(x, y, s);
    gameExit();
    if( timer.alarm() ){
      newTarget(0);
      xdif[counter] = 5000; ydif[counter] = 5000;
      counter = counter+1;
    }
  } else {
    gotoMenu();
  }
}

public void gameExit() {
  fill(0xffb50c00);
  circle(780, 20, 30);
  fill(0xffffffff);
  text("X", 771, 31);
}

//GAME INPUT MECHANICS
public void newTarget(int f) {
  s = random(PApplet.parseInt(mintargetsize),PApplet.parseInt(maxtargetsize));
  x = random(0, width - s);
  y = random(0, height - s);  
  if (f == 1) {
    th = th + 1;
  } else if (f == 0) {
    tm = tm + 1;
  }
  f = 2;
}

public void gamemousePressed() {
  if( overCircle(780, 20, 30)) {
    gotoMenu();
  } else if( overCircle(x, y, s) ){
    newTarget(1);
    calcDiff(mouseX, mouseY, (int)x, (int)y);
    counter = counter+1;
  } else {
    calcDiff(mouseX, mouseY, (int)x, (int)y);
    mhcol[counter] = 1;
    counter = counter+1;
    tm = tm +1;
  }
}
//END GAME AND GO BACK TO MENU
public void gamekeyPressed() {
  if ( screenState == GAMESCREEN && key == 'r' || key == 'R') {
    gotoMenu();
  }
}

public void gotoMenu() {
    screenState = MENUSCREEN;
    for (int i = 0; i <= xdif.length; i++) {
      xdiftol += xdif[i];
      ydiftol += ydif[i];
    }

    if (tm == 0) {
    } else {
      tm = tm - 1;
    }
}

public Boolean overCircle(float xx, float yy, float ss) {
  float disX = xx - mouseX;
  float disY = yy - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < ss/2 ) {
    return true;
  } else {
    return false;
  }
}
//SETUP
int mintargetsize=30; 
int maxtargetsize=30; 
VScrollbar vs1;
public void menuSetup() {
    cp = new ColorPicker( 50, 205, 205, 100, 255 );
    vs1 = new VScrollbar(285, 120, 20, 215, 3);
}

//DRAW MENU
public void drawMenu() {
  background(51);
  options();
  stats();
  startGame();
  cp.render();
  vs1.update();
  vs1.display();
}

public void startGame() {
  fill(0, 102, 153);
  rect(30, 400, 740, 55, 7);
  fill(0xffFFFFFF);
  textSize(30);
  text("START AIM TRAINER", 250, 437.5f);
}

public void stats() {
  fill(71);
  rect(380, 40, 390, 310, 7);
  fill(0xfffff3af);  textSize(30);
  text("PERFORMANCE", 470, 75);
  fill(0xffffffff);textSize(15);
  basicStats();
  targetGraph();
  advancedStats();
}

public void advancedStats() {
  fill(91);  rect(550, 80, 210, 260, 7);
  fill(0xffffffff);  textSize(21);
  text("ADVANCED STATS", 560, 105);
}

public void targetGraph() {
  fill(91);  rect(390, 190, 150, 150, 7);
  fill(0xffffffff);  textSize(24);
  text("ACCURACY", 400, 217);
  fill(0xff00ff37);  circle(510, 250, 10);
  fill(0xffffffff);  textSize(15); text("HIT", 505, 270);
  fill(0xffff0000);  circle(510, 290, 10);
  fill(0xffffffff);  textSize(15); text("MISS", 505, 310);
  drawTarget(400, 230, 101);
}

public void basicStats() {
  fill(91);
  rect(390, 80, 150, 100, 7);
  fill(0xffffffff);
  textSize(20);
  text("BASIC STATS", 403, 105);
  textSize(15);
  text("Targets Missed: "+tm, 400, 130);
  text("Targets Hit: "+th, 400, 150);
  text("Accuracy: %"+round(accuracy(th, tm+th), 2), 400, 170);
}

//OPTIONS PANEL
public void options() {
  fill(71);
  rect(30, 40, 330, 310, 7);
  fill(0xfffff3af);
  textSize(30);
  text("OPTIONS", 135, 72);
  colourPicker();
  minimunSize();
  maximumSize();
  targetTime();
}

public void targetTime() {
  fill(91);
  rect(270, 80, 80, 260, 7);
  fill(0xffffffff);
  text("Target", 285, 97);
  text("Duration", 277, 112);
  text("0   sec", 297, 135);
  text("1   sec", 297, 155);
  text("2   sec", 297, 175);
  text("3   sec", 297, 195);
  text("4   sec", 297, 215);
  text("5   sec", 297, 235);
  text("6   sec", 297, 255);
  text("7   sec", 297, 275);
  text("8   sec", 297, 295);
  text("9   sec", 297, 315);
  text("10 sec", 297, 335);
  timer.duration = (int)(10000 * round(vs1.getPos(),2));

}

public void colourPicker() {
  fill(91);
  rect(40, 165, 225, 175, 7);
  fill(0xffffffff);
  text("Colour Picker", 55, 195);
}

//GAME SETTINGS 
public void minimunSize() {
  fill(0xffffffff);
  rect(40, 80, 225, 30, 7);
  fill(0); 
  textSize(15);
  text ("Minimum Target Size: "+mintargetsize, 50, 100); 
  fill(0xff940a00);
  triangle(247, 94, 252, 84, 257, 94);
  triangle(247, 96, 252, 106, 257, 96);
}

public void maximumSize() {
  fill(0xffffffff);
  rect(40, 120, 225, 30, 7);
  fill(0); 
  textSize(15);
  text ("Maximum Target Size: "+maxtargetsize, 50, 140); 
  fill(0xff940a00);
  triangle(250, 134, 255, 124, 260, 134);
  triangle(250, 136, 255, 146, 260, 136);
}


public void menukeyPressed(){}

//START GAME INPUT MECHANICS
public void menumousePressed(){
  if(overRect(30, 400, 740, 55)) {
    screenState = GAMESCREEN;
    counter = 0;
    hasRun = hasRun + 1;
  } else if (overRect(30, 50, 260, 200)) {
    if(overTri(247, 96, 252, 106, 257, 96, mouseX, mouseY)) {
      overminDown();
    } else if(overTri(247, 94, 252, 84, 257, 94, mouseX, mouseY)) {
      overminUp();
    } else if(overTri(250, 134, 255, 124, 260, 134, mouseX, mouseY)) {
      overmaxUp();
    } else if(overTri(250, 136, 255, 146, 260, 136, mouseX, mouseY)) {
      overmaxDown();
    }
  }
}

public void overminUp() { 
  if (mintargetsize == maxtargetsize) {
    overmaxUp();
  }
  if(mintargetsize <= 290) {
    mintargetsize = mintargetsize+10;
  } else if (mintargetsize == 300) {
  } else {
    mintargetsize = 300;
  }
}

public void overminDown() {
 if(mintargetsize >=20) {
   mintargetsize = mintargetsize-10;
 } else  if (mintargetsize == 10){
 } else {
   mintargetsize = 10;
 }
}

public void overmaxUp() { 
  if(maxtargetsize <= 290) {
    maxtargetsize = maxtargetsize+10;
  } else if (maxtargetsize == 300) {
  } else {
    maxtargetsize = 300;
  }
}

public void overmaxDown() { 
  if (maxtargetsize == mintargetsize) { 
    overminDown();
  }
  if(maxtargetsize >= 20) {
    maxtargetsize = maxtargetsize-10;
  } else if (maxtargetsize == 10) {
  } else {
    maxtargetsize = 10;
  }
  
}

public float area(int x1, int y1, int x2, int y2, int x3, int y3) {
  float area = (x1*(y2-y3) + x2*(y3-y1)+ x3*(y1-y2));
  if(area < 0) {area = -area;}
  return ((area)/2.0f); 
}

public boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

public boolean overTri(int x1, int y1, int x2, int y2, int x3, int y3, int x, int y) {
  double A = area (x1, y1, x2, y2, x3, y3);   
  double A1 = area (x, y, x2, y2, x3, y3);  
  double A2 = area (x1, y1, x, y, x3, y3);    
  double A3 = area (x1, y1, x2, y2, x, y); 
  return (A == (A1 + A2 + A3)); 
} 

public static double round(double value, int places) {
    double scale = Math.pow(10, places);
    return Math.round(value * scale) / scale;
}

public double accuracy(double hit, double total) {
  return hit * 100 / total;
}
int pb = 0;
int th = 0;
int tm = 0;
int targets = 20;
int counter = 0;
int hasRun = 0;
int[] xdif = new int[20];
int[] ydif = new int[20];
int[] mhcol = new int[20];
int xdiftol;
int ydiftol;

public void calcDiff(int mx, int my, int tx, int ty) {
  xdif[counter] = mx - tx;
  ydif[counter] = my - ty;
}

public void drawTarget(int sx, int sy, int ss) {
  if (ss % 2 == 0) {
    println("width and height must not be even");
    exit();
  }
  fill(0xffffffff);
  rect(sx, sy, ss, ss);
  fill(0xff000000);
  circle((sx+(ss/2)), (sy+(ss/2)), ss/2);
  fill(0xffffffff);
  circle((sx+(ss/2)), (sy+(ss/2)), ss/2-(ss/50));
  if (hasRun > 0) {
    int count = 0;
    while (count < 20) {
      if (xdif[count] != 5000 && ydif[count] != 5000 ) {
        if (mhcol[count] != 0) {
          fill(0xffff0000);
        } else {
          fill(0xff00ff37);
        }
        if (mhcol[count] == 0) {
          if (xdif[count] > 5+(ss/2-(ss/50))/2) {
            xdif[count] = 17;
          }if (xdif[count] < -5-(ss/2-(ss/50))/2) {
            xdif[count] = -17;
          } if (ydif[count] > 5+(ss/2-(ss/50))/2 ) {
            ydif[count] = 17;
          } if (ydif[count] < -5-(ss/2-(ss/50))/2 ) {
            ydif[count] = -17;
          }
        } else if (mhcol[count] !=0) {
          if (xdif[count] < (ss/2-(ss/50))/2 && xdif[count] > -1) {
            xdif[count] = 22;
          }if (xdif[count] > -(ss/2-(ss/50))/2 && xdif[count] < 1) {
            xdif[count] = -22;
          } if (ydif[count] < (ss/2-(ss/50))/2 && ydif[count] > -1) {
            ydif[count] = 22;
          } if (ydif[count] < -(ss/2-(ss/50))/2 && ydif[count] < 1) {
            ydif[count] = -22;
          } if (xdif[count] > 50) {
            xdif[count] = 50;
          } if (xdif[count] < -50) {
            xdif[count] = -50;
          } if (ydif[count] > 50) {
            ydif[count] = 50;
          } if (ydif[count] < -50) {
            ydif[count] = -50;
          }
        }
        circle((sx+(ss/2))+xdif[count], (sy+(ss/2))+ydif[count], 10);
      }
      count = count + 1;
    }
  }
}
class VScrollbar
{
  int swidth, sheight;    
  int xpos, ypos;         
  float spos, newspos;    
  int sposMin, sposMax;   
  int loose;              
  boolean over;          
  boolean locked;
  float ratio;

  VScrollbar (int xp, int yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int heighttowidth = sh - sw;
    ratio = (float)sh / (float)heighttowidth;
    xpos = xp-swidth/2;
    ypos = yp;
    spos = ypos + sheight/2 - swidth/2;
    newspos = spos;
    sposMin = ypos;
    sposMax = ypos + sheight - swidth;
    loose = l;
  }

  public void update() {
    if(over()) {
      over = true;
    } else {
      over = false;
    }
    if(mousePressed && over) {
      locked = true;
    }
    if(!mousePressed) {
      locked = false;
    }
    if(locked) {
      newspos = constrain(mouseY-swidth/2, sposMin, sposMax);
    }
    if(abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  public int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  public boolean over() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
    mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  public void display() {
    fill(255);
    rect(xpos, ypos, swidth, sheight);
    if(over || locked) {
      fill(255, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    rect(xpos, spos, swidth, swidth);
  }

  public double getPos() {
    return (spos-ypos) / (sheight-swidth);
  }
}
  public void settings() {  size(800, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "aim_trainer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
