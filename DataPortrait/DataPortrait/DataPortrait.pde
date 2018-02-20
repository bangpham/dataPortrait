Photo photon;
JSONObject data;
ArrayList<String> keys;
ArrayList<PImage> temp = new ArrayList<PImage>();
ArrayList<PImage> allImages = new ArrayList<PImage>();
ArrayList<PImage> mon = new ArrayList<PImage>();
ArrayList<PImage> tue = new ArrayList<PImage>();
ArrayList<PImage> wed = new ArrayList<PImage>();
ArrayList<PImage> thu = new ArrayList<PImage>();
ArrayList<PImage> fri = new ArrayList<PImage>();
ArrayList<PImage> sat = new ArrayList<PImage>();
ArrayList<PImage> sun = new ArrayList<PImage>();
color col;
String date = "2016";


int index;
float pos = .8;

void setup() {
  size(600, 600);
  photon = new Photo();
  data = loadJSONObject("output.json"); // JSON file from Flickr API
  keys = new ArrayList(data.keys()); 
  col = color(255,255,255);
  frameRate(15);
  
  
  for (int i = 0; i < keys.size(); i++) { 
    if (data.getJSONObject(keys.get(i)).getJSONArray("time").getInt(2) == 26) {
      mon.add(loadImage(keys.get(i) + ".jpg"));
    } else if (data.getJSONObject(keys.get(i)).getJSONArray("time").getInt(2) == 27) {
      tue.add(loadImage(keys.get(i) + ".jpg"));
    } else if (data.getJSONObject(keys.get(i)).getJSONArray("time").getInt(2) == 28) {
      wed.add(loadImage(keys.get(i) + ".jpg"));
    } else if (data.getJSONObject(keys.get(i)).getJSONArray("time").getInt(2) == 29) {
      thu.add(loadImage(keys.get(i) + ".jpg"));
    } else if (data.getJSONObject(keys.get(i)).getJSONArray("time").getInt(2) == 30) {
      fri.add(loadImage(keys.get(i) + ".jpg"));
    } else if (data.getJSONObject(keys.get(i)).getJSONArray("time").getInt(2) == 1) {
      sat.add(loadImage(keys.get(i) + ".jpg"));
    } else if (data.getJSONObject(keys.get(i)).getJSONArray("time").getInt(2) == 2) {
      sun.add(loadImage(keys.get(i) + ".jpg"));
    }
    allImages.add(loadImage(keys.get(i) + ".jpg"));
  }
  
  temp = allImages;

}

void draw() {
  background(0);
  photon.createWindow();
  photon.updateGroup();
  photon.drawGroup();
  
 JSONObject photoEntry = data.getJSONObject(keys.get(index)); // Get the JSON Object from the json file
 JSONArray tagArray = photoEntry.getJSONArray("tags"); // Get the tags array from the JSON object
 String[] allTags = tagArray.getStringArray(); // Turn the JSON array into an array of Strings

 if(index > 3459) {
   index = 0;
 }
 if(allTags.length != 0){ // Display the first tag (if existent)
   pushStyle();
   rectMode(CENTER);
   textAlign(CENTER);
   fill(0);
   fill(255);
   text(allTags[0],width/2,height/2);
   text(date,width/2,height/2 + 15);
   popStyle();
 }
 index++;
 if (keyPressed) {
    if (key == 'z' || key == 'Z' ) {
      pos = pos -.1;
    } else if (key == 'x' || key == 'X' ) {
      pos = pos + .1;
    }
  }
  
  if (keyPressed) {
    if (key == '1') {
      temp = sun;
      col = color(255,6,130);
      date = "Sunday";
    } else if (key == '2') {
      temp = mon;
      col = color(0,111,255);
      date = "Monday";
    } else if (key == '3') {
      temp = tue;
      col = color(25,255,0);
      date = "Tuesday";
    } else if (key == '4') {
      temp = wed;
      date = "Wednesday";
      col = color(255,181,6);
    } else if (key == '5') {
      temp = thu;
      col = color(255,255,0);
      date = "Thursday";
    } else if (key == '6') {
      temp = fri;
      col = color(171,0,255);
      date = "Friday";
    } else if (key == '7') {
      temp = sat;
      col = color(0,230,255);
      date = "Saturday";
    } else if (key == '8') {
      temp = sun;
      col = color(10,193,151);
      date = "Sunday";
    } else if (key == '9') {
      temp = allImages;
      col = color(255,255,255);
      date = "2016";
    }
  }

    
}

//===OBJECT====
class Photo {
  float angle;
  float velocity;
  float x, y;
  float waylong; 
  float alpha;
  color _col;
  int ind;
  ArrayList<PImage> array = temp;
  PImage img;
  Photo[] group = {};
  
//Modified photo class from Photon tutorial to createWindow flying animation.
  Photo() {
    angle = random(2*PI);
    velocity = random(4, 5);
    x = width/2;
    y = height/2;
    waylong = 0;
    alpha = 0;
    ind = 0;
    _col = col;
  }

  void updateWindow() {
    x += velocity*cos(angle);
    y += velocity*sin(angle);   
    waylong += 0.2*velocity;
    alpha = waylong*dist(0,0,width,height)/(255*sqrt(2));
    
      if (ind >= array.size()) { // Reset loop
        ind = 0;
      }
    img = array.get(ind);
    ind++;
  }

  void drawWindow() {
    fill(_col, alpha);
    noStroke();
    if (0 < x+waylong/2 || x - waylong < width) { 
      if (0 < y+waylong/2 || y - waylong < height) {
        rect(x, y, waylong, waylong);
        textSize(8);
        textAlign(CENTER, CENTER);
        text(date, x, y, waylong, waylong);
        image(img, x/pos, y/pos, waylong, waylong);
        
      }
    }
  }

  void createWindow() {
    Photo newphoton = new Photo();
    group = (Photo[])append(group, newphoton);
  }

  void updateGroup() {
    for (int i =0; i < group.length; i++) {
      group[i].updateWindow();
    }
  }

  void drawGroup() {
    for (int i =0; i < group.length; i++) {
      group[i].drawWindow();
    }
  }
}