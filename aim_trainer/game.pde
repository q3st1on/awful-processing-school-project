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
      xdif[counter] = 5000; ydif[counter] = 5000;
      counter = counter+1;
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
    size[counter] = (int)s;
    counter = counter+1;
  } else {
    calcDiff(mouseX, mouseY, (int)x, (int)y);
    size[counter] = (int)s;
    mhcol[counter] = 1;
    counter = counter+1;
    tm = tm +1;
  }
}
//END GAME AND GO BACK TO MENU
void gamekeyPressed() {
  if ( screenState == GAMESCREEN && key == 'r' || key == 'R') {
    gotoMenu(); //<>//
  }
}

void gotoMenu() { //<>//
    screenState = MENUSCREEN;
    
    for (int i = 0; i < xdif.length; i++) {
      dxdif[i] = xdif[i];
      dydif[i] = ydif[i];
      if (size[i] == 0) {
      } else {
        sizeh += xdif[i];
        sizem += ydif[i];
        countol++;
      }
      if (xdif[i] == 5000 || ydif[i] == 5000) {
      } else {
        xdiftol += xdif[i];
        ydiftol += ydif[i];
        countol++;
      }
    }
    try {
      xdiftol /= countol;
      ydiftol /= countol;
    } 
    catch (Exception e) {
      xdiftol = 0;
      ydiftol = 0;
    }

    if (tm == 0) {
    } else {
      tm = tm - 1;
    }
    corrected = false;
}

Boolean overCircle(float xx, float yy, float ss) {
  float disX = xx - mouseX;
  float disY = yy - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < ss/2 ) {
    return true;
  } else {
    return false;
  }
}
