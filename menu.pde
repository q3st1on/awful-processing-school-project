//SETUP
int mintargetsize=30; 
int maxtargetsize=30; 
VScrollbar vs1;
void menuSetup() {
    cp = new ColorPicker( 50, 205, 205, 100, 255 );
    vs1 = new VScrollbar(285, 120, 20, 215, 3);
}

//DRAW MENU
void drawMenu() {
  background(51); //<>//
  options(); //<>//
  stats(); //<>//
  startGame(); //<>//
  cp.render(); //<>//
  vs1.update(); //<>//
  vs1.display(); //<>//
}

void startGame() {
  fill(0, 102, 153);
  rect(30, 400, 740, 55, 7);
  fill(#FFFFFF);
  textSize(30);
  text("START AIM TRAINER", 250, 437.5);
}

void stats() {
  fill(71); //<>//
  rect(380, 40, 390, 310, 7); //<>//
  fill(#fff3af);  textSize(30); //<>//
  text("PERFORMANCE", 470, 72); //<>//
  fill(#ffffff);textSize(15); //<>//
  basicStats(); //<>//
  drawTarget(470, 200, 101); //<>//
}

void basicStats() {
  fill(91);
  rect(390, 80, 150, 100, 7);
  fill(#ffffff);
  textSize(20);
  text("BASIC STATS", 403, 105);
  textSize(15);
  text("Targets Missed: "+tm, 400, 130);
  text("Targets Hit: "+th, 400, 150);
  text("Accuracy: %"+round(accuracy(th, tm+th), 2), 400, 170);
}

//OPTIONS PANEL
void options() {
  fill(71); //<>//
  rect(30, 40, 330, 310, 7); //<>//
  fill(#fff3af); //<>//
  textSize(30); //<>//
  text("OPTIONS", 135, 72); //<>//
  colourPicker(); //<>//
  minimunSize(); //<>//
  maximumSize(); //<>//
  targetTime(); //<>//
}

void targetTime() {
  fill(91);
  rect(270, 80, 80, 260, 7);
  fill(#ffffff);
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

void colourPicker() {
  fill(91);
  rect(40, 165, 225, 175, 7);
  fill(#ffffff);
  text("Colour Picker", 55, 195);
}

//GAME SETTINGS 
void minimunSize() {
  fill(#ffffff);
  rect(40, 80, 225, 30, 7);
  fill(0); 
  textSize(15);
  text ("Minimum Target Size: "+mintargetsize, 50, 100); 
  fill(#940a00);
  triangle(247, 94, 252, 84, 257, 94);
  triangle(247, 96, 252, 106, 257, 96);
}

void maximumSize() {
  fill(#ffffff);
  rect(40, 120, 225, 30, 7);
  fill(0); 
  textSize(15);
  text ("Maximum Target Size: "+maxtargetsize, 50, 140); 
  fill(#940a00);
  triangle(250, 134, 255, 124, 260, 134);
  triangle(250, 136, 255, 146, 260, 136);
}


void menukeyPressed(){}

//START GAME INPUT MECHANICS
void menumousePressed(){
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

void overminUp() { 
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

void overminDown() {
 if(mintargetsize >=20) {
   mintargetsize = mintargetsize-10;
 } else  if (mintargetsize == 10){
 } else {
   mintargetsize = 10;
 }
}

void overmaxUp() { 
  if(maxtargetsize <= 290) {
    maxtargetsize = maxtargetsize+10;
  } else if (maxtargetsize == 300) {
  } else {
    maxtargetsize = 300;
  }
}

void overmaxDown() { 
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

float area(int x1, int y1, int x2, int y2, int x3, int y3) {
  float area = (x1*(y2-y3) + x2*(y3-y1)+ x3*(y1-y2));
  if(area < 0) {area = -area;}
  return ((area)/2.0); 
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overTri(int x1, int y1, int x2, int y2, int x3, int y3, int x, int y) {
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
