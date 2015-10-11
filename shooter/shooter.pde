void setup(){
  size(900,600);
  background(0);
  loop();
  strokeWeight(3);
}
int[][] waveal = {{3,4,2,3,0,0,4,0,5,4},  //Aliens in each wave
                  {0,1,0,0,6,0,0,8,6,4},   //Trialiens in each wave
                  {0,0,2,2,0,5,2,0,5,2}, //laser eyes
                  {0,0,0,1,0,4,0,5,0,3},  //rain clouds
                  {0,0,0,0,2,0,6,1,2,4}};   //checkboxer
int currentwave = 0;                       //Starting wave
int livingal = 0;
int backrow = 40;
float roll;
float bulletspeedstart = 4;                //Bullet speed resets to this value each wave
float bulletspeed = bulletspeedstart;
float bulletspeedinc = .8;                 //Bullet speed increases by this amount each time an alien is killed
float bulletlength = 10;
int first = 0;  
int h = 600;
int w = 900;
float shipy = (h-backrow)+10;
float shipx = w/2;
float shipwidth = 60;              //Player ship size
float[] alsize={70,70,16,220,160};                   //max Alien width at front
int[] dietimes = {30,50,40,30,60};           //frames of death animation
float alheightmax = 2*h/3;
float alheightmin = 80;
float shipspeed=0;
float health = 255;                //health for player and all enemy types
float[] healamount = {.2,0,0,0,0};        //heal amount per frame
int[] damage = {80,30,300,15,1};          //the damage a type takes
float[] friendlyfire = {40,0,0,10,0};      //amount healed when shot in the back
float playerdamage = 40;
float[] shotprob = {0.02,0,0,0.07,0.02};      //max shot probability per frame
int[] period = {0,300,100,140,99};              //frames between shots
float[] decelfactor = {.98,.96,.99,.993,.95};   //deceleration rate
float[] impulseprob = {.02,.02,.01,.01,.04};   //chance per frame that an enemy gets an impulse to move
float[] impulsepower = {500,500,500,500,150};  //strength of impulse
int maxbullets = 300;
int maxenemies = 100;
int highestbullet = 299;
int highestenemy = 99;
int stars = 25;
 float[] starSpeed = new float [stars*waveal[0].length];
    float[] x = new float [stars*waveal[0].length];
    float[] y = new float [stars*waveal[0].length];
Enemy[] enem = new Enemy[maxenemies];
Bullet[] bully = new Bullet[maxbullets];

void draw(){
   
  background(0);
   for (int i=0; i<stars; i++) {
        x[i]=x[i]+(x[i]-width/2)*starSpeed[i];
        y[i]=7+y[i]+(y[i]-height/2)*starSpeed[i];
        if ((x[i]>width)||(x[i]<0)||(y[i]>height)||(y[i]<0)){x[i]=random(width);y[i]=random(height);}
        fill(255);
        stroke(255);
        strokeWeight(1.5);
        point(x[i], y[i]);
      }
  textAlign(CENTER,CENTER);textSize(500);fill(20,100);text((currentwave+1),width/2,2*height/5);
  health = min(health + 0.4,255);
  fill(2*health/3,2*health/3,health);
  
stroke(255,health,0);
strokeWeight(3);
shipx = shipx + shipspeed;
  shipx = constrain(shipx,shipwidth/2,width-(shipwidth/2));
  shipspeed = shipspeed*.97;
  if (abs(shipspeed)<0.1){shipspeed=0;}
    rect(shipx-shipwidth/2,shipy,shipwidth,10,3);
    rect(shipx-2,shipy-14,4,10,1);
    ellipse(shipx,shipy,24,18);
   if (health<=0){gameover();}
 if (first==0){                   //Turn on the right enemy at the start of each wave       
   for (int i = 0;i<bully.length;i++){bully[i] = new Bullet();} 
   for (int i = 0;i<enem.length;i++){enem[i] = new Enemy();}
   for (int w = 0;w<waveal.length;w++){
     for (int i = 0;i<waveal[w][currentwave];i++){enem[lowestal()].start(w);}}
      for (int i = 0; i < stars; i++) {
        x[i] = int(random(0, width));
        y[i] = int(random(0, height));
        starSpeed[i] = (random(.02, .05));
      }
   first = 1;}
//Check for player/bullet collision
  for (int i = 0;i<bully.length;i++){
    if (bully[i].available==false){bully[i].update();}
    if ((abs(bully[i].ypos-shipy)<bulletspeed/2)&&(abs(bully[i].xpos-shipx)<shipwidth/2)){
      bully[i].stop();
      bully[i].update();
      health=health-playerdamage;
    } 
  } 
  for (int i = 0;i<=highestenemy;i++){
    if (enem[i].available==false){enem[i].update();}
  }
  if (livingal==0){currentwave++;bulletspeed=bulletspeedstart;health=255;first = 0;} //End of level check
  if (currentwave+1>waveal[1].length){background(0);noLoop();}  //End of game check
}


