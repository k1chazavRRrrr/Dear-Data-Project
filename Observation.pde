class Observation{
  String date;
  String time;
  String emotion;
  String activity;
  int overall_mood;
  String notes;
  
  Observation(String date, String time, String emotion, String activity, int overall_mood, String notes ){
  this.date = date;
  this.time = time;
  this.emotion = emotion;
  this.activity = activity;
  this.overall_mood = overall_mood;
  this.notes = notes;
  }
  public String toString() {
    return date + " | " + time + " | " + emotion + " | " + activity + " | " + overall_mood + " | " + notes + "\n";
  }
}
