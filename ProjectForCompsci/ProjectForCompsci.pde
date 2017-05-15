import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.core.PApplet;
import processing.core.PVector;
import shapes3d.Box;
import shapes3d.Shape3D;

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
int size = 4;
myBox[][][] puzzle = new myBox[size][size][size];
//Menu boxes
myBox[] startMenu = new myBox[3];

int[][] indexes = {{ -1, -1, -1} , {-1,-1,-1}};
int[] colors = {color(255, 115, 230, 255), color(0, 115, 230, 255), color(102, 255, 102, 255)};
int[] colorsTrans = {color(255, 115, 230, 122), color(0, 115, 230, 122), color(102, 255, 102, 122)};
color adjColor = color(255,0,0);
int[] index = {-1,-1,-1};
int available;
int appState = 0; //determines whether we are in game menu, start menu, pause
boolean gameInitNotOccured = true; //returns true if game has not been initialized (game screen), set to false when game state runs

Shape3D picked;
boolean adjReq = false;

PImage goIntoGame; //menu texture for the start game button

public void setup() {
  size(1980, 1080, P3D);
  //initialize texture for menu box
  goIntoGame = loadImage("startgame.png"); //Change start game texture soon plz
  //Camera stuff
  noCursor();
  cam = new PeasyCam(this, aX + dX * (size/2), aY + dY * (size/2), aZ + dZ * (size + size/2), 100);
  cam.setSuppressRollRotationMode();
  
  menuInit();
  
}

public void draw() {
  if (appState == STARTMENU) {
    menuScreen();
  }
  if (appState == GAME) {
    if (gameInitNotOccured == true) {
      gameInit();
      gameInitNotOccured = false;
    }
    playGame();
  }
}

public void settings() {
  fullScreen(P3D);
}

public void menuScreen() {
  background(0);
  //Picker
  picked = Shape3D.pickShape(this, width / 2, height / 2);
  //Draw boxes
  pushMatrix();
  renderMenu();
  popMatrix();
  
  GUI();
}

public void gameInit() {
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

public void menuInit() {
  //initialize start menu, first object is the single box
  startMenu[0] = new myBox(new Box(this, 150, 150, 150), aX, aY, aZ, colors[0], 0, 0, Shape3D.SOLID | Shape3D.WIRE);
  //overlay boxes, actual usable menus
  startMenu[1] = new myBox(new Box(this, 150, 150, 1), aX, aY, aZ+75, colors[1], 1, 1, Shape3D.TEXTURE); //front menu button
  startMenu[2] = new myBox(new Box(this, 1, 150, 150), aX-75, aY, aZ, colors[1], 1, 1, Shape3D.TEXTURE);  //left side menu button
  startMenu[1].getBox().setTexture(goIntoGame);
  startMenu[2].getBox().setTexture(goIntoGame); //eventually change to different button
}

public void playGame() {
  background(0);
  //Picker
  picked = Shape3D.pickShape(this, width / 2, height / 2);
  //Draw boxes
  pushMatrix();
  renderPuzzle();
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
  if (appState == GAME) {
    if (indexes[0][0] == -1)
      available = 0;
    else if (indexes[1][0] == -1)
      available = 1;
    
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
      for(int i = 0; i < indexes[0].length; i++) {
        indexes[0][i] = indexes[1][i];
      }
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
          for(int i = 0; i < indexes[available].length; i++) {
              indexes[available][i] = index[i];
          }
          puzzle[index[0]][index[1]][index[2]].setColor(colorsTrans[puzzle[index[0]][index[1]][index[2]].getColorID()]);
        }
      } else {
        for(int i = 0; i < indexes[available].length; i++) {
           indexes[available][i] = index[i];
        }
        puzzle[index[0]][index[1]][index[2]].setColor(colorsTrans[puzzle[index[0]][index[1]][index[2]].getColorID()]);
      }
    }
    
   if(indexes[0][0] != -1 && indexes[1][0] == -1) {
     adjReq = true;
     showAdj(puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]]);
   }
  }
  if (appState == STARTMENU) {
    if (picked == startMenu[1].getBox() && mouseButton == LEFT) {
      appState = GAME;
      picked = null;
    }
  }
}

