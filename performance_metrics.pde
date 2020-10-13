int pb = 0;
int th = 0;
int tm = 0;
int targets = 20;
int counter = 0;
int hasRun = 0;
int[] xdif = new int[20];
int[] ydif = new int[20];
int[] mhcol = new int[20];

void calcDiff(int mx, int my, int tx, int ty) {
  xdif[counter] = mx - tx;
  ydif[counter] = my - ty;
}

void drawTarget(int sx, int sy, int ss) {
  if (ss % 2 == 0) {
    println("width and height must not be even");
    exit();
  }
  fill(#ffffff);
  rect(sx, sy, ss, ss);
  fill(#000000);
  circle((sx+(ss/2)), (sy+(ss/2)), ss/2);
  fill(#ffffff);
  circle((sx+(ss/2)), (sy+(ss/2)), ss/2-(ss/50));
  if (hasRun > 0) {
    int count = 0;
    while (count < 20) {
      if (xdif[count] != 5000 && ydif[count] != 5000 ) {
        if (mhcol[count] != 0) {
          fill(#ff0000);
        } else {
          fill(#00ff37);
        }
        if (mhcol[count] == 0) {
          if (xdif[count] > 5+(ss/2-(ss/50))/2) {
            xdif[count] = 20;
          }if (xdif[count] < -5-(ss/2-(ss/50))/2) {
            xdif[count] = -20;
          } if (ydif[count] > 5+(ss/2-(ss/50))/2 ) {
            ydif[count] = 20;
          } if (ydif[count] < -5-(ss/2-(ss/50))/2 ) {
            ydif[count] = -20;
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
          }
        }
        circle((sx+(ss/2))+xdif[count], (sy+(ss/2))+ydif[count], 10);
      }
      count = count + 1;
    }
  }
}
