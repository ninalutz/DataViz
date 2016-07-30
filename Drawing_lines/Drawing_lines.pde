/*
This is a simplified, randomized version (basicpurpley skeleton code) of part of a data visualization I'm writing for my lab at Changing Places. 
But I thought it was nice becuase it's actually a bit tricky to loop sketches in Processing and draw lines smoothly and fast

This script creates a random network of nodes and edges and animates them

You can adjust the number of nodes created, the speed, and toggle different edges

This is the first version, so it's a bit messy

Supervisor: Ira Winder
Developer: Nina Lutz, MIT Media Lab, Changing Places Group
*/


//delay between loops (in milliseconds)
int delay = 1000;
float increment = .0005;
long initialTime;
boolean needLoop = false;
  
void setup(){
 size(1200, 800, P3D);
 initialTime = millis();
 
 //generates the network
 generate();
 smooth();
}

void draw(){
  background(0);
  //resets initial time apporpriately after one iteration and delay
  if(needLoop){
    initialTime += duration;
    initialTime += delay;
    needLoop = !needLoop;
  }
  
  if(showTowers){
    drawNodes();
  }

  if(drawblue){
    drawNetwork(blue);
  }
  if(draworange){
    drawNetwork(orange);
  }
  if(drawpurple){
    drawNetwork(purple);
  }

}