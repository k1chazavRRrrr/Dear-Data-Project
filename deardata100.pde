import java.util.*;
//Data Structures
ArrayList<String> uniqueDates = new ArrayList<String>();
// To Sort dates in order from (Oldest first to newest dates)
HashMap<String, ArrayList<Observation>> byDate = new HashMap<>();
// To Store all Observations according to Date - Observation
HashMap<String, Daystats> statistics = new HashMap<>();
// To store Statistics for a certain day, eg date - overall_mood
ArrayList<DayButton> day_buttons = new ArrayList<>();
//To store Button object and work with them

int selectIndex = 0; // Index to choose date
int total_days = 0;
int margin = 8;

color bground = #F4F1ED;
color leftpanel = #E9ECEF;
color timeline = #D3D3D3;

float left_panel_x = 20;
float left_panel_y = 50;
float left_panel_w = 160;
float left_panel_h;

float graph_panel_x = left_panel_x + left_panel_w + 20;
float graph_panel_y = left_panel_y;
float graph_panel_w;
float graph_panel_h;

float timeline_panel_x = graph_panel_x + 50;
float timeline_panel_y;
float timeline_panel_w;
float timeline_panel_h = 10;


float day_button_x = left_panel_x + margin;
float day_button_y = left_panel_y + margin;
float day_button_w = 65;
float day_button_h;

void setup() {

  size(800, 700);
  fileUnpackage();
  left_panel_h = height - (left_panel_y * 2);

  graph_panel_w = width - graph_panel_x  - left_panel_x;
  graph_panel_h = left_panel_h;

  timeline_panel_y = graph_panel_y + graph_panel_h - 50;
  timeline_panel_w = graph_panel_w - 100;

  createDayButtons();
}
void draw() {

  background(bground);
  draw_gui();
  daySelect();
  draw_graph();
}

void createDayButtons() {

  int rowsPerCol = 15;
  day_button_h = (left_panel_h - (rowsPerCol+2)*margin) / rowsPerCol;
  for (int i = 0; i < total_days; i++) {
    int row = i % rowsPerCol;
    int col = i / rowsPerCol;
    float x  = day_button_x + margin + col * ( margin + day_button_w);
    float y = day_button_y + margin + row * ( margin + day_button_h);
    day_buttons.add(new DayButton(x, y, day_button_w, day_button_h, i));
  }
}
void draw_gui() {
  noStroke();
  fill(leftpanel);

  rect(left_panel_x, left_panel_y, left_panel_w, left_panel_h, 10);
  rect(graph_panel_x, graph_panel_y, graph_panel_w, graph_panel_h, 10);
  fill(timeline);
  rect(timeline_panel_x, timeline_panel_y, timeline_panel_w, timeline_panel_h, 4);
  float trianglex = timeline_panel_x + timeline_panel_w;
  float triangley = timeline_panel_y + timeline_panel_h / 2;
  float s = 8;
  triangle(trianglex - s, triangley -s, trianglex - s, triangley + s, trianglex + s, triangley);
  for ( DayButton d : day_buttons) {
    d.update();
    d.display();
  }
}
void draw_graph() {
  stroke(120);
  HashSet<Integer> set = new HashSet<Integer>(Arrays.asList(0, 6, 12, 18, 24));
  for (int i = 0; i <= 24; i+=6) {
    float tx = timeline_panel_x + (i /25.0) * timeline_panel_w;
    line(tx, timeline_panel_y-5, tx, timeline_panel_y+timeline_panel_h + 5);
    textAlign(CENTER, BOTTOM);
    text(i, tx, timeline_panel_y - 6);
  }
  String day = uniqueDates.get(selectIndex);
  ArrayList<Observation> daylist = byDate.get(day);
  ArrayList<Integer> timebubbles = new ArrayList<>();
  for (Observation d : daylist) {
    int hour = Integer.parseInt(d.time);
    timebubbles.add(hour);
  }
  noStroke();
  float actions_bubbles_y = timeline_panel_y + timeline_panel_h/2;
  for (int i = 0; i < daylist.size(); i++) {
    //println(timebubbles.get(i));
    float x = timeline_panel_x + (timebubbles.get(i) / 25.0) * timeline_panel_w;
    fill(daylist.get(i).activitycolor);
    circle(x, actions_bubbles_y, 15);
    if (!set.contains(timebubbles.get(i))) text(daylist.get(i).time, x, actions_bubbles_y-15);
    text(daylist.get(i).activity, x, actions_bubbles_y+20);
  }
  //for(Observation d : daylist){
  // String[] time_tokens = split(d.time, ":");
  // timelist.add(time_tokens[0]);
  //}
  //println(day);
}
void daySelect() { // Output Info about Day's Observations
  String day = uniqueDates.get(selectIndex);
  ArrayList<Observation> daylist = byDate.get(day);
  //Make an Arraylist with observation according to choosen date for further use
  //println("Day - " + day);
  //for (Observation d : daylist) { // Going through ArrayList
  //  println(d.time + " " + d.emotion +  " "  + d.notes);
  //}
}
void fileUnpackage() {
  int MINIMUM_TOKENS = 6; // at least 6 entries in table
  String[] dear_data = loadStrings("data.csv"); // All lines with  ,

  for (int i = 1; i < dear_data.length; i++) { // Through Words lines[i] - word

    String[] tokens = split(dear_data[i], ",");
    //Dividing line for exact tokens also skipping wrong ones
    if (tokens.length < MINIMUM_TOKENS) continue;
    String date = tokens[0];
    String time[] = split(tokens[1], ":");
    String hour = time[0];
    String emotion = tokens[2];
    String activity = tokens[3];
    int overall_mood = int(tokens[4]);
    String notes = tokens[5];
    //Create an Object - Observation with tokens parameters
    Observation obs = new Observation(date, hour, emotion, activity, overall_mood, notes);
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
  int idx = selectIndex;
  if (key == CODED) {
    if (keyCode == DOWN) {
      idx++;
    } else if (keyCode == UP) {
      idx--;
    }
  }
  selectIndex = constrain(idx, 0, uniqueDates.size() - 1);
}
void mousePressed() {
  for ( DayButton d : day_buttons) {
    if (d.isHovered) selectIndex = d.idx;
  }
}