public void renderPuzzle() {
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

public void renderMenu() {
  for (int i = 0; i < startMenu.length; i++) {
    startMenu[i].getBox().moveTo(startMenu[i].getX(), startMenu[i].getY(), startMenu[i].getZ());
    startMenu[i].getBox().fill(startMenu[i].getColor());
    startMenu[i].getBox().drawMode(startMenu[i].getDrawMode());
    startMenu[i].getBox().draw();
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
    
    myBox dab = puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]];
    puzzle[indexes[0][0]][indexes[0][1]][indexes[0][2]] = puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]];
    puzzle[indexes[1][0]][indexes[1][1]][indexes[1][2]] = dab;
    
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
  System.out.println("Color ID: " + pick.getColorID());
  for(int i = 0; i < puzzle.length; i++) {
    for(int j = 0; j < puzzle[i].length; j++) {
      for(int k = 0; k < puzzle[i][j].length; k++) {
        if(isAdjacent(pick, puzzle[i][j][k])) {
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
    for(int i = 0; i < puzzle[0].length; i++) {
      int count = 1;
      int start = 0;
      for(int j = 0; j < puzzle[0][j].length-1; j++) {
        if(puzzle[0][j][i].getColorID() == puzzle[0][j+1][i].getColorID()) {
          count++;
        }
        else {
          if(count >= 3) {
            shiftVertical(i, start, start+count);
          }
          count = 1;
          start = j;
        }
      }
      if(count >= 3) {
         shiftVertical(i, start, start+count);
       }
    }
}

public void checkHorizontal() {  
    for(int i = 0; i < puzzle[0].length; i++) {
      int count = 1;
      int start = 0;
      for(int j = 0; j < puzzle[0][i].length-1; j++) {
        if(puzzle[0][i][j].getColorID() == puzzle[0][i][j+1].getColorID()) {
          count++;
        }
        else {
          if(count >= 3) {
            shiftHorizontal(i, start, start+count);
          }
          count = 1;
          start = j+1;
        }
      }
      if(count >= 3) {
         shiftHorizontal(i, start, start+count);
       }
    }
}

public void shiftHorizontal(int row, int start, int end) {
  for(int i = 1; i < puzzle.length; i++) {
    for(int j = start; j < end; j++) {
      //push all blocks foward by dy, 1st layer sent to back, change info
      puzzle[i][row][j].setCoords(puzzle[i][row][j].getX(), puzzle[i][row][j].getY(), puzzle[i][row][j].getZ() + dZ);
    }
  }
  for(int i = start; i < end; i++) {
    puzzle[0][row][i].setCoords(puzzle[0][row][i].getX(),puzzle[0][row][i].getY(),puzzle[0][row][i].getZ() - dZ * (size - 1));
  }
  for(int i = 1; i < puzzle.length; i++) {
    for(int j = start; j < end; j++) {
      int foo = puzzle[i-1][row][j].getID();
      puzzle[i-1][row][j].setID(puzzle[i][row][j].getID());
      puzzle[i][row][j].setID(foo);
      
      myBox temp = puzzle[i-1][row][j];
      puzzle[i-1][row][j] = puzzle[i][row][j];
      puzzle[i][row][j] = temp;
    }
  }
 for(int i = start; i < end; i++) {
   int newColorID = (int) (Math.random()  * colors.length);
    puzzle[size-1][row][i].setColorID(newColorID);
    puzzle[size-1][row][i].setColor(colors[puzzle[size-1][row][i].getColorID()]);
  }
  redraw();
}

public void shiftVertical(int col, int start, int end) {
  for(int i = 1; i < puzzle.length; i++) {
    for(int j = start; j < end; j++) {
       puzzle[i][j][col].setCoords(puzzle[i][j][col].getX(), puzzle[i][j][col].getY(), puzzle[i][j][col].getZ() + dZ);
    }
  }
 for(int i = start; i < end; i++) {
    puzzle[0][i][col].setCoords(puzzle[0][i][col].getX(),puzzle[0][i][col].getY(),puzzle[0][i][col].getZ() - dZ * (size - 1));
  }
  for(int i = 1; i < puzzle.length; i++) {
    for(int j = start; j < end; j++) {
      int foo = puzzle[i-1][j][col].getID();
      puzzle[i-1][j][col].setID(puzzle[i][j][col].getID());
      puzzle[i][j][col].setID(foo);
      
      myBox temp = puzzle[i-1][j][col];
      puzzle[i-1][j][col] = puzzle[i][j][col];
      puzzle[i][j][col] = temp;
    }
  }
  for(int i = start; i < end; i++) {
   int newColorID = (int) (Math.random()  * colors.length);
    puzzle[size-1][i][col].setColorID(newColorID);
    puzzle[size-1][i][col].setColor(colors[puzzle[size-1][i][col].getColorID()]);
  }
  redraw();
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
  public void setColorID(int colorID) {
    this.colorID = colorID;
  }
}
