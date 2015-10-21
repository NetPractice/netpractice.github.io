PImage out, in, knife;
  PGraphics mask, smask;

void setup(){
  //fullScreen();
  size(1200,800);
  noCursor();
  out = loadImage("outside.png");
  out.resize(width,height);
  in = loadImage("inside.jpg");
    in.resize(width,height);

  knife = loadImage("knife.png");
  mask = createGraphics(width,height);
  mask.beginDraw();
  mask.endDraw(); 
  smask = createGraphics(width,height);
  smask.beginDraw();
  smask.endDraw();
  
 in.loadPixels();
 out.loadPixels();
 mask.loadPixels();
 smask.loadPixels();
 //stroke(50);
  for (int i = 0;i<width*height;i++){
    if (out.pixels[i]==0){smask.pixels[i]=1;}
  }
}
color exterior_color = color(0,0,0);
float size=6;
float base_size = 6;
float dim = 1;
boolean dimming = false;
float lastX,lastY;
int pcount = 0;
int pause = 8;
int maxdim = 80;
float radj,gadj,badj;
float xdelta,ydelta;
void draw(){
  //background(0);
  
 loadPixels();
 if (dimming){dim=dim+1;
 if (dim>=maxdim){dimming = false;}
 }
if (frameCount>1){
 if (mousePressed){
     mask.beginDraw();
   if (((abs(mouseX-lastX))<1)&&(abs(mouseY-lastY)<1)){
     pcount++;
     if (pcount>pause){
     size=size+1;    
     mask.strokeWeight(1);
       mask.ellipse(mouseX,mouseY,size,size);
     }
          mask.endDraw();
   }
   else{pcount = 0;
   mask.strokeWeight(size);
     mask.line(mouseX,mouseY,lastX,lastY);
          mask.endDraw();
   }
 }
 else size = base_size;
}
lastX = mouseX;
   lastY = mouseY;
  for (int i = 0;i<width*height;i++){
   if (mask.pixels[i]==0){
     
     pixels[i]=color(
     red(out.pixels[i])-dim,
     green(out.pixels[i])-dim,
     blue(out.pixels[i])-dim);
  }
   else if (smask.pixels[i]==0){
   //radj = .99*(radj + random(-2,2));
   pixels[i]=color(red(in.pixels[i])+radj,green(in.pixels[i]),blue(in.pixels[i]));
     xdelta = i%width - width/2;
     ydelta = i/width -height/2;
     for (int j = 1;j<7+xdelta/30;j++){
   if (mask.pixels[i+j]==0){pixels[i]=color(180+j*5,80+j*5,50);break;}
     }
     for (int j = 1;j<7-xdelta/30;j++){
   if (mask.pixels[i-j]==0){pixels[i]=color(180+j*5,80+j*5,50);break;}
     }
     for (int j = 1;j<7+ydelta/30;j++){
   if (mask.pixels[i+j*width]==0){pixels[i]=color(180+j*5,80+j*5,50);break;}
     }
     for (int j = 1;j<7-ydelta/30;j++){
   if (mask.pixels[i-j*width]==0){pixels[i]=color(180+j*5,80+j*5,50);break;}
     }
 }
  
else {pixels[i]=exterior_color;} 
}
updatePixels();
image(knife,mouseX,mouseY-knife.height);
}

void keyPressed(){
  if (key ==' '){
    if (dimming){dimming=false;dim = 1;}
    else {
      if (dim==maxdim){dim=1;}
      else{dimming=true;}
    }
  }
  if (key =='r'){
  mask = createGraphics(width,height);
  mask.beginDraw();
  mask.endDraw(); 
  }
}
