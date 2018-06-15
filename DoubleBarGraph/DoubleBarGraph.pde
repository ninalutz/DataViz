float [] array1 = {3, 5, 7, 9, 11, 13};
float [] array2 = {2, 4, 6, 8, 12, 16};
color pop1 = color(200, 0, 20);
color pop2 = color(20, 0, 200);

DoubleBar graph;

void setup(){
    size(displayWidth, displayHeight);
    graph = new DoubleBar();
    graph.w = 500;
    graph.h = 200;
    graph.x = 100;
    graph.y = 800;
    graph.adddatasets(array1);
    graph.adddatasets(array2);
    graph.configureBars();
}

void draw(){
    background(255);
    graph.draw();
    noLoop();
}

class DoubleBar{
    ArrayList<float[]> datasets; 
    int numPop, numCols;
    float w, h, barWidth;
    int barPadding = 5;
    int colPadding = 20;
    float x, y;
    float maxBarHeight, maxVal;
    boolean drawAxis = true;
    boolean yAxis = true;
    color axisColor = color(0, 255, 0);
    String yTitle = "Test test";
    DoubleBar(){
        datasets = new ArrayList<float[]>();
    }
    
    void adddatasets(float[] array){
        datasets.add(array);
    }
    
    void configureBars(){
        numPop = datasets.size();
        numCols = datasets.get(0).length;
        barWidth = (w/(numCols*numPop)) - colPadding/numPop;
        maxVal = 0;
        for(int i = 0; i<datasets.size(); i++){
            for(int j = 0; j<datasets.get(0).length; j++){
                if(datasets.get(i)[j] > maxVal){
                  maxVal = datasets.get(i)[j];
                }
            }
        }
    }
    
    void draw(){
        float xOffset = -barWidth + barPadding;
    
        for(int j =0; j<numCols; j++){
            fill(pop1);
            xOffset += barWidth;
            float barHeight = y - map(datasets.get(0)[j], 0, maxVal, y, y-h);
            rect(x + xOffset, y - barHeight, barWidth, barHeight);
            text(datasets.get(0)[j], x + xOffset, 40);
            
            fill(pop2);
            barHeight = y - map(datasets.get(1)[j], 0, maxVal, y, y-h);
            xOffset += barWidth + barPadding;
            rect(x + xOffset, y - barHeight, barWidth, barHeight);
            text(datasets.get(1)[j], x + xOffset, 40);
            xOffset += colPadding;
            
        }
        
        if(drawAxis){
            stroke(axisColor);
            strokeWeight(2);
            
            line(x, y, x, y - h);
            line(x, y, w + barWidth, y);
        }
        
        if(yAxis){
          fill(0);
          pushMatrix();
          translate(x - barPadding, y - h/2);
          rotate(-HALF_PI);
          textAlign(CENTER);
          text(yTitle,0,0);
          popMatrix(); 
        }
    }

}
