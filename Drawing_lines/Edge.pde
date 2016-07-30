ArrayList<Edge> all = new ArrayList<Edge>();
ArrayList<Edge> blue = new ArrayList<Edge>();
ArrayList<Edge> orange = new ArrayList<Edge>();
ArrayList<Edge> purple = new ArrayList<Edge>();
ArrayList<Node> OD = new ArrayList<Node>();
ArrayList<Node> Network = new ArrayList<Node>();
int duration;
color[] colarray = new color[3];


//generates a network of edges
void generate(){
    //sets colors
    colarray[0] = color(255,140,0); //orange; orange
    colarray[1] = color(239, 205, 255); //purple; purple
    colarray[2] = color(0, 102, 200); //blue; blue
    
   for(int i = 0; i<50; i++){
        PVector location = new PVector(random(50, width-50), random(50, height-50));
        Node node = new Node(location, i, 0);
        OD.add(node);
    }
    
    //generates arrays of edges
    for(int i = 0; i<20; i++){
        int k = int(random(0, 3));
        int j = int(random(0, OD.size()));
        int h = int(random(0, OD.size()));
        int amount = int(random(5, 40));
        Edge edge = new Edge(OD.get(j).location, OD.get(h).location, increment, amount, colarray[k]);
        
        Network.add(OD.get(j));
        Network.add(OD.get(h));
        
        all.add(edge);
        
        //adds edges to their appropriate arrays
        if(k == 2){
          blue.add(edge);
        }
        if(k == 0){
          orange.add(edge);
        }
        if(k == 1){
          purple.add(edge);
        }
    }
}

public class Node{
  PVector location; 
  int id;
  int total;
  ArrayList <Edge> edges = new ArrayList<Edge>();
  
  Node(PVector _location, int _id, int _total){
        location = _location;
        id = _id;
        total = _total;
            }
            
  
  void drawNetworkNodes(){
        noStroke();
        fill(#ffff00, 200);
        ellipse(location.x, location.y, 30, 30);
      }
      
 void drawNodes(){
        noStroke();
        fill(#ffff00, 50);
        ellipse(location.x, location.y, 30, 30);
        textSize(18);
        fill(#ff0000);
        text(str(id), location.x+15, location.y-5);
     } 
  
}

//Edge class 
public class Edge {
    private float increment;
    private PVector origin, destination;
    private color type; 
    private int amount;
    
    //constructor
          Edge(PVector _origin, PVector _destination, float _increment, int _amount, color _type){
              increment = _increment; 
              origin = _origin;
              destination = _destination;
              amount = _amount; 
              type = _type; 
              
          }
    
    //draw lines
    public void drawEdge(){
        stroke(type, 200);
        fill(type, 200);
        strokeWeight(amount);
        float x = origin.x; 
        float y = origin.y;
        float xspeed = abs(destination.x-origin.x)*increment;
        float yspeed = abs(destination.y-origin.y)*increment;
        
     //there are 4 cases of lines and need to cover purple 4 to preserve the orientation of going from origin to destination 
     //case 1: line moving down and right
      if(origin.x <= destination.x && origin.y <= destination.y){ //<>//
            if(x+(millis()-initialTime)*xspeed < destination.x && y+(millis()-initialTime)*yspeed < destination.y){
                  line(x,y,x+(millis()-initialTime)*xspeed, y + (millis()-initialTime)*yspeed); //<>//
                  duration = int(millis()-initialTime); 
               }
            else if(!needLoop){
                  line(origin.x, origin.y, destination.x, destination.y);
                      if(millis() > initialTime+duration + delay){
                          needLoop = !needLoop;
                          }
                 }   
      }
      
      //case 2: line moving up and right
      if(origin.x <= destination.x && origin.y >= destination.y){
            if(x+(millis()-initialTime)*xspeed < destination.x && y+(millis()-initialTime)*yspeed > destination.y){
                  line(x,y,x+(millis()-initialTime)*xspeed, y - (millis()-initialTime)*yspeed);
                  duration = int(millis()-initialTime);
                }
            else if(!needLoop){
                  line(origin.x, origin.y, destination.x, destination.y);
                      if(millis() > initialTime+duration + delay){
                          needLoop = !needLoop;
                          }
                  }
      }
      
      //case 3: line moving left and up
      if(origin.x >= destination.x && origin.y >= destination.y){
          if(x-(millis()-initialTime)*xspeed > destination.x && y+(millis()-initialTime)*yspeed > destination.y){
                line(x,y,x-(millis()-initialTime)*xspeed, y - (millis()-initialTime)*yspeed);
                duration = int(millis()-initialTime);
               }
          else if(!needLoop){
              line(origin.x, origin.y, destination.x, destination.y);
                  if(millis() > initialTime+duration + delay){
                      needLoop = !needLoop;
                  }
            }
      }
      
      //case 4: line moving left and down
      if(origin.x >= destination.x && origin.y <= destination.y){
          if(x-(millis()-initialTime)*xspeed > destination.x && y+(millis()-initialTime)*yspeed < destination.y){
                line(x,y,x-(millis()-initialTime)*xspeed, y + (millis()-initialTime)*yspeed);
                duration = int(millis()-initialTime);
                }
          else if(!needLoop){
              line(origin.x, origin.y, destination.x, destination.y);
                    if(millis() > initialTime+duration + delay){
                        needLoop = !needLoop;
                    }
              }
        }
        
      if(origin.x == destination.x && origin.y == destination.y){
         fill(type, 200);
         ellipse(origin.x, origin.y, amount, amount);
       }
      
  }

    
}