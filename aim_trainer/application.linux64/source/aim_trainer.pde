//SETUP
final int MENUSCREEN = 1;
final int GAMESCREEN = 0;
int screenState = MENUSCREEN;
void setup() {
  size(800, 500);
  newTarget(2); // Make initial target41
  menuSetup();
}

//MAIN DRAW THREAD
void draw() {
  if (screenState == MENUSCREEN) {
    drawMenu();
  } else if (screenState == GAMESCREEN) {
    drawGame();
  } else {
    println("Something went wrong!");
  }
}

//main keypressed input
void keyPressed() {
  if (screenState == MENUSCREEN) {
    menukeyPressed();
  } else if (screenState == GAMESCREEN) {
    gamekeyPressed();
  } else {
    println("Something went wrong!");
  }
}

void mousePressed(){
  if (screenState == MENUSCREEN) {
    menumousePressed();
  } else if (screenState == GAMESCREEN) {
    gamemousePressed();
  } else {
    println("Something went wrong!");
  }
}
