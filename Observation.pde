class Observation{
  String date;
  String time;
  String emotion;
  String activity;
  int overall_mood;
  String notes;
  color activitycolor;
  color lifeactivity = #FF934F;
  color studyactivity = #008BF8;
  color other = #7C7C7C;
  Observation(String date, String time, String emotion, String activity, int overall_mood, String notes ){
  this.date = date;
  this.time = time;
  this.emotion = emotion;
  this.activity = activity;
  this.overall_mood = overall_mood;
  this.notes = notes;
  switch (activity){
  case "mrn" :
  this.activitycolor = lifeactivity;
  break;
  case "sh" :
  this.activitycolor = lifeactivity;
  break;
  case "g":
  this.activitycolor = lifeactivity;
  break;
  case "ga":
  this.activitycolor = lifeactivity;
  break;
  case "go":
  this.activitycolor = lifeactivity;
  break;
  case "evn":
  this.activitycolor = lifeactivity;
  break;
  case "le":
  this.activitycolor = studyactivity;
  break;
  case "lt":
  this.activitycolor = studyactivity;
  break;
  case "st" :
  this.activitycolor = studyactivity;
  break;
  default:
  this.activitycolor = other;
  }
  }
  public String toString() {
    return date + " | " + time + " | " + emotion + " | " + activity + " | " + overall_mood + " | " + notes + "\n";
  }
}
