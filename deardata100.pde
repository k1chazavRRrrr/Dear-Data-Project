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
HashMap<String, ArrayList<Point>> graph_points = new HashMap<>();


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
  left_panel_h = height - (left_panel_y * 2);

  graph_panel_w = width - graph_panel_x  - left_panel_x;
  graph_panel_h = left_panel_h;

  timeline_panel_y = graph_panel_y + graph_panel_h - 50;
  timeline_panel_w = graph_panel_w - 100;
  fileUnpackage();
  createDayButtons();
}
void draw() {

  background(bground);
  draw_gui();
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
  pushStyle();
  strokeWeight(2);
  stroke(120);
  
  HashSet<Integer> majorHours = new HashSet<Integer>(Arrays.asList(0, 6, 12, 18, 24));
  for (int i = 0; i <= 24; i+=6) {
    float tx = timeline_panel_x + (i /25.0) * timeline_panel_w;
    line(tx, timeline_panel_y-5, tx, timeline_panel_y+timeline_panel_h + 5);
    textAlign(CENTER, BOTTOM);
    text(i, tx, timeline_panel_y - 6);
  }
  popStyle();
  ArrayList<Point> current_points = graph_points.get(uniqueDates.get(selectIndex));
  
  pushStyle();
  stroke(120);
  strokeWeight(6);
  for (int i = 1; i < current_points.size(); i++) {
    line(current_points.get(i -1).x, current_points.get(i -1).y, current_points.get(i).x, current_points.get(i).y);
  }
  popStyle();
  pushStyle();
  noStroke();
  textAlign(CENTER, CENTER);
  for (Point d : current_points) {

    circle(d.x, timeline_panel_y + timeline_panel_h/2, 16);
    if (!majorHours.contains(d.hour)) text(d.hour, d.x,timeline_panel_y + timeline_panel_h/2 - 14);
    circle(d.x, d.y, 15);
  }
  popStyle();
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

    if (!graph_points.containsKey(date)) {
      graph_points.put(date, new ArrayList<Point>());
    }
    graph_points.get(date).add(new Point(Integer.parseInt(hour), activity, emotion, overall_mood));
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