class Bullet{
  float xpos, ypos, speed, xspeed;
  boolean available;
  Bullet (){
    xpos = -100;
    ypos = 0;
    speed = 0;
    xspeed = 0;
    available = true;
  }
  void update(){
  ypos = ypos - speed;
  xpos = xpos + xspeed;
  stroke(255);
  strokeWeight(5);
  stroke(255);
  line(xpos,ypos+bulletlength/2,xpos,ypos-bulletlength/2);
  if ((ypos<0)||(ypos>height)){this.stop();}
  }
  void start(float x, float y, float s, float xs){
  xpos = x;
  ypos = y;
  speed = s;
  xspeed = xs;
  available = false;
  }  
  void stop(){
  available = true;
  xpos = -100;
  ypos = -100;
  }
}
int lowestavail(){
  int i=0;
  boolean noavail = true;
  while((i<bully.length)&&(noavail)){
    if (bully[i].available==true){noavail=false;}
    i++;
  }
  return(i-1);
}
int lowestal(){
  int i=0;
  boolean noavail = true;
  while((i<enem.length)&&(noavail)){
    if (enem[i].available==true){noavail=false;}
    i++;
  }
  return(i-1);
}
void keyPressed(){
  if ((key=='p')||(key=='P')){pause();}
  if (key=='1'){livingal=0;}
if (key=='l'){print(livingal);}
  if ((key=='r')||(key=='R')){restart();loop();}
  if (health > playerdamage/2){
       health=health-5;
  if (key==' ') {bully[lowestavail()].start(shipx+1,height-backrow,bulletspeed,0);}
  if (key=='q') {enem[lowestal()].start(1);}
   if (key == CODED) {
    if (keyCode == LEFT) {
      shipspeed=shipspeed-4;} 
      if (keyCode == RIGHT) {
      shipspeed=shipspeed+4;}
       if (keyCode == UP) {
      bully[lowestavail()].start(shipx+1,height-backrow,bulletspeed,0);}
    }
  }
}
void win(){
   textAlign(CENTER,CENTER);
  textSize(30);
  fill(255,0,0);
  text("Congratulations - You are alone now.",width/2,height/2);
noLoop();
  
  
  
}
void gameover(){
  textAlign(CENTER,CENTER);
  textSize(30);
  fill(255,0,0);
  text("GAME OVER - Press 'R' to retry.",width/2,height/2);
noLoop();
}
void pause(){
  if (looping){
  textAlign(CENTER,CENTER);
  textSize(30);
  fill(255,0,255);
  text("PAUSED - Press 'P' to unpause.",width/2,height/2);
noLoop();
  }
  else {loop();}
}
void restart(){
currentwave = 0;
livingal = 0;
 bulletspeed = 4;
 first = 0;  
 shipx = width/2;
 shipspeed=0;
 health = 255;
}
class Enemy{
  float xpos,ypos,prob,speed,health,size,decel,impulse,ipower,ff,heal,adjustment;
  boolean available, dying;
  int type, dietime, dam, timer, per;
  int[] section = {1,1,1};
  Enemy(){
    available = true;dying = false;
  }
  void update(){   
    if (dying){  //death animations and actions
      dietime--;
      switch(type){
        case 0: //green alien
            fill(255*dietime/dietimes[0]);
            stroke(0,255,0);
            arc(xpos, ypos, size, size, PI, 2*PI);
            fill(255);
            ellipse(xpos-size/4,ypos-size/4,size/6,size/6);
            ellipse(xpos+size/4,ypos-size/4,size/6,size/6);
            line(xpos+size/2,ypos,xpos-size/2,ypos);
            break;
        case 1: //red triangle alien
            float shrink = (size/2) * dietime/dietimes[1];
            fill(255*dietime/dietimes[1],0,0);
            noStroke();
            triangle(xpos, ypos-shrink, xpos-size/2, ypos, xpos+size/2, ypos);
            fill(255*dietime/dietimes[1]);
            ellipse(xpos,ypos-size/2.4,shrink/2.5,shrink/2.5);
            break;
        case 2: //laser eye
            fill(255,255,0);
            noStroke();
            size = size * .9;
            if (size < 1){break;}
            for (float i = size;i < 5*alsize[2];i=i+size){
                ellipse(xpos,ypos-i,size,size);
            }
            break;
        case 3:
            strokeWeight(3+dietime);
            fill(50,0,160); 
            stroke(255);
            rect(xpos-size/2,ypos-alsize[3]/10,size,alsize[3]/10,7);
            break;
         case 4:           
            strokeWeight(3);
            stroke(255*(dietime/dietimes[4]));
            fill(200*dietime/dietimes[4]);
            rect(xpos-size/2,ypos-size/3,size/3,size/3);
            rect(xpos-size/6,ypos-size/3,size/3,size/3);  
            rect(xpos+size/6,ypos-size/3,size/3,size/3);
            break;
    }
        if (dietime==0){this.stop();}
    }
    else {
        roll = random(1);
        for (int i = 0;i<=highestbullet;i++){
          if (bully[i].available==false){
            switch(type){ 
              case 0: case 1: case 2: case 3:
                if ((bully[i].xpos>xpos-size/2)&&(bully[i].xpos<xpos+size/2)&&(abs(bully[i].ypos-(ypos-10))<bulletspeed/2)){                
                  if (bully[i].speed>0){health=health-dam;}
                else {health=health+ff;}
                bully[i].stop();
                if (health<=0){dying=true;}
                }
                break;               
                case 4:
                   if ((bully[i].speed>0)&&(abs(bully[i].ypos-ypos)<bulletspeed/2)){                
                   if ((bully[i].xpos>xpos-size/2)&&(bully[i].xpos<xpos-size/6)){section[0]++;section[0]=section[0]%2;bully[i].stop();}
                   if ((bully[i].xpos>xpos-size/6)&&(bully[i].xpos<xpos+size/6)){section[1]++;section[1]=section[1]%2;bully[i].stop();}
                   if ((bully[i].xpos>xpos+size/6)&&(bully[i].xpos<xpos+size/2)){section[2]++;section[2]=section[2]%2;bully[i].stop();}
                health = health*(section[0]+section[1]+section[2]);
              if (health<=0){dying=true;}
              break;               
        }
       }
      }
    } 
  
    noStroke();
    switch(type){
      case 0:
            fill(health/5,health,0);
            arc(xpos, ypos, size, size, PI, 2*PI);
            fill(50);
            ellipse(xpos-size/4,ypos-size/4,size/6,size/6);
            ellipse(xpos+size/4,ypos-size/4,size/6,size/6);
            break;
    case 1:
            fill(health,0,0);
            triangle(xpos, ypos-size/2, xpos-size/2, ypos, xpos+size/2, ypos);
            fill(255*timer/per);
            ellipse(xpos,ypos-size/2.4,size/5,size/5);
            if (timer>=per){bully[lowestavail()].start(xpos,ypos+bulletspeed,-bulletspeed,0);
                            bully[lowestavail()].start(xpos-size/2,ypos+bulletspeed,-bulletspeed,0);
                            bully[lowestavail()].start(xpos+size/2,ypos+bulletspeed,-bulletspeed,0);
                            
                            bully[lowestavail()].start(xpos-size/4,ypos+bulletspeed+20,-bulletspeed,0);
                            bully[lowestavail()].start(xpos+size/4,ypos+bulletspeed+20,-bulletspeed,0);
                            
                            bully[lowestavail()].start(xpos,ypos+bulletspeed+40,-bulletspeed,0);
                            timer = 0;
            }
                            
            break;   
     case 2:
            fill(255,255,0);
            rect(xpos-size/2,ypos-4*size,size,4*size);
            ellipse(xpos,ypos-5*size,size,size);
            if ((timer>=per-20)&&(timer%3==0)){bully[lowestavail()].start(xpos,ypos+bulletspeed,-bulletspeed,0);}
            if (timer>=per){timer=0;}
            break;
     case 3:
            strokeWeight(3);
            speed=speed-.1;if (xpos<shipx){speed=speed+.2;}
            size = 9*alsize[3]/10 * health/255 + alsize[3]/10;
            prob = shotprob[3] * health/255;
            fill(50,0,160); 
            stroke(255);
            rect(xpos-size/2,ypos-alsize[3]/10,size,alsize[3]/10,7);
            adjustment = 0; adjustment = random(-size/2,size/2);
            break;
     case 4:           
            strokeWeight(3);
            stroke(255);
            fill(200*section[0],100);
            rect(xpos-size/2,ypos-size/3,size/3,size/3,2);
            fill(200*section[1],100);
            rect(xpos-size/6,ypos-size/3,size/3,size/3);  
            fill(200*section[2],100);
            rect(xpos+size/6,ypos-size/3,size/3,size/3,2);
                if (xpos==width-size/2){speed=speed-(ipower/100);}
                if (xpos==size/2){speed=speed+(ipower/100);}
            if (section[timer%3]==0) {roll=.5;}
            else {adjustment = -size/3+((timer%3)*size/3);}
      }
      if (timer>per){timer=0;}
        health = min(health + healamount[type],255);
    xpos =  xpos + speed;
    speed = speed * decel;
    timer++;
    xpos = constrain(xpos,size/2,width-size/2);
    if ((type==2)&&(xpos<1+size/2)){xpos=-1+width-size/2;}
    if ((type==2)&&(xpos>-1+width-size/2)){xpos=1+size/2;}
    
    if (prob >roll){bully[lowestavail()].start(xpos+adjustment,ypos+bulletspeed,-bulletspeed,0);}
    if (roll<impulse){speed=speed+(ipower*(roll-impulse/2));}
    }
  }
 
   void start(int t){
  type = t;
  xpos = random(width);
  ypos = random(alheightmin,alheightmax);
  speed = 0;
  health = 255;
  if (type==3){health=130;}
  int[] section = {1,1,1};
  dam = damage[type];
  size = alsize[type];
  prob = shotprob[type];
  per = period[type];
  timer = 0;
  if (type==2){per=floor(random(per/2,3*per/2));}
  dietime = dietimes[type];
  decel = decelfactor[type];
  impulse = impulseprob[type];
  ipower = impulsepower[type];
  heal = healamount[type];
  ff = friendlyfire[type];
  available = false;
  livingal++;
  }  
  void stop(){
  available = true;
  ypos = -100;
  livingal--;
  bulletspeed = bulletspeed + bulletspeedinc;
  }
}
