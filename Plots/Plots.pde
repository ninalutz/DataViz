/////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Histogram and Bar Graph Class
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////
Histogram histogram;

//ArrayList<Float> data;  

void setupHistogram() {
  histogram = new Histogram(projCellSize*3, projCellSize*3.5);
}

class BarGraph {
  float maxXVal, xInc, maxYVal;
  float xPos, yPos, w, h;
  HashSet<Float> values;
  HashMap<Integer, Integer> bins;
  
  BarGraph() {
    bins = new HashMap<Integer, Integer>();
  }
  
  BarGraph(float maxXVal, float xInc) {
    this.maxXVal = maxXVal;
    this.xInc = xInc;
    bins = new HashMap<Integer, Integer>();
  }
  
  void setupData(ArrayList<Float> vals) {
    int maxfreq = 0;
    for (Float val : vals) {
      int binIndex = floor(val/xInc) - 1;
      if (bins.containsKey(binIndex) == false) {
        bins.put(binIndex, 1);
      } else {
        bins.put(binIndex, bins.get(binIndex) + 1);
      }
    }
    
    for (int i = 0; i < int(maxXVal/xInc); i++) {
      if (bins.containsKey(i) == false) {
        bins.put(i, 0);
      } else {
        if (bins.get(i) > maxfreq) {
          maxfreq = bins.get(i);
        }
      }
    }
    //println(bins);
    maxYVal = maxfreq;
  }
  
  void draw() {
    //println("DRAWING GRAPH");
    stroke(accent);
    float xPix = 15;

    strokeWeight(xPix - 1);
    for (Integer i : bins.keySet()) {
      float yVal = map(bins.get(i), 0, maxYVal, yPos, h - 50);
      //println("y: ", yVal, bins.size(), i);
      float xVal = xPos + xPix*(i+1);
      line(xVal, yPos, xVal, yVal);
    }
    strokeWeight(1);
    //println("GRAPH DRAWN");
  }
}

class Histogram {
  float w, h;
  float minX, maxX;
  int numBins; 
  float xinter;
  int[] count;
  int barWidth, barHeight, barOffset;
  ArrayList<Float> data;

  Histogram(float w, float h) {
    this.w = w;
    this.h = h;
    minX = 0.0;
    maxX = 1.0;
    numBins = 10;

    barOffset = 5;
    barWidth = int(w/numBins) - barOffset;

    count = new int[numBins];
    xinter = maxX/numBins;

    println("Initialized histo");

    populateHistogram();

    println("histo populated");

    for (float score : data) {
      int binIndex = floor(score/xinter) - 1;
      if (binIndex < 0) {
        binIndex = 0;
      }
      println(binIndex, count.length);
      count[binIndex] += 1;
    }

    barHeight = int(h/max(count));
  }

  void populateHistogram() {
    data = new ArrayList<Float>();

    if (showChem) {
      for (Person i: cur_model.Chemists) {
        data.add(i.synergy);
      }
    }

    if (showBio) {
      for (Person i: cur_model.Biologists) {
        data.add(i.synergy);
      }
    }
  }

  void draw(float x, float y) {
    int padding = 10;
    
    //axis
    fill(255);
    line(x, y, x, y-h-padding);
    line(x, y, x+w+padding, y);
    textSize(14);
    textAlign(CENTER, CENTER);
    text("Synergy", x + (w + padding)/2, y+padding);
    textAlign(LEFT, LEFT);

    //bars
    noStroke();
    fill(accent);
    for (int i = 0; i < count.length; i++) {
      rect(x + i*(barWidth + barOffset) + padding, y - barHeight*count[i], barWidth, barHeight*count[i]);
    }
  }

