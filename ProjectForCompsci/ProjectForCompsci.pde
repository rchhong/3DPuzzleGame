import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.core.PApplet;
import processing.core.PVector;
import shapes3d.Box;
import shapes3d.Shape3D;

import java.util.Arrays;

final int STARTMENU = 0;
final int GAME = 1;
final int PAUSE = 2;

PeasyCam cam;
//Initial Position
int aX = 100;
int aY = 100;
int aZ = -75;
//Change in position per box
int dX = 75;
int dY = 75;
int dZ = 75;
int size = 3;
myBox[][][] puzzle = new myBox[size][size][size];

int[][] indexes = {{ -1, -1, -1} , {-1,-1,-1}};
int[] colors = {color(255, 115, 230, 255), color(0, 115, 230, 255), color(102, 255, 102, 255)};
int[] colorsTrans = {color(255, 115, 230, 122), color(0, 115, 230, 122), color(102, 255, 102, 122)};
color adjColor = color(255,0,0);
int[] index = {-1,-1,-1};
int avalible;

Shape3D picked;
boolean adjReq = false;

public void setup() {
  size(1920, 1080, P3D);
  //Camera stuff
  noCursor();
  cam = new PeasyCam(this, aX + dX * (size/2), aY + dY * (size/2), aZ + dZ * (size/1.5), 100);
  cam.setSuppressRollRotationMode();
  //Make boxes in a cube pattern given as given size
  int index = 0;
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      for (int k = 0; k < size; k++) {
        int colorID = (int) (Math.random() * colors.length);
        puzzle[i][j][k] = new myBox(new Box(this, 50, 50, 50), aX, aY, aZ, colors[colorID], colorID, index, Shape3D.SOLID | Shape3D.WIRE);
        index++;
        aX+=dX;
      }
      aY+=dY;
      aX = 100;
    }
    aZ-=dZ;
    aY = 100;
  }
  
}

public void draw() {
  playGame();
}

public void settings() {
  fullScreen(P3D);
}

public void playGame() {
  background(0);
  //Picker
  picked = Shape3D.pickShape(this, width / 2, height / 2);
  //Draw boxes
  pushMatrix();
  render();
  popMatrix();
  if (indexes[0][0] >= 0 && indexes[1][0] >= 0) {
    swap();
    checkVertical();
    checkHorizontal();
  }
  
  GUI();
}

public void GUI() {
  cam.beginHUD();
  rect(width/2-10,height/2-10,20,20);
  cam.endHUD();
}


public void mouseClicked() {
  if (indexes[0][0] == -1)
    avalible = 0;
  else if (indexes[1][0] == -1)
    avalible = 1;
    
  for (int i = 0; i < puzzle.length; i++) {
    for(int j = 0; j < puzzle[i].length; j++) {
      for(int k = 0; k < puzzle[i][j].length; k++) {
        if (picked == puzzle[i][j][k].getBox()) {
          if (mouseButton == LEFT) {
            System.out.println(i + " " + j + " " + k);
            index[0] = i;
            index[1] = j;
            index[2] = k;
          } 
        }
      }
    }
  }
  
  if(mouseButton == RIGHT && index[0] >= 0) {
      indexes[0] = indexes[1];
      puzzle[index[0]][index[1]][index[2]].setColor(colors[puzzle[index[0]][index[1]][index[2]].getColorID()]);
      for(int i = 0; i < index.length; i++) {
        index[i] = -1;
      }
      hideAdj();
      adjReq = false;
   }
   
   if (index[0] >= 0) {
     if(adjReq) {
       if(isAdjacent(puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]], puzzle[index[0]][index[1]][index[2]])) {
          for(int i = 0; i < indexes[avalible].length; i++) {
              indexes[avalible][i] = index[i];
           }
          puzzle[index[0]][index[1]][index[2]].setColor(colorsTrans[puzzle[index[0]][index[1]][index[2]].getColorID()]);
       }
     } else {
       for(int i = 0; i < indexes[avalible].length; i++) {
           indexes[avalible][i] = index[i];
       }
       puzzle[index[0]][index[1]][index[2]].setColor(colorsTrans[puzzle[index[0]][index[1]][index[2]].getColorID()]);
     }
   }
    
   if(indexes[0][0] != -1 && indexes[1][0] == -1) {
     adjReq = true;
     showAdj(puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]]);
   }
    
    
}

