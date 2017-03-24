var numcountries   = 217;
var countries;
var rightcountries;

var curcountry;
var gui;
var region_colors = [];

var compamount;
var name;
var names = [];

var table;

var curyear = 0;
var years = [1990, 2000, 2007, 2008, 2009, 2010, 2011, 2012, 2013];
var yearlyco2 = [16012901.26, 23584902.89, 29276168.9, 29956115.04, 29628332.91, 31599583.76, 32844592.6, 33492404.15, 33587797.5];

function preload(){
  table = loadTable("data/CO2.csv","csv", "header");
}

function setup() {
  createCanvas(displayWidth-100, displayHeight-200);
  ellipseMode(RADIUS);
  
  overC = false;
  locked = false;
 
 countries = [];
 rightcountries = [];
 
 numcountries = 217;

 
 curcountry = new country("", 0, createVector(-200, -200), 0);
 makecountries();
 
 
  region_colors[0] = color(0, 64, 255, 50) //blue
  region_colors[1] = color(255, 255, 0, 50) //yellow
  region_colors[2] = color(191, 0, 255, 50) //purple
  region_colors[3] = color(255, 0, 191, 50) //pink
  region_colors[4] = color(135, 206, 235, 50) //i dont remember what color this is lol
  region_colors[5] = color(255, 128, 0, 50) //orange
  region_colors[6] = color(255, 64, 0, 50) //red
  region_colors[7] = color(0, 255, 64, 50) //light green
  region_colors[8] = color(0, 255, 255, 50) //light blue
  region_colors[9] = color(153, 102, 51, 50) //brown
 
}

function draw() {
  background(255);
 // print(rightcountries.length);

  for(var i = 0; i<countries.length; i++){
   countries[i].mouseupdate();
     countries[i].display();
  }
  
  fill(0);
  noStroke();
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Drag country here for comparisons ", width/4, height/2 + 20);  
  text("Drag other countries here for comparisons", 3*width/4, height/2 + 20);
  text("Year: " + years[curyear], width/2, 20);
  
  stroke(0);
  strokeWeight(2);
  line(width/2, height/2 + 20, width/2, height - 100);
  
  
  noStroke();
  fill(0);
  text("Percentage of world: "  + int(curcountry.amount/yearlyco2[curyear] * 100) + "%", width/4, height-90);
    text("Percentage of world: " + int(compamount/yearlyco2[curyear] * 100)+ "%", 3*width/4, height-90);
    noFill();

compamount = 0;
 for(var i = 0; i<rightcountries.length; i++){
   compamount += rightcountries[i].amount;
 }
 
 fill(255, 0, 0, 50);
 ellipse(curcountry.x, curcountry.y, (int(compamount/yearlyco2[curyear] * 100)/int(curcountry.amount/yearlyco2[curyear] * 100)) * 100, (int(compamount/yearlyco2[curyear] * 100)/int(curcountry.amount/yearlyco2[curyear] * 100))*100)
 
}




var country = function(name, size, location, amount, region){
  this.name = name;
  this.x = location.x;
  this.y = location.y;
  this.size = size;
  this.locked = false;
  this.overC = false;
  this.region = region;
  this.amount = amount;
  this.curcolor = region_colors[this.region];
}

country.prototype.mouseupdate = function(){
  if (mouseX > this.x-this.size && mouseX < this.x+this.size && 
      mouseY > this.y-this.size && mouseY < this.y+this.size) {
    this.overC = true;  
    if(!this.locked) { 
      stroke(255, 0, 0); 
      this.curcolor = color(153, 50);
    } 

  } else {
    stroke(153);
    if(this != curcountry){
    fill(this.curcolor, 0, 0, 50);
    }
    else{
      fill(255);
    }
   this.curcolor = region_colors[this.region];
  this.overC = false;
  }
  
  
}

  function mousePressed(){
    for(var i = 0; i<countries.length; i++){
        if(countries[i].overC){
          countries[i].locked = !countries[i].locked;
        }
      
    }
}


function mouseDragged(){
    for(var i = 0; i<countries.length; i++){
        if(countries[i].locked){
          countries[i].x = mouseX;
          countries[i].y = mouseY;
        }
      
    }
}

