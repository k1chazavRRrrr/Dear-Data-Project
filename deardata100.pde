import java.util.*;
ArrayList<String> uniqueDates = new ArrayList<String>();
HashMap<String, ArrayList<Observation>> byDate = new HashMap<>();

int selectIndex = 0;

void setup(){
  fileUnpackage();
}
void draw(){
  daySelect();
  noLoop();
}
void daySelect(){
  String day = uniqueDates.get(selectIndex);
  ArrayList<Observation> daylist = byDate.get(day);
  println("Day - " + day);
  for(Observation d : daylist){
    println(d.time + " " + d.emotion +  " "  + d.notes);
  }
  
}
void fileUnpackage() {
  String[] dear_data = loadStrings("data.csv"); // All lines with ;
  
  for(int i = 1;  i < dear_data.length; i++){ // Through Words lines[i] - word
   
    String[] tokens = split(dear_data[i], ",");
    if(tokens.length < 6) continue;
    String date = tokens[0];
    String time = tokens[1];
    String emotion = tokens[2];
    String activity = tokens[3];
    int overall_mood = int(tokens[4]);
    String notes = tokens[5];
    Observation obs = new Observation(date, time, emotion, activity, overall_mood, notes);
    Daystats stats = new Daystats(date);
      if(!byDate.containsKey(date)){
        byDate.put(date, new ArrayList<Observation>());
        uniqueDates.add(date);
      }
      byDate.get(date).add(obs);
    } 
     println("There are:  " + dear_data.length + " observations" );
    uniqueDates.sort(null);
    stats.debug;
}
void keyPressed(){
  loop();
  int idx = selectIndex;
  if (key == CODED){
    if (keyCode == UP){
      idx++;
    }
    else if (keyCode == DOWN){
      idx--;
    }
  }
  selectIndex = constrain(idx, 0, uniqueDates.size() - 1);
}
