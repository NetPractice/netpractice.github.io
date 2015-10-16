PImage lc, bc, eg;
void setup() {
  size(1000,600);
  stroke(155);
  strokeWeight(3);
  lc = loadImage("littlechick.gif");
  bc = loadImage("bigger.gif");
  eg = loadImage("egg.png");
  noCursor();
  textAlign(LEFT,CENTER);
  textSize(18);
  fill(255, 255, 0);
}
Snake snake = new Snake();
int snakegot;
int gratesgot;
ArrayList<Chick> chicks = new ArrayList<Chick>();
ArrayList<Grate> grates = new ArrayList<Grate>();
ArrayList<Egg> eggs = new ArrayList<Egg>();
boolean htt = true;
boolean leave = false;
Chick mama = new Chick(width/2, height/8);
int time;
int starttime = 61;
void draw() {
  background(55);
  time = floor(starttime - millis()/1000);
  if (time<1) {
    cursor();
    noStroke();
    fill(0, 0, 255);
    rect(width/3, height/3, width/3, height/3, 10);
    textAlign(CENTER, CENTER);
    textSize(24);
    fill(255);
    text("You have "+chicks.size() + " chicks!\n The snake got "+snakegot+"\nThe grates got "+gratesgot+"\nClick to play again.", width/2, height/2);
  } else { 
    fill(255, 255, 0);
    text("Chicks: "+chicks.size()+"   Time: "+time, 35, 35);

    if (eggs.size()==0) {
      eggs.add(new Egg());
    }
    if (grates.size()==0) {
      grates.add(new Grate(200,150,140,100));
      grates.add(new Grate(700,300,100,80));
      grates.add(new Grate(500,400,80,100));
    }
    if (chicks.size()>0) {
      for (int i = chicks.size()-1; i >= 0; i--) {
        Chick chick = chicks.get(i);

        if (i==chicks.size()-1) {
          chick.update(mama.x, mama.y+30);
        } else {
          Chick fchick = chicks.get(i+1);
          chick.update(fchick.x, fchick.y);
        }
      }
    }
    for (int e = eggs.size()-1; e>=0; e--) {
      Egg egg = eggs.get(e);
      if ((mama.x+bc.width>egg.x)&&(mama.x<egg.x+eg.width)
        &&(mama.y+bc.height>egg.y)&&(mama.y<egg.y+eg.height)) {
        chicks.add(new Chick(egg.x, egg.y));
        eggs.remove(e);
        eggs.add(new Egg());
      }
    }
    for (int i = chicks.size()-1; i >= 0; i--) {
      Chick chick = chicks.get(i);
      for (int g = 0; g<grates.size(); g++) {
        Grate grate = grates.get(g);
        if ((chick.x>grate.x)&&(chick.x<grate.x+grate.w-lc.width)
          &&(chick.y>grate.y)&&(chick.y<grate.y+grate.h-lc.width)) {
          chicks.remove(i);
          gratesgot++;
          break;
        }
      }
      chick.display(lc);
    }
    for (int i = grates.size()-1; i >= 0; i--) {
      Grate grate = grates.get(i);
      grate.display();
    } 
    for (int i = eggs.size()-1; i >= 0; i--) {
      Egg egg = eggs.get(i);
      egg.display();
    }
    if (chicks.size()>0){
    Chick lchick = chicks.get(0);
snake.update(lchick.x,lchick.y);
snake.display();
    }
    mama.mupdate(mouseX, mouseY);
    mama.display(bc);
    
  }
}
class Grate {
  float x, y, w, h;
  Grate() { 
    w=10*floor(random(4, 12));
    h=100;
    x=random(40, width-(w+40));
    y=random(40, height-(h+40));
  }
  Grate(float x_,float y_, float w_, float h_) { 
    w=w_;
    h=h_;
    x=x_;
    y=y_;
  }
  void display() {
    fill(0);
    stroke(155);
    rect(x, y, w, h, 3);
    for (float i = h; i>0; i=i-10) {
      line(x, y+i, x+w, y+i);
    }
  }
}
class Egg {
  float x, y;
  Egg() {
    x=random(20, width-40);
    y=random(20, height-40);
  }
  void display() {
    image(eg, x, y);
  }
}

class Chick {
  float x, y, xv, yv, xa, ya;
  Chick(float x_, float y_) {
    x = x_;
    y = y_;
  }
  void update(float gx, float gy) { 
    x = x + max(-3, min(3, (gx-x)/44));
    y = y + max(-3, min(3, (gy-y)/44));
    if ((abs(gx-x)+abs(gy-y)<10)&&(random(1)>.98)) {
      y=y+random(-6, 6);
      x=x+random(-3, 3);
    }
  }  
  void mupdate(float gx, float gy) {   
    x = x + max(-8, min(8, (gx-x)/15));
    y = y + max(-8, min(8, (gy-y)/15));
  }
  void display(PImage im) {
    if (mouseX>x) {
      pushMatrix();
      scale(-1.0, 1.0);
      image(im, -x-im.width, y);
      popMatrix();
    } else {
      image(im, x, y);
    }
  }
}

void mouseClicked() {
  
  if (time<1) {
    for (int i = chicks.size()-1; i >= 0; i--) {
       chicks.remove(i);    
    } 
    for (int i = grates.size()-1; i >= 0; i--) {
       grates.remove(i);    
    }
    starttime = millis()/1000+60;
textAlign(LEFT,CENTER);
    textSize(18);
    snakegot = 0;
    gratesgot = 0;
}
}

class Snake {
  float x,y,s;
  int numsegs, ecount, delay;
  boolean eating;
    ArrayList<Seg> segs = new ArrayList<Seg>();

  Snake(){
    x = -100;
    y = 300;
    s = 20;
    numsegs = 22;
    eating = false;
    ecount = 0;
    delay = 240;
    for (float i = numsegs+1;i>=1;i--){
      segs.add(new Seg(x,y,5+i*s/numsegs));
    }
  }
  void update(float gx, float gy){
    if (eating){
      ecount++;
      if (ecount==delay){eating = false;ecount=0;}
    }
    else{
      
      if (abs(gx-x)+abs(gy-y)<9){
        chicks.remove(0);
        snakegot++;
        eating = true;
      }
      
    if (gx-x>0){x = x + .4;}
    else {x = x - .3;}
    if (gy-y>0){y = y + .4;}
    else {y = y -.3;}
    if (abs(gx-x)+abs(gy-y)<120){
      x = x + (gx-x)/5;
      y = y + (gy-y)/5;
    }
    }
    for (int i = 0;i<segs.size();i++){
      Seg seg = segs.get(i);
      if (i>0){Seg pseg = segs.get(i-1);seg.update(pseg.x,pseg.y);}
      else {seg.update(x,y);}
    }
  
  }
  void display(){
    for (int i = 0;i<segs.size();i++){
      Seg seg = segs.get(i);
      seg.display();
    }
    fill(30,124,30,222);
        stroke(30,s*3+60,30,222);
    ellipse(x,y,20,20);
    fill(0,0,0);
    stroke(0);
    ellipse(x-4,y,5,3);
    ellipse(x+4,y,5,3);
}
}
class Seg {
  float x,y,s;
  Seg(float x_,float y_, float s_){
    x = x_;
    y = y_;
    s = s_;
  }
  void update(float gx, float gy){ 
    x = x + (gx-x)/10;
    y = y + (gy-y)/10;
    }
  void display(){
    fill(30,s*3+60,30,222);
    stroke(30,s*3+60,30,222);
    ellipse(x,y,s,s);
}
}