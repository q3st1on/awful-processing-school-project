//SETUP
float x,y,s;

//DRAW GAME TO SCREEN
void drawGame() {
  if (counter < targets) {
    background(0);
    fill(col);
    circle(x, y, s);
    gameExit();
    if( timer.alarm() ){
      newTarget(0);
    }
  } else {
    gotoMenu();
  }
}

void gameExit() {
  fill(#b50c00);
  circle(780, 20, 30);
  fill(#ffffff);
  text("X", 771, 31);
}

//GAME INPUT MECHANICS
void newTarget(int f) {
  s = random(int(mintargetsize),int(maxtargetsize));
  x = random(0, width - s);
  y = random(0, height - s);  
  counter = counter+1;
  if (f == 1) {
    th = th + 1;
  } else if (f == 0) {
    tm = tm + 1;
  }
  f = 2;
}

void gamemousePressed() {
  if( overCircle(780, 20, 30)) {
    gotoMenu();
  } else if( overCircle(x, y, s) ){
    newTarget(1);
    calcDiff(mouseX, mouseY, (int)x, (int)y);
  } else {
    tm = tm +1;
  }
}
//END GAME AND GO BACK TO MENU
void gamekeyPressed() {
  if ( screenState == GAMESCREEN && key == 'r' || key == 'R') {
    gotoMenu(); //<>//
  }
}

void gotoMenu() {
    screenState = MENUSCREEN;
    if (tm == 0) {
    } else {
      tm = tm - 1;
    }
}