public void render() {
  for (int i = 0; i < puzzle.length; i++) {
    for(int j = 0; j < puzzle[i].length; j++) {
      for(int k = 0; k < puzzle[i][j].length; k++) {
         puzzle[i][j][k].getBox().moveTo(puzzle[i][j][k].getX(), puzzle[i][j][k].getY(), puzzle[i][j][k].getZ());
         puzzle[i][j][k].getBox().fill(puzzle[i][j][k].getColor());
         puzzle[i][j][k].getBox().drawMode(puzzle[i][j][k].getDrawMode());
         puzzle[i][j][k].getBox().draw();
      }
    }
  }
}

public void swap() {
    hideAdj();
    adjReq = false;
    puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]].setColor(colors[puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]].getColorID()]);
    puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]].setColor(colors[puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]].getColorID()]);
    int[] foo = puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]].getCoords();
    puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]].setCoords(puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]].getX(), puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]].getY(), puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]].getZ());
    puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]].setCoords(foo[0], foo[1], foo[2]);
    int temp = puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]].getID();
    puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]].setID(puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]].getID());
    puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]].setID(temp);
    for (int i = 0; i < indexes.length; i++) {
      for (int j = 0; j < indexes[i].length; j++) {
        indexes[i][j] = -1;
      }
    }
    for(int i = 0; i < index.length; i++) {
        index[i] = -1;
    }
}

public boolean isAdjacent(myBox a, myBox b) {
  int diffX = (int) Math.abs(a.getX() - b.getX());
  int diffY = (int) Math.abs(a.getY() - b.getY());
  int diffZ = (int) Math.abs(a.getZ() - b.getZ());
  if(diffX == dX && diffY == 0 && diffZ == 0) {return true;}
  if(diffX == 0 && diffY == dY && diffZ == 0) {return true;}
  if(diffX == 0 && diffY == 0 && diffZ == dZ) {return true;}
  return false;
}

public void showAdj(myBox pick) {
  System.out.println("Block picked: " + pick.getID());
  System.out.println("X: " + pick.getX() + " Y: " + pick.getY() + " Z: " + pick.getZ());
  //System.out.println ("Blocks adj");
  for(int i = 0; i < puzzle.length; i++) {
    for(int j = 0; j < puzzle[i].length; j++) {
      for(int k = 0; k < puzzle[i][j].length; k++) {
        if(isAdjacent(pick, puzzle[i][j][k])) {
        //System.out.println(puzzle[i].getID());
        puzzle[i][j][k].setColor(adjColor);
        }
      }
    }
  }
}

public void hideAdj() {
  for(int i = 0; i < puzzle.length; i++) {
    for(int j = 0; j < puzzle[i].length; j++) {
      for(int k = 0; k < puzzle[i][j].length; k++) {
         puzzle[i][j][k].setColor(colors[puzzle[i][j][k].getColorID()]);
      }
    }
  }
}

public void checkVertical() {
}
public void checkHorizontal() {
}
class myBox {
  private Box b;
  private int x, y, z, drawMode, colorID, blockID;
  private color c;

  public myBox(Box b, int x, int y, int z, color c, int colorID, int blockID, int drawMode) {
    this.b = b;
    this.x = x;
    this.y = y;
    this.z = z;
    this.c = c;
    this.colorID = colorID;
    this.blockID = blockID;
    this.drawMode = drawMode;
  }
  public Box getBox() {
    return b;
  }
  public int getX() {
    return x;
  }
  public int getY() {
    return y;
  }
  public int getZ() {
    return z;
  }
  public color getColor() {
    return c;
  }
  public int getColorID() {
    return colorID;
  }
  public int getID() {
    return blockID;
  }
  public void setID(int blockID) {
    this.blockID = blockID;
  }
  public int[] getCoords() {
    int[] coords = {x, y, z};
    return coords;
  }
  public int getDrawMode() {
    return drawMode;
  }
  public void setCoords(int x, int y, int z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  public void setColor(color c) {
    this.c = c;
  }
  
  public void setDrawMode(int drawMode) {
    this.drawMode = drawMode;
  }
}