function mouseReleased(){
      for(var i = 0; i<countries.length; i++){
          countries[i].locked = false;
    }
}

country.prototype.display = function(){
if(this.y > height/2 && this.x < width/2){
  ellipse(this.x, this.y, 100, 100);
  curcountry = this;
    if (rightcountries.indexOf(this) > -1) {
    rightcountries.splice(index, 1);
  }
}

else if(this.y > height/2 && this.x > width/2){
  if(rightcountries.indexOf(this) < 0){
  rightcountries.push(this);
  }
  fill(this.curcolor);
  ellipse(this.x, this.y, this.size, this.size);
}

else{
  fill(this.curcolor);
  ellipse(this.x, this.y, this.size, this.size);
  var index = rightcountries.indexOf(this);
  if (index > -1) {
    rightcountries.splice(index, 1);
  }
}
  noStroke();
  fill(0);
  text(this.name, this.x, this.y);
  stroke(255, 0, 0);
  fill(this.curcolor);
  
}


function keyPressed(){
  if(key == '1'){
    curyear = 0;
    countries = [];
    makecountries();
  }
  if(key == '2'){
    curyear = 1;
    countries = [];
    makecountries();
  }
  if(key == '3'){
    curyear = 2;
    countries = [];
    makecountries();
  }
    if(key == '4'){
    curyear = 3;
    countries = [];
    makecountries();
  }
    if(key == '5'){
    curyear = 4;
    countries = [];
    makecountries();
  }
    if(key == '6'){
    curyear = 5;
    countries = [];
    makecountries();
  }
    if(key == '7'){
    curyear = 6;
    countries = [];
    makecountries();
  }
    if(key == '8'){
    curyear = 7;
    countries = [];
    makecountries();
  }
    if(key == '9'){
    curyear = 8;
    countries = [];
    makecountries();
  }
  
}

function makecountries(){
  for(var i = 0; i<numcountries; i++){
    var cO2 = [];
    cO2.push(float(table.getString(i, "Code")));
    names[i] = table.getString(i, "Code");
    var region = int(table.get(i, "Region"));
    var x = 0;
    var y = random(50, height/2);
    


 //   else{
      x = random((region)*width/9, (region+1)*width/9);
    // }
    
    //North and South America
    if(region == 6){
      x = random(20, width/9);
      y = random(50, height/4);
    }
    if(region == 8){
            x = random(20, width/9);
          y = random(height/4, height/2);
    }
    
    //Europe
    if(region == 0){
      x = random(width/9 + 100, width/2);
      y = random(50, height/4);
    }
    //middle east
    if(region == 4){
      x = random(width/9 + 100, width/4);
      y = random(height/4, height/2);
    }
    //africa
    if(region == 5){
      x = random(width/4 + 40, 2*width/3);
      y = random(height/4, height/2);
    }
    
    //Eurasia
    if(region == 1){
      x = random (width/2 + 20, 2*width/3);
    //  x = width/2;
      y = random(50, height/4);
    }
    
    //Asia
    if(region == 2){
      x = random(2*width/3 + 30, width-50);
      y = random(50, height/4)
    }
    //Oceana
    if(region == 3){
      x = random(2*width/3, width-300);
      y = random(height/4, height/2)
    }
    
    if(region == 9){
      x   = random(width/9, width/9+100);
      y = random(50, height/2);
    }
    if(region == 7){
      x = random(width-300, width - 50);
      y = random(height/4, height/2)
      
    }
    print(curyear.toString());
     var thing = float(table.getString(i, years[curyear].toString()))/yearlyco2[curyear] > .005;
    // print(float(table.getString(i, "1991"))/yearlyco2[curyear]);
    
    if(thing && names[i] != "USA"){
    countries.push(new country(names[i], float(table.getString(i, years[curyear].toString()))/yearlyco2[curyear]*700, createVector(x, y), float(table.getString(i, years[curyear].toString())), region));
    }
    if(names[i] == "USA"){
    countries.push(new country(names[i], float(table.getString(i, years[curyear].toString()))/yearlyco2[curyear]*700, createVector(width/4, 3*height/4 - 40), float(table.getString(i, years[curyear].toString())), region));

    }
 }
  
}