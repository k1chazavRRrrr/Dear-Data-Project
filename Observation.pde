class Observation{
  String date;
  String time;
  String emotion;
  String activity;
  int overall_mood;
  String notes;
  
  
  Observation(String date, String time, String emotion,String activity,int overall_mood,String notes){
    this.date = date;
    this.time = time;
    this.emotion = emotion;
    this.activity = activity;
    this.overall_mood = overall_mood;
    this.notes = notes;
  }
  
  //toString for Debug.
  String toString(){
  return "Date :" + this.date + 
  " Time: " + this.time + " Emotion: " + this.emotion + " Activity: " + this.activity + " Mood: "
  + this.overall_mood + " Notes: " + notes;
  }
}
