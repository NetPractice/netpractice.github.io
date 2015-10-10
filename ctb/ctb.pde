//THIS VERSION OF 'Clear the Board' GAME MAY NOT APPEAR CORRECTLY ON SMALLER SCREENS.
//TRY REDUCING boardheight BELOW

//EVERY LEVEL HAS A SOLUTION.
//LEVELS WILL CHANGE EVERY TIME YOU PLAY.

void setup() {
size(1100,600);
  strokeWeight(5);
  fill(255);
  textSize(30);
}
int boardheight = 440;

int level = 1;//changing this will not actually skip levels.
boolean first = true;
boolean pause = false;
int numclicks = 1;
int numwide = 3;
int numhigh = 4;
Board main = new Board(300, 40.0, numwide, numhigh, boardheight/numhigh);

void draw() {
  
  if (first) {
    for (int i = 0; i<1; i++) {
      text("Make\nEvery\nSquare\nWhite", 100, 25);}

      fakeClick();
    }
    first = false;
  }
  background(0);
  fill(255, 255, 0);
  text("C l e a r   t h e   B o a r d", 305, 25);
  text("Level: " + level, 305, 75+boardheight);
  main.display();
  if (win()) {pause=true;}
  fill(255, 255, 0);
  if (pause) {text("BOARD \nCLEAR!\n\nANY \nKEY\nTO\nCONTINUE", 100, 25);}
}
class Square {
  int state;
  float xpos, ypos, pix;
  int col;
  Square(float x, float y, float p) {
    xpos = x;
    ypos = y;
    pix = p;
    state = 0;
    col = 255;
  }
}
class Board {
  float xpos, ypos, squarepx;
  int bwidth, bheight;
  ArrayList<Square> squares = new ArrayList<Square>();
  Board(float x, float y, int bw, int bh, float p) {
    xpos = x;
    ypos = y;
    bwidth = bw;
    bheight = bh;
    squarepx = p;
    for (int i = 0; i<bheight; i++) {
      for (int j = 0; j<bwidth; j++) {
        squares.add(new Square(xpos + j * squarepx, ypos + i * squarepx, squarepx));
      }
    }
  }
  void display() {
    for (int i = 0; i<squares.size(); i++) {
      Square square = squares.get(i);
      if ((square.state==0)&&(square.col<255)) {
        square.col+=15;
      }
      if ((square.state==1)&&(square.col>100)) {
        square.col-=15;
      }
      fill(square.col);
      rect(square.xpos, square.ypos, square.pix, square.pix, 11);
    }
  }
}
void mouseClicked() {
  if (!pause) {
    if (((mouseY>main.ypos)&&(mouseY<main.ypos+main.bheight*main.squarepx))&&((mouseX>main.xpos)&&(mouseX<main.xpos+main.bwidth*main.squarepx))) {
      for (int i = 0; i<main.squares.size(); i++) {
        Square square = main.squares.get(i);
        if (((mouseY>=square.ypos)&&(mouseY<square.ypos+square.pix))||((mouseX>=square.xpos)&&(mouseX<square.xpos+square.pix))) {
          square.state++;
          square.state=square.state%2;
        }
      }
    }
    if (win()) {
      level++; 
      pause = true;
    }
  }
}
void fakeClick() {
  int fx = floor(random(main.xpos, main.xpos+main.bwidth*main.squarepx));
  int fy = floor(random(main.ypos, main.ypos+main.bheight*main.squarepx));
  for (int i = 0; i<main.squares.size(); i++) {
    Square square = main.squares.get(i);
    if (((fy>=square.ypos)&&(fy<square.ypos+square.pix))||((fx>=square.xpos)&&(fx<square.xpos+square.pix))) {
      square.state++;
      square.state=square.state%2;
    }
  }
  if (win()) {
    fakeClick();
  }
}
boolean win() {
  for (int i = 0; i<main.squares.size(); i++) {
    Square square = main.squares.get(i);
    if (square.state == 1) {
      return false;
    }
  }
  return true;
}
void keyPressed() {
  if (pause) {
    pause = false;
    numclicks++;
    if (numclicks%2==1) {
      numwide++;
    } else if (numclicks%3==1) {
      numhigh++;
    } else if (numclicks%5==1) {
      numhigh++;
    }
    main = new Board(300, 40.0, numwide, numhigh, boardheight/numhigh);
    ;
    for (int i = 0; i<level; i++) {
      fakeClick();
    }
  }
}
