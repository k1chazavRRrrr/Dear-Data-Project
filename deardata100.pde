import java.util.*;
//Data Structures
ArrayList<String> uniqueDates = new ArrayList<String>();
// To Sort dates in order from (Oldest first to newest dates)
HashMap<String, ArrayList<Observation>> byDate = new HashMap<>();
// To Store all Observations according to Date - Observation
HashMap<String, Daystats> statistics = new HashMap<>();
// To store Statistics for a certain day, eg date - overall_mood


int selectIndex = 0; // Index to choose date
int total_days = 0;
int margin = 8;

color background = #F4F1ED;
color leftpanel = #E9ECEF;
color activebutton = #A5C8FF;
color sleepbutton = #C8DEE3;
color text_color = #2C2C2C;

float left_panel_x = 20;
float left_panel_y = 50;
float left_panel_w = 160;
float left_panel_h;

float graph_panel_x = left_panel_x + left_panel_w + 20;
float graph_panel_y = left_panel_y;
float graph_panel_w;
float graph_panel_h;

float day_button_x = left_panel_x + margin;
float day_button_y = left_panel_y + margin;
float day_button_w = 65;
float day_button_h;

void setup() {
  size(900, 800);
  fileUnpackage();
  left_panel_h = height - (left_panel_y * 2);
  graph_panel_w = width - graph_panel_x  - left_panel_x;
  graph_panel_h = left_panel_h;
}
void draw() {
  background(background);
  draw_gui();
  daySelect();
  noLoop();
}
void draw_gui() {
  int rowsPerCol = 15;
  noStroke();
  fill(leftpanel);
  rect(left_panel_x, left_panel_y, left_panel_w, left_panel_h, 10);
  rect(graph_panel_x, graph_panel_y, graph_panel_w, graph_panel_h, 10);
  day_button_h = (left_panel_h - (rowsPerCol+2)*margin) / rowsPerCol;
  for (int i = 0; i < total_days; i++) {
    int row = i % rowsPerCol;
    int col = i / rowsPerCol;
    float x  = day_button_x + margin + col * ( margin + day_button_w);
    float y = day_button_y + margin + row * ( margin + day_button_h);
    if (i == selectIndex ) {
      fill(activebutton);
    } else {
      fill(sleepbutton);
    }
    rect(x, y, day_button_w, day_button_h, 6);
    fill(text_color);
    textAlign(CENTER, CENTER);
    text("Day - " + (i+ 1), x + day_button_w/2, y + day_button_h/2);
  }
}
void daySelect() { // Output Info about Day's Observations
  String day = uniqueDates.get(selectIndex);
  ArrayList<Observation> daylist = byDate.get(day);
   //Make an Arraylist with observation according to choosen date for further use
  println("Day - " + day);
  for(Observation d : daylist){ // Going through ArrayList
    println(d.time + " " + d.emotion +  " "  + d.notes);
  }
}
void fileUnpackage() {
  String[] dear_data = loadStrings("data.csv"); // All lines with  ,

  for (int i = 1; i < dear_data.length; i++) { // Through Words lines[i] - word

    String[] tokens = split(dear_data[i], ",");
    //Dividing line for exact tokens also skipping wrong ones
    if (tokens.length < 6) continue;
    String date = tokens[0];
    String time = tokens[1];
    String emotion = tokens[2];
    String activity = tokens[3];
    int overall_mood = int(tokens[4]);
    String notes = tokens[5];
    //Create an Object - Observation with tokens parameters
    Observation obs = new Observation(date, time, emotion, activity, overall_mood, notes);
    //Making statement with Statistics Hashmap filling
    if (!statistics.containsKey(date)) {
      statistics.put(date, new Daystats(date));
    }

    statistics.get(date).addObservation(obs);

    //Making statement with day's Observations Hashmap filling
    if (!byDate.containsKey(date)) {
      byDate.put(date, new ArrayList<Observation>());
      uniqueDates.add(date);
    }
    byDate.get(date).add(obs);
  }
  //Debug about how many observation been parsed
  println("There are:  " + dear_data.length + " observations" );
  uniqueDates.sort(null); // Sort dates arraylist to make them old->new sort
  total_days = uniqueDates.size();
}
void keyPressed() {
  loop();
  int idx = selectIndex;
  if (key == CODED) {
    if (keyCode == UP) {
      idx++;
    } else if (keyCode == DOWN) {
      idx--;
    }
  }
  selectIndex = constrain(idx, 0, uniqueDates.size() - 1);
}
