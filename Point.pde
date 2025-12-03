class Point {
  float x;
  float y;
  int hour;
  String emotion;
  String activity;
  String activity_full;
  int overall_mood;

  color emotion_color;
  color tired = #8E9A9D;
  color anxious = #C44949;
  color unproductive = #9B8F6E;
  color productive= #7DA657;
  color motivated = #F4C542;
  color chill = #6DBFB8;
  color happy = #820263 ;
  color nostalgic = #B49BC8;
  color other_emotion = #FFFFFF;

  color activity_color;
  color life_activity = #EF476F;
  color study_activity = #3A86FF;
  
  boolean isHovered = false;
  
  Point(int hour, String activity, String emotion, int overall_mood) {
    this.hour = hour;
    this.activity = activity;
    this.emotion = emotion;
    this.overall_mood = overall_mood;
    this.x = hourToX(hour);
    this.y = moodToY(overall_mood);
    switch(emotion) {
    case "Tired":
      this.emotion_color = tired;
      break;
    case "Anxious":
      this.emotion_color = anxious;

      break;
    case "Unproductive":
      this.emotion_color = unproductive;

      break;
    case "Chill":
      this.emotion_color = chill;

      break;
    case "Motivated":
      this.emotion_color = motivated;

      break;
    case "Productive":
      this.emotion_color = productive;

      break;
    case "Happy":
      this.emotion_color = happy;

      break;
    case "Nostalgic":
      this.emotion_color = nostalgic;
      break;
      default:
      this.emotion_color = other_emotion;
      break;
    }
    switch(activity) {
    case "mrn":
    this.activity_color =  life_activity;
    this.activity_full = "Morning";
      break;
    case "sh":
        this.activity_color =  life_activity;
        this.activity_full = "Shopping";

      break;
    case "evn":
        this.activity_color =  life_activity;
        this.activity_full = "Evening";

      break;
    case "go":
        this.activity_color =  life_activity;
        this.activity_full = "Going out";

      break;
    case "ga":
        this.activity_color =  life_activity;
        this.activity_full = "Gaming";

      break;
    case "g":
        this.activity_color =  life_activity;
            this.activity_full = "Gym";
      break;

    case "le":
        this.activity_color = study_activity ;
            this.activity_full = "Lecture";

      break;
    case "lt":
          this.activity_color = study_activity ;
          this.activity_full = "Lab/Tutorial";


      break;
    case "st":
            this.activity_color = study_activity ;
              this.activity_full = "Study Time";

      break;
    }
  }
  boolean isHovered(){
    float x = hourToX(hour);
    float y = moodToY(overall_mood);
    return mouseX >= x - 6 &&  mouseX <= x +6 && mouseY >= y - 8 && mouseY <= y + 8;
  }
  void update(){
    isHovered = isHovered();
  }
  float hourToX(int hour) {
    return timeline_panel_x + (hour / 25.0) * timeline_panel_w;
  }

  float moodToY(int mood) {
    float MIN_MOOD = 1;
    float MAX_MOOD = 10;
    float yBot = timeline_panel_y - 20;
    float yTop = graph_panel_y + 20;
    float y_range = constrain((mood - MIN_MOOD) / (MAX_MOOD - MIN_MOOD), 0, 1);

    return (yBot - y_range * (yBot-yTop));
  }
   color getEmotionColor(){
  return emotion_color;
  }
  color getActivityColor(){
   return activity_color;
  }
}
