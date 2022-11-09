import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import org.gicentre.handy.HandyRenderer;
import processing.serial.*;
import processing.sound.*;

// declare a SoundFile object
SoundFile camera_sound;
SoundFile judging_sound;
//SoundFile juding_voice;

PImage img;

//Variables for the cartoon character
float eyes_height;
float eyes_width;
float face_width;
float face_height;
Capture video;
OpenCV opencv;
HandyRenderer h;
float last_face_X;
float last_face_Y;
float last_face_Width;
float last_face_Height;
int count =0;
// Variables for eyes

int number_of_eyes = 25;
float faceX[] = new float [number_of_eyes];
float faceY[] = new float [number_of_eyes];
float faceSize[]= new float [number_of_eyes];
float Eyes_1_X[] = new float [number_of_eyes];
float Eyes_2_X[] = new float [number_of_eyes];
float EyesY[] = new float [number_of_eyes];
float EyesRadius[] = new float [number_of_eyes];
float x,y,faceWidth,faceHeight;
float small_last_face_X,  small_last_face_Y ,small_last_face_width ,small_last_face_height ;

// variables for bluetooth

int NUM_OF_VALUES = 1;   /** YOU MUST CHANGE THIS ACCORDING TO YOUR PROJECT **/
int sensorValues[];      /** this array stores values from Arduino **/
int sound_display = 0;
String myString = null;
Serial myPort;




void setup() {

 
  // size(640, 480);
  //video = new Capture(this, 640/2, 480/2);
  //opencv = new OpenCV(this, 640/2, 480/2);
  String[] cameras = Capture.list();
  fullScreen();
  video = new Capture(this,  width/2, height/2);//,cameras[1]);
  opencv = new OpenCV(this, width/2, height/2);
  //video = new Capture(this, 320, 240);
  //opencv = new OpenCV(this, 320, 240);
  //wi = width / video.width;
  //hi = height / video.height;
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  
  h = new HandyRenderer(this);
  h.setOverrideFillColour(true);
  h.setOverrideStrokeColour(true);
  h.setIsAlternating(true);
  for (int i = 0; i <number_of_eyes; i++) {
    faceX[i] = random(width/2);
    faceY[i] = random(height/2);
    faceSize[i] = random(50);
    EyesY[i] = random(50, height/2);
    EyesRadius[i] = faceSize[i]/10;
    Eyes_1_X[i] = random(100, width/2) - EyesRadius[i]/2;
    Eyes_2_X[i] =  Eyes_1_X[i] + 2*EyesRadius[i]/2;
  }
  camera_sound= new SoundFile(this, "camera.wav");
  judging_sound = new SoundFile(this, "whispering.wav");
  img = loadImage("Ignite-Blog-Mock.png");
  img.resize(width, height);
  //setupSerial();
}


