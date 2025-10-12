import java.util.*;
//Needed Data Structures
ArrayList<Observation> observations_list = new ArrayList<Observation>();
StringList dates = new StringList();
//Needed Variables
color background = #F0E2A3; // Background

color plarfom = #7D7C7A; //Grey Platfrom
float p_x = 50;
float p_y = 50;
float p_w;
float p_h;
float p_r = 20;

color d_platform = #FFFFFF; //White Platfrom
float d_x = 70;
float d_y = 70;
float d_w = 125;
float d_h;
float d_r = 20;

int currentDaySelect; //Day selection Index
void setup() {
  size(900, 800);
  fileUnpackage();
  buildDates();
  p_w = width-(p_x*2);
  p_h = height-(p_y*2);

  d_h = height -(d_y* 2);
}
void draw() {
  background(background);
  // Grey Platfrom
  noStroke();
  fill(plarfom, 120);
  rect(p_x, p_y, p_w, p_h, p_r);
  //White Platform for days selector
  fill(d_platform, 120);
  rect(d_x, d_y, d_w, d_h, d_r);
  //Generate Days
  drawDaySelector();
}

//Method to Work with csv file
// 1. Unpack  with LoadStrings whole csv.
// 2. Define all Strings to corresponding tokens e.g token[0] = date.
// 3. Create an Object obs with tokens parameters.
// 4. Add all Objects-Observations to the list.


void fileUnpackage() {
  String[] dear_data = loadStrings("dd100.csv");

  for (int i = 1; i < dear_data.length; i++) { //Skip Headings
    String[] tokens = split(dear_data[i], ";");
    if (tokens.length < 6) {
      println("Error");
      continue;
    }
    String date = tokens[0];
    String time = tokens[1];
    String emotion = tokens[2];
    String activity = tokens[3];
    int overall_mood = int(tokens[4]);
    String notes = tokens[5];

    //Creating object of observations.
    Observation obs = new Observation(date, time, emotion, activity, overall_mood, notes);
    observations_list.add(obs);
    //Debug
    //  println(obs.toString());
  }
}

void buildDates() { //Using StringList as it is easier to sort dates
  for (Observation c : observations_list) {
    if (!dates.hasValue(c.date)) {
      dates.append(c.date);
    }
  }

  dates.sort();
}

void drawDaySelector() {
  color buttonColour = #C1CAD6;
  int total_days = max(1, dates.size());
  float button_h = d_h / total_days;
  float button_w = d_w - 20;

  for (int i = 0; i < total_days; i++) {
    float buttonY = d_y + (i * button_h); // To create all Buttons with different Y
    //Colour of button
    if (i == currentDaySelect){
      fill(0,150);
    }
    else{
      fill(buttonColour);
    }
    noStroke();
    
    rect(d_x + 10, buttonY + 5, button_w, button_h - 10, 10);
  }
}
  void keyPressed() {
    int idx = currentDaySelect;
    idx = constrain(idx,1,dates.size() - 1);
    if(key == CODED){
    if ( keyCode  == DOWN) {
      idx++;
    } else if ( keyCode == UP) {
      idx--;
    }
    }
    currentDaySelect = idx;
    println(currentDaySelect);
}
  
//Debug
//println("Total observations: " + observations_list.size());
//println("Unique dates: " + byDate.size());
