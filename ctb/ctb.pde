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
int moves = 12;
int boardheight = 440;
int level = 1;//changing this will not actually skip levels.
boolean first = true;
boolean pause = false;
int numclicks = 1;
int numwide = 3;
int numhigh = 4;
Board main = new Board(300, 40.0, numwide, numhigh, boardheight/numhigh);
boolean won = false;
boolean lost = false;
void draw() {
  
  if (first) {
    for (int i = 0; i<1; i++) {
      fakeClick();
    }
    first = false;
  }
  background(0);
  fill(255, 255, 0); 

  text("F L I P   T O   W H I T E", 305, 30);
  text("Level: " + level, 305, 75+boardheight);
  fill(255,0,0);
  text("Moves: " + moves, 305, 105+boardheight);
  main.display();
  if (won) {pause=true;}
  if (lost) {pause=true;}
  if (pause) {
    fill(100);
    rect(50,40,220,440,11);
    fill(255, 255, 0);
    if (won){text("BOARD \nCLEAR!\n\nCLICK \nHERE\nFOR\nLEVEL "+(level+1), 100, 130);}
    if (lost){text("YOU \nLOSE!\n\nCLICK \nHERE\nTO\nTRY\nAGAIN ", 100, 95);}
  }
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
        square.col+=5;
      }
      if ((square.state==1)&&(square.col>100)) {
        square.col-=5;
      }
      if (square.col>178){fill(255);}
        else{fill(100);}
      rect(square.xpos+((square.pix/2)*(255-square.col)*(square.col-100)/6200), square.ypos, square.pix-((square.pix)*(255-square.col)*(square.col-100)/6200), square.pix, 11);
    }
  }
}
void mouseClicked() {
  if (pause){
    if ((mouseX>50)&&(mouseX<270)&&(mouseY>40)&&(mouseY<480)){keyPressed();}
  }
  if (!pause) {
    if (((mouseY>main.ypos)&&(mouseY<main.ypos+main.bheight*main.squarepx))&&((mouseX>main.xpos)&&(mouseX<main.xpos+main.bwidth*main.squarepx))) {
              moves--;
      for (int i = 0; i<main.squares.size(); i++) {
        Square square = main.squares.get(i);
        if (((mouseY>=square.ypos)&&(mouseY<square.ypos+square.pix))||((mouseX>=square.xpos)&&(mouseX<square.xpos+square.pix))) {
          square.state++;
          square.state=square.state%2;
        }
      }
    }
    if ((!lost)&&(win())) {
    won = true;
      pause = true;
    }
    else if (moves==0){lose();}
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
  won = true;
  return true;
}
void lose(){
  lost = true;
  pause=true;
    }
void keyPressed() {
  if (pause) {
    pause = false;
    if (won){
    won = false;
    level++;
    numclicks++;
    if (numclicks%2==1) {
      numwide++;
    } else if (numclicks%3==1) {
      numhigh++;
    } else if (numclicks%5==1) {
      numhigh++;
    }
    moves = moves + (numwide * numhigh);
    main = new Board(300, 40.0, numwide, numhigh, boardheight/numhigh);
    
    for (int i = 0; i<level; i++) {
      fakeClick();
    }
  }
    if (lost){
      lost = false;
      moves = 12;
level = 1;//changing this will not actually skip levels.
numclicks = 1;
numwide = 3;
numhigh = 4;
main = new Board(300, 40.0, numwide, numhigh, boardheight/numhigh);
fakeClick();
    }
    }
}