void draw() {
  //getSerialData();
  //count = sensorValues[0];
  if (keyPressed == true){
    
    count =1;
  
  }else{
  count = 0;
  }
  //print(count);
  translate(width,0);
  scale(-2,2);
  

  Rectangle[] faces = opencv.detect();

  opencv.loadImage(video);


  smooth();
    
   if (video.available()) { 
    video.read();
  } 
 background(img);
  
  if (count == 1) {  
         if(sound_display == 0) {
        // if it is not playing, play it
        camera_sound.play();  
        sound_display += 1;
        }else{
          
       if(judging_sound.isPlaying() == false) {
    // if it is not playing, play it
       judging_sound.play();  
    }
        
        
        }
  
    h.setBackgroundColour(color(255));
    h.setFillColour(color(255));
 
     for (int i = 0; i <number_of_eyes; i++) {
      creepyCharacters(faceX[i],faceY[i],faceSize[i],faceSize[i],EyesRadius[i],small_last_face_X,small_last_face_Y);
  }
    
       if (faces.length > 0 ){//&& last_face_X < width && last_face_X>0) {
          for (int i = 0; i < faces.length; i++) {
         x = map(faces[i].x,0, width,0,900);
         y = map(faces[i].y,0, height,200,400);
         faceWidth = map(faces[i].width,0, faces[i].width,0,80);
         faceHeight = map(faces[i].height,0, faces[i].height,0,80);    
         drawCapturedCharacter(x, y, faceWidth, faceHeight);
       //  drawCharacter(faces[i].x, faces[i].y, faces[i].width, faces[i].height, count);
        small_last_face_X = x;
        small_last_face_Y = y;
        small_last_face_width = faceWidth;
        small_last_face_height = faceHeight;
        }
  
  } else { 
    
      small_last_face_X = map(small_last_face_X ,0, width,0,900);
     small_last_face_Y = map(small_last_face_Y ,0, height,200,400);
     small_last_face_width = map(small_last_face_width ,0, last_face_Width,0,80);
     small_last_face_height = map(small_last_face_height ,0, last_face_Height,0,80);
     drawCapturedCharacter(small_last_face_X,  small_last_face_Y, small_last_face_width,  small_last_face_height);
 

  }
 
}else{
    judging_sound.stop();
    pushMatrix();
    if (faces.length <= 0 ){//&& last_face_X < width && last_face_X>0) {
    drawCharacter(last_face_X, last_face_Y, last_face_Width, last_face_Height);
  } else { 
    for (int i = 0; i < faces.length; i++) {
     drawCharacter(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
     last_face_X = faces[i].x;
      last_face_Y = faces[i].y;
      last_face_Width = faces[i].width;
      last_face_Height = faces[i].height;
    }
    sound_display = 0;
  }

  popMatrix();

  }
}


void captureEvent(Capture c) {
  c.read();
}


void drawCharacter(float faceX, float faceY, float faceWidth, float faceHeight) {
  h.setBackgroundColour(color(255));
  h.setFillColour(color(255));
  stroke(0);
  // body
  h.triangle(faceX + faceWidth/2, faceY, faceX - faceWidth, height + 200, faceX+ 2*faceWidth, height+ 200);
 
  // face
  h.ellipse(faceX + faceWidth/2, faceY + faceHeight/2, faceWidth*7/5, faceHeight*7/5);
 // strokeWeight(1);
  // stroke(0);
  //eyes
  //noFill();
  h.ellipse(faceX + faceWidth/4, faceY + faceHeight/3, faceWidth/3, faceWidth/3);
  h.ellipse(faceX + faceWidth*9/12, faceY + faceHeight/3, faceWidth/3, faceWidth/3);
  h.setBackgroundColour(color(255));
  h.setFillColour(color(0));
  h.ellipse(faceX + faceWidth/4, faceY + faceHeight/3, faceWidth/10, faceWidth/10);
  h.ellipse(faceX + faceWidth*9/12, faceY + faceHeight/3, faceWidth/10, faceWidth/10);
  //nose
  h.line(faceX + faceWidth/2, faceY + faceHeight/2, faceX + faceWidth*4/7, faceY + faceHeight*5/7);
  h.line(faceX + faceWidth*4/7, faceY + faceHeight*5/7, faceX + faceWidth/2, faceY + faceHeight*5/7);
  // mouth
  //  h.line(faceX + faceWidth*3/8, faceY + faceHeight*7/8, faceX + faceWidth/2, faceY + faceHeight*14/15);
  //  h.line(faceX + faceWidth/2, faceY + faceHeight*14/15, faceX + faceWidth*5/8, faceY + faceHeight*7/8);
    h.line(faceX + faceWidth/2, faceY + faceHeight*7/8, faceX + faceWidth*3/8, faceY + faceHeight*14/15);
  h.line(faceX + faceWidth/2, faceY + faceHeight*7/8, faceX + faceWidth*5/8, faceY + faceHeight*14/15);
  //// hat
  //  stroke(0);
  h.setBackgroundColour(color(255));
  h.setFillColour(color(206, 76, 52));

  h.ellipse(faceX + faceWidth/2, faceY -faceHeight*2/3, faceWidth/15, faceWidth/15);
  h.triangle(faceX + faceWidth/2, faceY -faceHeight*2/3, faceX+faceWidth/7, faceY-faceHeight/4, faceX+faceWidth*4.5/7, faceY-faceHeight/4);
}

void creepyCharacters(float faceX , float faceY, float faceWidth, float faceHeight, float eyesize, float last_face_X,float last_face_Y){

  h.setBackgroundColour(color(255));
  h.setFillColour(color(255));
  stroke(0);
  // body
  h.triangle(faceX + faceWidth/2, faceY, faceX - faceWidth, height + 200, faceX+ 2*faceWidth, height+ 200);

  // face
  h.ellipse(faceX + faceWidth/2, faceY + faceHeight/2, faceWidth*7/5, faceHeight*7/5);
 // strokeWeight(1);
  // stroke(0);
  //eyes
  //noFill();
  h.ellipse(faceX + faceWidth/4, faceY + faceHeight/3, faceWidth/3, faceWidth/3);
  h.ellipse(faceX + faceWidth*9/12, faceY + faceHeight/3, faceWidth/3, faceWidth/3);
  h.setBackgroundColour(color(255));
  h.setFillColour(color(0));
  h.ellipse(faceX + faceWidth/4+ (eyesize / 4) * cos(atan2(last_face_Y - faceY + faceHeight/3, last_face_X - faceX + faceWidth/4)),faceY + faceHeight/3 + (eyesize/4) * sin(atan2(last_face_Y - faceY + faceHeight/3, last_face_X - faceX + faceWidth/4)), eyesize/ 4, eyesize/4);
  h.ellipse(faceX + faceWidth*9/12+ (eyesize / 4) * cos(atan2(last_face_Y - faceY + faceHeight/3, last_face_X - faceX + faceWidth*9/12)),faceY + faceHeight/3 + (eyesize/4) * sin(atan2(last_face_Y - faceY + faceHeight/3, last_face_X - faceX + faceWidth*9/12)), eyesize/ 4, eyesize/4);
 
 ////nose
  h.line(faceX + faceWidth/2, faceY + faceHeight/2, faceX + faceWidth*3/7, faceY + faceHeight*5/7);
  h.line(faceX + faceWidth*3/7, faceY + faceHeight*5/7, faceX + faceWidth/2, faceY + faceHeight*5/7);
  // mouth

    h.line(faceX + faceWidth*3/8, faceY + faceHeight*7/8, faceX + faceWidth/2, faceY + faceHeight*14/15);
    h.line(faceX + faceWidth/2, faceY + faceHeight*14/15, faceX + faceWidth*5/8, faceY + faceHeight*7/8);


}
void drawCapturedCharacter(float faceX, float faceY, float faceWidth, float faceHeight) {
  h.setBackgroundColour(color(255));
  h.setFillColour(color(255));
  stroke(0);
  // body
  h.triangle(faceX + faceWidth/2, faceY, faceX - faceWidth/2, faceY + 150 , faceX+ faceWidth*3/2,faceY+150);

  // face
  h.ellipse(faceX + faceWidth/2, faceY + faceHeight/2, faceWidth*7/5, faceHeight*7/5);

  //eyes

  h.ellipse(faceX + faceWidth/4, faceY + faceHeight/3, faceWidth/3, faceWidth/3);
  h.ellipse(faceX + faceWidth*9/12, faceY + faceHeight/3, faceWidth/3, faceWidth/3);
  h.setBackgroundColour(color(255));
  h.setFillColour(color(0));
  h.ellipse(faceX + faceWidth/4, faceY + faceHeight/3, faceWidth/10, faceWidth/10);
  h.ellipse(faceX + faceWidth*9/12, faceY + faceHeight/3, faceWidth/10, faceWidth/10);
  //nose
  h.line(faceX + faceWidth/2, faceY + faceHeight/2, faceX + faceWidth*3/7, faceY + faceHeight*5/7);
  h.line(faceX + faceWidth*3/7, faceY + faceHeight*5/7, faceX + faceWidth/2, faceY + faceHeight*5/7);
  // mouth
  h.line(faceX + faceWidth/2, faceY + faceHeight*7/8, faceX + faceWidth*3/8, faceY + faceHeight*14/15);
  h.line(faceX + faceWidth/2, faceY + faceHeight*7/8, faceX + faceWidth*5/8, faceY + faceHeight*14/15);
  h.setFillColour(color(0, 0, 255));
  strokeWeight(0.5);
  h.ellipse(faceX + faceWidth/4, faceY + faceHeight*2/3, faceWidth*1/20, faceWidth*1/9);
  // hat
  //  stroke(0);
  h.setBackgroundColour(color(255));
  h.setFillColour(color(206, 76, 52));
  h.ellipse(faceX + faceWidth/2, faceY -faceHeight*2/3, faceWidth/15, faceWidth/15);
  h.triangle(faceX + faceWidth/2, faceY -faceHeight*2/3, faceX+faceWidth/7, faceY-faceHeight/4, faceX+faceWidth*4.5/7, faceY-faceHeight/4);
}





//void setupSerial() {
//  printArray(Serial.list());
//  myPort = new Serial(this, Serial.list()[ 4 ], 9600);

//  myPort.clear();
//  // Throw out the first reading,
//  // in case we started reading in the middle of a string from the sender.
//  myString = myPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
//  myString = null;
//  sensorValues = new int[NUM_OF_VALUES];
//}



//void getSerialData() {
//  while (myPort.available() > 0) {
//    myString = myPort.readStringUntil( 10 ); // 10 = '\n'  Linefeed in ASCII
//    if (myString != null) {
//      String[] serialInArray = split(trim(myString), ",");
//      if (serialInArray.length == NUM_OF_VALUES) {
//        for (int i=0; i<serialInArray.length; i++) {
//          sensorValues[i] = int(serialInArray[i]);
//        }
//      }
//    }
//  }
//}