  void draw(float x, float y, PGraphics p) {
    int padding = 10;
    //axis
    p.fill(255);
    p.line(x, y, x, y-h-padding);
    p.line(x, y, x+w+padding, y);
    p.textSize(14);
    p.textAlign(CENTER, CENTER);
    p.text("Synergy", x + (w + padding)/2, y+padding);
    p.textAlign(LEFT, LEFT);

    //bars
    p.noStroke();
    p.fill(accent);
    for (int i = 0; i < count.length; i++) {
      p.rect(x + i*(barWidth + barOffset) + padding, y - barHeight*count[i], barWidth, barHeight*count[i]);
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Radar Plot stuff
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////
RadarPlot radar;
HashMap<String, Float> metricScores;

//Set up radar 
void setupRadar() {
  radar = new RadarPlot(metricScores.size());
  int i = 0;
  for (String id : metricScores.keySet()){
    radar.setName(i, id);
    radar.setScore(i, random(0, 1));
    i+=1;
  }
}

// A class to hold information related to a radar plot
class RadarPlot {
  int radarMode = 1; // 0=teal(static);  1 = average score fill; 2 = score cluster fill

  int nRadar; // Number of dimensions in Radar Plot
  ArrayList<Float> scores;
  ArrayList<String> names;
  float avgScore;

  RadarPlot(int num) {
    nRadar = num;
    scores = new ArrayList<Float>();
    names = new ArrayList<String>();
    avgScore = 0;

    for (int i = 0; i < nRadar; i++) {
      names.add("");
      scores.add(0.5);
    }
  }

  void setName (int index, String name) {
    if (index < nRadar) {
      names.set(index, name);
    }
  }

  void setScore(int index, float value) {
    if (index < nRadar) {
      scores.set(index, min(value, 1.0));
    }
  }

  void updateAvg() {
    avgScore = 0;
    for (int i = 0; i < nRadar; i++) {
      avgScore += scores.get(i);
    }
    avgScore /= nRadar;
  }

  float rot = 0.25*PI;

  void draw(int x, int y, int d) {
    strokeWeight(2);
    if (nRadar > 2) {
      //Draws radar plot
      for (int i = 0; i < nRadar; i++) {
        //Draws axes
        stroke(#999999);
        line(x, y, d*cos(rot+i*2*PI/nRadar) + x, d*sin(rot+i*2*PI/nRadar) + y);

        //Determine color
        color RG = color(0);

        //Does a nice red --> yellow --> green gradient instead of showing browns
        if ((scores.get(i)+scores.get((i+1)%nRadar))/2 <= 0.5) {
          RG = lerpColor(color(250, 0, 0),color(255, 255, 0), (scores.get(i)+scores.get((i+1)%nRadar))/2);
        } else {
          RG = lerpColor(color(255, 255, 0),color(0, 200, 0), (scores.get(i)+scores.get((i+1)%nRadar))/2);
        }

        fill(RG);

        //draw fills
        noStroke();
        triangle(x, y, scores.get(i)*d*cos(rot+i*2*PI/nRadar) + x,
        scores.get(i)*d*sin(rot+i*2*PI/nRadar) + y,
        scores.get((i+1)%nRadar)*d*cos(rot+(i+1)%nRadar*2*PI/nRadar) + x,
        scores.get((i+1)%nRadar)*d*sin(rot+(i+1)%nRadar*2*PI/nRadar) + y);

        //draw end dots
        ellipse(scores.get(i)*d*cos(rot+i*2*PI/nRadar) + x, scores.get(i)*d*sin(rot+i*2*PI/nRadar) + y, 5, 5);

        //scores
        textAlign(CENTER, CENTER);
        //recolor for the scores
        if (scores.get(i) <= 0.5) {
          RG = lerpColor(color(250, 0, 0),color(255, 255, 0), scores.get(i));
        } else {
          RG = lerpColor(color(255, 255, 0),color(0, 200, 0), scores.get(i));
        }

        fill(RG);
        if ((d+12)*sin(rot+i*2*PI/nRadar) + y < y) {
          text(int(100*scores.get(i)) + "%", (d+12)*cos(rot+i*2*PI/nRadar) + x, (d+12)*sin(rot+i*2*PI/nRadar) + y + 15);
        } else {
          text(int(100*scores.get(i)) + "%", (d+12)*cos(rot+i*2*PI/nRadar) + x, (d+12)*sin(rot+i*2*PI/nRadar) + y + 13 + 15);
        }

        //names
        fill(255);
        textAlign(CENTER);
        if ((d+12)*sin(rot+i*2*PI/nRadar) + y - 7 < y) {
          text(names.get(i), (d+12)*cos(rot+i*2*PI/nRadar) + x, (d+12)*sin(rot+i*2*PI/nRadar) + y - 7);
        } else {
          text(names.get(i), (d+12)*cos(rot+i*2*PI/nRadar) + x, (d+12)*sin(rot+i*2*PI/nRadar) + y + 5);
        }
      }

    }
  }

  void draw(float x, float y, float d, PGraphics p) {
    strokeWeight(2);
    if (nRadar > 2) {
      //Draws radar plot
      for (int i = 0; i < nRadar; i++) {
        //Draws axes
        p.stroke(#999999);
        p.line(x, y, d*cos(rot+i*2*PI/nRadar) + x, d*sin(rot+i*2*PI/nRadar) + y);

        //Determine color
        color RG = color(0);

        //Does a nice red --> yellow --> green gradient instead of showing browns
        if ((scores.get(i)+scores.get((i+1)%nRadar))/2 <= 0.5) {
          RG = lerpColor(color(250, 0, 0),color(255, 255, 0), (scores.get(i)+scores.get((i+1)%nRadar))/2);
        } else {
          RG = lerpColor(color(255, 255, 0),color(0, 200, 0), (scores.get(i)+scores.get((i+1)%nRadar))/2);
        }

        p.fill(RG);

        //draw fills
        noStroke();
        p.triangle(x, y, scores.get(i)*d*cos(rot+i*2*PI/nRadar) + x,
        scores.get(i)*d*sin(rot+i*2*PI/nRadar) + y,
        scores.get((i+1)%nRadar)*d*cos(rot+(i+1)%nRadar*2*PI/nRadar) + x,
        scores.get((i+1)%nRadar)*d*sin(rot+(i+1)%nRadar*2*PI/nRadar) + y);

        //draw end dots
        p.ellipse(scores.get(i)*d*cos(rot+i*2*PI/nRadar) + x, scores.get(i)*d*sin(rot+i*2*PI/nRadar) + y, 5, 5);

        //scores
        p.textAlign(CENTER, CENTER);
        //recolor for the scores
        if (scores.get(i) <= 0.5) {
          RG = lerpColor(color(250, 0, 0),color(255, 255, 0), scores.get(i));
        } else {
          RG = lerpColor(color(255, 255, 0),color(0, 200, 0), scores.get(i));
        }

        p.fill(RG);
        if ((d+12)*sin(rot+i*2*PI/nRadar) + y < y) {
          p.text(int(100*scores.get(i)) + "%", (d+12)*cos(rot+i*2*PI/nRadar) + x, (d+12)*sin(rot+i*2*PI/nRadar) + y);
        } else {
          p.text(int(100*scores.get(i)) + "%", (d+12)*cos(rot+i*2*PI/nRadar) + x, (d+12)*sin(rot+i*2*PI/nRadar) + y);
        }

        //names
        p.fill(255);
        p.textAlign(CENTER);
        if ((d+12)*sin(rot+i*2*PI/nRadar) + y - 7 < y) {
          p.text(names.get(i), (d+20)*cos(rot+i*2*PI/nRadar) + x, (d+20)*sin(rot+i*2*PI/nRadar) + y);
          println(names.get(i));
        } else {
          p.text(names.get(i), (d+25)*cos(rot+i*2*PI/nRadar) + x , (d+25)*sin(rot+i*2*PI/nRadar) + y + 18 + i);
          println(rot, names.get(i));
        }
        p.textAlign(LEFT);
      }
    }
  }
}
