import processing.core.PApplet;
import processing.core.PVector;
import queasycam.QueasyCam;
import shapes3d.Box;
import shapes3d.Shape3D;


  QueasyCam cam;
  int aX = 100;
  int aY = 100;
  int aZ = -75;
  int dX = 75;
  int dY = 75;
  int dZ = 75;
  int size = 5;
  myBox[] puzzle = new myBox[(int) Math.pow(size, 3)];
  int[][] pos = { { 100, 100, 0 }, { 100, 100, -75 }, { 100, 100, 75 }};
  int[][] assign = { { 0, color(255, 115, 230) }, { 1, color(0, 115, 230) }, { 2, color(102, 255, 102) } };
  int[][] selected = { { -1, -1, -1 }, { -1, -1, -1 } };
  int[] indexes = { 0, 0 };
  int[] colors = {color(255, 115, 230),color(0, 115, 230),color(102, 255, 102)};
  int index = -1;
  int availible;

  PVector vec;
  Shape3D picked;

  String gameState;

  public void setup() {
    size(1920, 1080, P3D);
    noCursor();
    cam = new QueasyCam(this);
    cam.speed = 5; // default is 3
    cam.sensitivity = 0.5f; // default is 2
    //Make boxes in a cube pattern given as given size
    int index = 0;
    for(int i = 0; i < size; i++) {
      for(int j = 0; j < size; j++) {
        for(int k = 0; k < size; k++) {
           puzzle[index] = new myBox(new Box(this,50,50,50), aX, aY, aZ, colors[i % colors.length]);
           index++;
           aZ+=dZ;
        }
        aY+=dY;
        aZ = -75;
      }
      aX+=dX;
      aY = 100;
    }
    
    for(int i = 0; i < puzzle.length; i++) {
      puzzle[i].getBox().moveTo(puzzle[i].getX(), puzzle[i].getY(), puzzle[i].getZ());
      puzzle[i].getBox().fill(colors[i % colors.length]);
      puzzle[i].getBox().drawMode(Shape3D.SOLID | Shape3D.WIRE);
    }
    
    gameState = "GAME";
  }

  public void draw() {
      playGame();
  }

  public void settings() {
    fullScreen(P3D);
  }
  
  public void playGame() {
    background(0);
    pushMatrix();
    //Camera stuff
    vec = cam.getForward();
    cursor(CROSS);
    //Picker
    picked = Shape3D.pickShape(this, width / 2, height / 2);
    
    for (int i = 0; i < puzzle.length; i++) {
      puzzle[i].getBox().moveTo(puzzle[i].getX(), puzzle[i].getY(), puzzle[i].getZ());
      puzzle[i].getBox().draw();
    }
    popMatrix();
    //I have no clue how this works
    if (selected[0][0] >= 0 && selected[1][0] >= 0) {
      int[] foo = { selected[0][0], selected[0][1], selected[0][2] };
      for (int x = 0; x < pos.length; x++) {
        pos[indexes[0]][x] = pos[indexes[1]][x];
      }
      for (int x = 0; x < pos.length; x++) {
        pos[indexes[1]][x] = foo[x];
      }
      indexes[0] = -1;
      indexes[1] = -1;
      for (int f = 0; f < selected.length; f++) {
        for (int z = 0; z < selected[f].length; z++) {
          selected[f][z] = -1;
        }
      }
    }
  }

  public void mouseClicked() {
    /*if(gameState.equals("STARTMENU")) {
      gameState = "GAME";
    }
    */
    //Gamestate
    if(gameState.equals("GAME")) {
      
      if (selected[0][0] <= 0)
        availible = 0;
      else if (selected[1][0] <= 0)
        availible = 1;
        
      for(int i = 0; i < puzzle.length; i++) {
        if(picked == puzzle[i].getBox()) {
          if(mouseButton == LEFT) {
            if(i >= 2) {
              puzzle[i].getBox().fill(colors[2]);
            }
          index = i;
        }
        else if(mouseButton == RIGHT) {
          if(i >= 1) {
            puzzle[i].getBox().fill(colors[1]);
          }
        }
      }
    }
    
    if (index >= 0) {
      for (int i = 0; i < pos.length; i++) {
        selected[availible][i] = pos[index][i];
      }
      indexes[availible] = index;
    }
    
   }
  }
  
  class myBox {
    private Box b;
    private int x,y,z;
    private color c;
    
    public myBox(Box b, int x, int y, int z, color c) {
      this.b = b;
      this.x = x;
      this.y = y;
      this.z = z;
      this.c = c;
    }
    public Box getBox() {return b;}
    public int getX() {return x;}
    public int getY() {return y;}
    public int getZ() {return z;}
    public color getColor() {return c;}
    public void setCoords(int x, int y, int z) {
      this.x = x;
      this.y = y;
      this.z = z;
    }
    public void setColor(color c) {this.c = c;}
  }
  /*
  public void startMenu() {
    background(0);
    text("Alpha v0.1", 10, 30, -150);
  }
  */