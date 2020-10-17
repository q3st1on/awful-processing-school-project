int pb = 0;
int th = 0;
int tm = 0;
int targets = 20;
int counter = 0;
int hasRun = 0;
boolean corrected = false;
int[] xdif = new int[20];
int[] ydif = new int[20];
int[] size = new int[20];
int[] dxdif = new int[20];
int[] dydif = new int[20];
int[] mhcol = new int[20];
int xdiftol;
int ydiftol;
int sizem;
int sizeh;
int countol;

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
  rect(sx, sy, (float)ss, (float)ss);
  fill(#000000);
  circle((float)(sx+(ss/2)), (float)(sy+(ss/2)), (float)ss/2);
  fill(#ffffff);
  circle((float)(sx+(ss/2)), (float)(sy+(ss/2)), (ss/2-(ss/50)));
  if (hasRun > 0) {
    int count = 0;
    while (count < 20) {
      if (dxdif[count] != 5000 && dydif[count] != 5000) {
        if (corrected == false) {
          correctDvals(count, ss);
        }
        if (mhcol[count] != 0) {
          fill(#ff0000);
        } else {
          fill(#00ff37);
        }
          circle((float)((sx+(ss/2))+dxdif[count]), (float)((sy+(ss/2))+dydif[count]), (float)10);
      }
      count = count + 1;
    }
    corrected = true;
  }
}

void correctDvals(int count, int ss) { //<>//
        if (mhcol[count] == 0) {
          if (dxdif[count] > 5+(ss/2-(ss/50))/2) {
            dxdif[count] = 17;
          }if (dxdif[count] < -5-(ss/2-(ss/50))/2) {
            dxdif[count] = -17;
          } if (dydif[count] > 5+(ss/2-(ss/50))/2 ) {
            dydif[count] = 17;
          } if (dydif[count] < -5-(ss/2-(ss/50))/2 ) {
            dydif[count] = -17;
          }
        } else if (mhcol[count] !=0) {
          if (dxdif[count] < (ss/2-(ss/50))/2 && dxdif[count] > -1) {
            dxdif[count] = 22;
          } if (dxdif[count] > -(ss/2-(ss/50))/2 && dxdif[count] < 1) {
            dxdif[count] = -22;
          } if (dydif[count] < (ss/2-(ss/50))/2 && dydif[count] > -1) {
            dydif[count] = 22;
          } if (dydif[count] < -(ss/2-(ss/50))/2 && dydif[count] < 1) {
            dydif[count] = -22;
          } 
          if (dxdif[count] > ss/2) {dxdif[count]=ss/2;}
          if (dydif[count] > ss/2) {dydif[count]=ss/2;}
          if (dxdif[count] < -(ss/2)) {dxdif[count]=-(ss/2);}
          if (dydif[count] < -(ss/2)) {dydif[count]=-(ss/2);}
        }
} //<>// //<>//

public int arrayMax(int[] numbers) {
    int highest = numbers[0];
    for (int i = 1; i < numbers.length; i ++) {
        if (numbers[i] > highest) {
            highest = numbers[i];
        }
    }
    return highest;
}

public int arrayMin(int[] numbers) {
    int lowest = numbers[0];
    for (int i = 1; i < numbers.length; i ++) {
        if (numbers[i] < lowest) {
            lowest = numbers[i];
        }
    }
    return lowest;
}
