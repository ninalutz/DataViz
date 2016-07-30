boolean drawblue = true;
boolean draworange = true; 
boolean drawAll= true;
boolean showTowers = true;
boolean drawpurple = true;

void keyPressed(){
  switch(key){
  case 'n':
      //generates new random network
      key_n();
      break;
  case 'x':
      //generates new random network, doens't clear (fun mode)
      generate();
      break;    
  case 'b':
      drawblue = !drawblue;
      break;
  case 'o':
      draworange = !draworange;
      break;
  case 'p':
      drawpurple = !drawpurple;
      break;
  case 'a':
      //toggles drawing of all the lines
      drawAll = !drawAll;
      if(drawAll){
      drawblue = true;
      draworange = true;
      drawpurple = true;
      }
      if(!drawAll){
      drawblue = false;
      draworange = false;
      drawpurple = false;
      }
      break;
  case 't':
      //toggles the display of the origin and destinations
      showTowers = !showTowers;
      break;
  case '+':
      increment+=.0001;
      println("speed", increment);
      key_n();
      break;
  case '-':
      increment-=.0001;
      println("speed", increment);
      key_n();
      break; 
  }
}

void key_n(){
      purple.clear();
      blue.clear();
      orange.clear();
      purple.clear();
      OD.clear();
      Network.clear();
      generate();

}