int pb = 0;
int th = 0;
int tm = 0;
int targets = 20;
int counter = 0;
int hasRun = 0;
boolean corrected = false;
float[] xdif = new float[20];
float[] ydif = new float[20];
float[] size = new float[20];
float[] dxdif = new float[20];
float[] dydif = new float[20];
float[] mhcol = new float[20];
int xdiftol;
int ydiftol;
int sizem;
int sizeh;
int countol;

void calcDiff(int mx, int my, float tx, float ty, float ss) {
  xdif[counter] = mx - tx;
  ydif[counter] = my - ty;
  size[counter] = ss;
}

void drawTarget(int sx, int sy, int ss) {
  if (ss % 2 == 0) {
    println("width and height must not be even");
    exit();
  }
  fill(#ffffff);
  rect(sx, sy, (float)ss, (float)ss);
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
        dxdif[count] = dxdif[count] * (((ss/2-(ss/50))/2)/size[count]);
        dydif[count] = dydif[count] * (((ss/2-(ss/50))/2)/size[count]);
          while (dxdif[count] > (ss/2)) {
            dxdif[count] -= 2;
          } while (dxdif[count] < -(ss/2)) {
            dxdif[count] += 2;
          } while (dydif[count] > (ss/2)) {
            dydif[count] -= 2;
          } while (dydif[count] < -(ss/2)) {
            dydif[count] += 2;
          } 
} //<>//

public float arrayMax(float[] numbers) {
    float highest = numbers[0];
    for (int i = 1; i < numbers.length; i ++) {
        if (numbers[i] > highest) {
            highest = numbers[i];
        }
    }
    return highest;
}

public float arrayMin(float[] numbers) {
    float lowest = numbers[0];
    for (int i = 1; i < numbers.length; i ++) {
        if (numbers[i] < lowest) {
            lowest = numbers[i];
        }
    }
    return lowest;
}
