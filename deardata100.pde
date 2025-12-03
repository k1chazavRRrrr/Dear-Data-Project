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
boolean isLegendOn = false;
boolean isStatsOn = false;

boolean isAnimating = false;
float animationA = 1;
float animationB = animationA;
float animationC = animationB - 0.1 * animationA;

Point selectedPoint = null;

color bground = #F4F1ED;
color leftpanel = #E9ECEF;
color timeline = #D3D3D3;
color pointInfo = #C8CACC;

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


float day_button_x = left_panel_x + (margin/2);
float day_button_y = left_panel_y + margin;
float day_button_w = 65;
float day_button_h;

float legend_button_x;
float legend_button_y;
float legend_button_w;
float legend_button_h;

float summary_button_x ;
float summary_button_y ;
float summary_button_w ;
float summary_button_h;
void setup() {

  size(900, 700); // Resolution CAN be changed to more convenient
  surface.setTitle("Dear Data – 100 Observations");
  left_panel_h = height - (left_panel_y * 2);

  graph_panel_w = width - graph_panel_x  - left_panel_x;
  graph_panel_h = left_panel_h;

  timeline_panel_y = graph_panel_y + graph_panel_h - 125;
  timeline_panel_w = graph_panel_w - 100;

  legend_button_x = graph_panel_x + graph_panel_w - 200;
  legend_button_y = timeline_panel_y + timeline_panel_h + 30;
  legend_button_h = graph_panel_y + graph_panel_h - (timeline_panel_y + timeline_panel_h) - 60 ;

  summary_button_x = timeline_panel_x + 10;
  summary_button_y = legend_button_y;
  summary_button_w = timeline_panel_w / 5;
  summary_button_h = graph_panel_y + graph_panel_h - (timeline_panel_y + timeline_panel_h) - 60 ;

  fileUnpackage();
  createDayButtons();
  changeDayAnimation();
}
void draw() {
  pushStyle();
  background(bground);


  draw_gui();
  draw_graph();
  legendButton();
  summaryButton();
  if (isAnimating) {
    pushStyle();
    noStroke();
    fill(timeline);
    rect(graph_panel_x, graph_panel_y, graph_panel_w * animationA, graph_panel_h, 10);
    fill(#A9A9A9, 40);
    rect(graph_panel_x, graph_panel_y, (graph_panel_w - graph_panel_w * 0.05) * animationB, graph_panel_h, 10);

    popStyle();
    animationA -= 0.01;
    animationB-= 0.01;
    if (animationB <= 0) {
      animationB = 0;
    }
    if (animationA <= 0) {
      animationA = 0;
      fill(bground);
      isAnimating = false;
    }
  }
  popStyle();
}

void createDayButtons() {
  pushStyle();
  int rowsPerCol = 10;
  day_button_h = (left_panel_h - (rowsPerCol+2)*margin) / rowsPerCol;
  for (int i = 0; i < total_days; i++) {
    int row = i % rowsPerCol;
    int col = i / rowsPerCol;
    float x  = day_button_x + margin + col * ( margin + day_button_w);
    float y = day_button_y + margin + row * ( margin + day_button_h);
    day_buttons.add(new DayButton(x, y, day_button_w, day_button_h, i));
  }
  popStyle();
}
void draw_gui() {
  pushStyle();
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
  popStyle();

  pushStyle();
  stroke(150);
  strokeWeight(2);
  float moodline_x = timeline_panel_x - 20;
  float yBot = timeline_panel_y - 20;
  float yTop = graph_panel_y + 20;
  line(moodline_x, yBot, moodline_x, yTop);
  popStyle();
  pushStyle();

  for (int i = 1; i <= 10; i++) {
    float moodline_tick_y = graph_points.get(uniqueDates.get(0)).get(0).moodToY(i);
    float moodline_tick_x = moodline_x - 5;
    line(moodline_tick_x, moodline_tick_y, moodline_tick_x + 10, moodline_tick_y);
    fill(0);
    textAlign(LEFT, CENTER);

    if (selectedPoint != null && selectedPoint.y == moodline_tick_y) {
      fill(255, 0, 0);
      textSize(16);
      text(i, moodline_tick_x - 10, moodline_tick_y);
    } else {
      fill(0);
      textSize(12);

      text(i, moodline_tick_x - 10, moodline_tick_y);
    }
  }
  popStyle();


  pushStyle();
  noStroke();
  for ( DayButton d : day_buttons) {
    d.update();
    d.display();
  }
  popStyle();
}

void legendButton() {
  legend_button_w = timeline_panel_w / 5;
  pushStyle();
  noStroke();
  textAlign(CENTER, CENTER);
  fill(timeline);
  if (isLegendHovered()) fill(255);
  rect(legend_button_x, legend_button_y, legend_button_w, legend_button_h, 5);
  fill(0);
  textSize(14);
  text("How to read?", legend_button_x + legend_button_w / 2, legend_button_y + legend_button_h/2);
  textAlign(CENTER, TOP);
  textSize(10);
  text("Space(on/off)", legend_button_x + legend_button_w/2, legend_button_y + legend_button_h + margin/2);
  popStyle();
  if (isLegendOn) {
    legendInfo();
  }
}
void summaryButton() {

  pushStyle();
  noStroke();
  textAlign(CENTER, CENTER);
  if (isStatsHovered())fill(255);
  else fill(timeline);
  rect(summary_button_x, summary_button_y, summary_button_w, summary_button_h, 5);
  pushStyle();
  fill(0);
  textSize(14);
  text("Statistics", summary_button_x + summary_button_w/2, summary_button_y + summary_button_h/2);
  popStyle();
  popStyle();
  if (isStatsOn) {
    summaryWindow();
    showStats();
  }
}
void summaryWindow() {
  int padding = 10;
  float summary_panel_x = graph_panel_x + padding;
  float summary_panel_y = graph_panel_y + padding;
  float summary_panel_h = graph_panel_h / 4;
  float summary_panel_w =   graph_panel_w - (padding*2);
  pushStyle();
  noStroke();
  fill(160, 120);
  rect(summary_panel_x, summary_panel_y, summary_panel_w, summary_panel_h, 5);
    
  popStyle();
}
void legendInfo() {

  float legend_panel_x = graph_panel_x + 10;
  float legend_panel_y = graph_panel_y + 10;
  float legend_panel_w = graph_panel_w - (10*2);
  float legend_panel_h = graph_panel_h / 4;

  float pad = 10;
  float innerX = legend_panel_x + pad;
  float innerY = legend_panel_y + pad;
  float innerW = legend_panel_w - pad*2;
  float innerH = legend_panel_h - pad*2;

  float emotion_section_x = innerX + pad;
  float emotion_section_y = innerY  + pad;
  float emotion_section_w = innerW * 0.4 - pad*2;
  float emotion_section_h = innerH - pad*2;

  String[] emotions = {"Tired", "Anxious", "Unproductive", "Productive",
    "Motivated", "Chill", "Happy", "Nostalgic"};

  color [] emotion_colors = {#8E9A9D, #C44949, #9B8F6E, #7DA657,
    #F4C542, #6DBFB8, #820263, #B49BC8};

  float activity_section_x = emotion_section_w + emotion_section_x;
  float activity_section_y = innerY + pad ;
  float activity_section_w = innerW * 0.36- pad*2;
  float activity_section_h = innerH - pad*2 ;

  String[][] life_activities = {{"mrn", "Morning"}, {"sh", "Shopping"}, {"evn", "Evening"}, {"go", "Going Out"}, {"ga", "Gaming"}, {"g", "Gym"}};
  String[][] study_activities = {{"le", "Lecture"}, {"lt", "Lab/Tutorial"}, {"st", "Study Time"}};

  float graph_instruction_section_x = activity_section_x + activity_section_w;
  float graph_instruction_section_y = innerY + pad;
  float graph_instruction_section_w = innerW * 0.24;

  String[] instructions = {"Y - Axis -> Overall Mood at the moment",
    "X - Axis -> Timeline",
    "Dots on X -> Activites",
    "Dots on Graph -> Emotions",
    "CLICK ON EACH GRAPH DOT!"};

  pushStyle();
  noStroke();
  fill(160, 120);

  rect(legend_panel_x, legend_panel_y, legend_panel_w, legend_panel_h, 5);
  //rect(activity_section_x, activity_section_y, activity_section_w, activity_section_h);
  //rect(graph_instruction_section_x, graph_instruction_section_y, graph_instruction_section_w, graph_instruction_section_h);
  //rect(activity_section_x,activity_section_y,activity_section_w,activity_section_h);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Emotions", legend_panel_x  + emotion_section_w / 2, legend_panel_y + 12);
  text("Activities", legend_panel_x  + emotion_section_w + activity_section_w/2, legend_panel_y + 12);
  text("Graph Instruction", legend_panel_x + emotion_section_w + activity_section_w + graph_instruction_section_w/ 2, legend_panel_y + 12);

  popStyle();
  pushStyle();
  noStroke();
  int emotion_cols = 2;
  int emotion_rows = 4;
  float emotioncellW = emotion_section_w / emotion_cols;
  float emotioncellH= emotion_section_h / emotion_rows;
  float circleSize = emotioncellH * 0.4;
  for (int col = 0; col < emotion_cols; col++) {
    for (int row = 0; row < emotion_rows; row++) {
      int idx = col * emotion_rows + row;

      float x;
      if (col == 0) {
        x = emotion_section_x + col * emotioncellW + emotioncellW/4 ;
      } else {
        x = emotion_section_x + col * emotioncellW + emotioncellW/10 ;
      }
      float y = emotion_section_y + row * emotioncellH + emotioncellH/2 ;
      fill(emotion_colors[idx]);
      circle(x, y, circleSize);
      fill(0);
      textAlign(LEFT, CENTER);
      text(emotions[idx], x+circleSize, y);
    }
  }
  popStyle();

  pushStyle();
  int activity_cols = 2;
  int life_rows = life_activities.length;
  int study_rows = study_activities.length;
  float activitycellW = activity_section_w / activity_cols;
  float activitycellH = activity_section_h / life_rows;
  fill(#EF476F);
  textAlign(LEFT, CENTER);
  float lifeHeaderX = activity_section_x + activitycellW * 0.3;
  float lifeHeaderY = activity_section_y + activitycellH * 0.5;
  text("Life", lifeHeaderX, lifeHeaderY);
  for (int row = 0; row < life_rows; row++) {
    float x = activity_section_x + 0 * activitycellW + activitycellW/16 ;
    float y = activity_section_y + row  * activitycellH + activitycellH * 1.2;
    text(life_activities[row][0] + " - " + life_activities[row][1], x, y);
  }
  fill(#3A86FF);
  textAlign(LEFT, CENTER);
  float studyHeaderX = activity_section_x + activitycellW * 1.1 ;
  float studyHeaderY = activity_section_y + activitycellH * 0.5;
  text("Study", studyHeaderX, studyHeaderY);
  for (int row = 0; row < study_rows; row++) {
    float x = activity_section_x + 1 * activitycellW + activitycellW/16 ;
    float y = activity_section_y + row * activitycellH + activitycellH * 1.2 ;
    text(study_activities[row][0] + " - " + study_activities[row][1], x, y);
  }
  popStyle();
  pushStyle();
  float ix = graph_instruction_section_x;
  float iy = graph_instruction_section_y + 10;
  float padding = 5;


  for (int i = 0; i < instructions.length; i++) {
    fill(0);
    text(instructions[i], ix, iy  + padding);
    padding+= 20;
  }
  popStyle();
}

boolean isLegendHovered() {
  return ((mouseX >= legend_button_x && mouseX <= legend_button_x + legend_button_w) && mouseY >= legend_button_y && mouseY <= legend_button_y + legend_button_h);
}
boolean isStatsHovered() {
  return ((mouseX >= summary_button_x && mouseX <= summary_button_x + summary_button_w) && mouseY >= summary_button_y && mouseY <= summary_button_y + summary_button_h);
}
void draw_graph() {

  pushStyle();
  strokeWeight(2);
  stroke(120);

  HashSet<Integer> majorHours = new HashSet<Integer>(Arrays.asList(0, 6, 12, 18, 24));
  for (int i = 0; i <= 24; i+=6) {
    float tx = timeline_panel_x + (i /25.0) * timeline_panel_w;
    line(tx, timeline_panel_y-5, tx, timeline_panel_y+timeline_panel_h + 5);
    textAlign(CENTER, CENTER);
    fill(0);
    text(i, tx, timeline_panel_y - 12);
  }
  popStyle();

  ArrayList<Point> current_points = graph_points.get(uniqueDates.get(selectIndex));

  pushStyle();
  stroke(120);
  strokeWeight(4);
  for (int i = 1; i < current_points.size(); i++) {
    stroke(#C9CCCE);
    line(current_points.get(i -1).x, current_points.get(i -1).y, current_points.get(i).x, current_points.get(i).y);
  }
  popStyle();


  for (Point d : current_points) {
    pushStyle();
    noStroke();
    textAlign(CENTER, CENTER);
    fill(d.activity_color);
    circle(d.x, timeline_panel_y + timeline_panel_h/2, 16);

    fill(0);

    if (!majorHours.contains(d.hour)) text(d.hour, d.x, timeline_panel_y + timeline_panel_h/2 - 20);
    text(d.activity, d.x, timeline_panel_y + timeline_panel_h/2 + 15);
    popStyle();
    pushStyle();

    stroke(#FFFFFF, 100);
    if (selectedPoint == d) {
      stroke(0, 100);
      strokeWeight(3);
      fill(d.emotion_color, 150);
      circle(d.x, d.y, 17);
    } else {
      fill(d.emotion_color);
      circle(d.x, d.y, 17);
    }
    popStyle();
  }
  if (selectedPoint != null) {
    drawPointInfo(selectedPoint);
  }
  pushStyle();
  textSize(20);
  fill(0);
  textAlign(LEFT, CENTER);
  text(uniqueDates.get(selectIndex), timeline_panel_x + timeline_panel_w - 30, graph_panel_y + 20 );
  popStyle();
}
void showStats(){
  println(statistics.get(uniqueDates.get(selectIndex)).getAvgMood());
  println(statistics.get(uniqueDates.get(selectIndex)).getFrequentEmotion());

}
void drawPointInfo(Point p) {
  float pointY = p.y;
  float dash_size = 6;
  float dash_gap = 9;
  float startX = timeline_panel_x - 10;
  float endX =   p.x;

  for (float x = startX; x < endX - dash_gap; x+= dash_size + dash_gap) {
    line(x, pointY, x + dash_size, pointY);
  }
  float pointX = p.x;
  float startY = timeline_panel_y + timeline_panel_h/2;
  float endY = p.y;
  for (float y = startY; y > endY - dash_gap; y-= dash_size + dash_gap) {
    line(pointX, y, pointX, y + dash_size);
  }
  pushStyle();
  strokeWeight(2);
  fill(p.activity_color);
  circle(p.x, timeline_panel_y + timeline_panel_h/2, 16);
  popStyle();
  pushStyle();
  noStroke();
  String textOne = "At " + p.hour + ":00, I felt " + p.emotion;
  String textTwo = "During " + p.activity_full;
  String textThree = "Overall mood - " + p.overall_mood;
  int padding = 5;
  float content = max(textWidth(textOne), textWidth(textTwo), textWidth(textThree)) + 20;
  float line_gap = 7;
  float textSz = 12;
  float cardW = content + padding * 2;
  float cardH = padding + textSz + line_gap + textSz + line_gap + textSz + padding;
  float cardY = p.y - cardH - 10;
  float cardX = p.x - cardW/2;

  float contentX = cardX + padding;
  float contentY = cardY + padding;
  fill(pointInfo);
  rect(cardX, cardY, cardW, cardH, 6);
  textAlign(LEFT, TOP);
  fill(30, 180);
  text(textOne, contentX, contentY);
  text(textTwo, contentX, contentY + textSz + line_gap);
  text(textThree, contentX, contentY + (textSz + line_gap)*2);


  popStyle();
}
void fileUnpackage() {
  int MINIMUM_TOKENS = 6; // at least 6 entries in table
  String[] dear_data = loadStrings("deardata_new.csv"); // All lines with  ,

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
  println("There are:  " + (dear_data.length  - 1) + " observations" );
  uniqueDates.sort((a, b) -> {
    String[] pa= a.split("/");
    String[] pb= b.split("/");

    int dayA = Integer.parseInt(pa[0]);
    int monthA = Integer.parseInt(pa[1]);

    int dayB = Integer.parseInt(pb[0]);
    int monthB = Integer.parseInt(pb[1]);
    if (monthA != monthB) {
      return monthA - monthB;
    }
    return dayA - dayB;
  }
  );

  total_days = uniqueDates.size();
}
void changeDayAnimation() {
  animationA = 1;
  animationB = animationA - 0.1 *animationA;
  isAnimating = true;
  loop();
}
void keyPressed() {
  int idx = selectIndex;
  if (key == ' ') {
    if (isLegendOn) {
      isLegendOn = false;
    } else {
      if (isStatsOn) {
        isStatsOn = false;
      }
      isLegendOn = true;
    }
  }
  if (key == CODED) {

    if (keyCode == DOWN) {
      idx++;
      changeDayAnimation();
    } else if (keyCode == UP) {
      idx--;
      changeDayAnimation();
    }
    selectedPoint = null;
  }
  selectIndex = constrain(idx, 0, uniqueDates.size() - 1);
}
void mousePressed() {
  boolean isPointHit  = false;

  ArrayList<Point> current_points = graph_points.get(uniqueDates.get(selectIndex));


  if (isLegendHovered()) {
    isPointHit = true;
    if (isLegendOn) isLegendOn = false;
    else {
      if (isStatsOn) isStatsOn = false;
      isLegendOn = true;
    }
  }
  for ( DayButton d : day_buttons) {
    if (d.isHovered) {
      selectIndex = d.idx;

      selectedPoint = null;
      changeDayAnimation();
    }
  }
  if (isStatsHovered()) {
    if (isStatsOn) {
      isStatsOn = false;
    } else {
      if (isLegendOn) {
        isLegendOn = false;
      }
      isStatsOn = true;
    }
  }
  for (Point d : current_points) {
    if (d.isHovered() && selectedPoint != d) {
      selectedPoint = d;
      isPointHit = true;
    } else if (selectedPoint == d) {
      isPointHit = false;
    }
  }
  if (!isPointHit) selectedPoint = null;
}
