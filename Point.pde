class Point {
  float x;
  float y;
  int hour;
  String emotion;
  String activity;
  int overall_mood;

  color emotion_color;

  color activity_color;
  color life_activity;
  color study_activity;
  Point(int hour, String activity, String emotion, int overall_mood) {
    this.hour = hour;
    this.activity = activity;
    this.emotion = emotion;
    this.overall_mood = overall_mood;
    this.x = hourToX(hour);
    this.y = moodToY(overall_mood);
    switch(emotion){
    case "tired":
    break;
    case "anxious":
    break;
    case "unproductive":
    break;
    case "chill":
    break;
    case "motivated":
    break;
    case "productive":
    break;
    case "happy":
    break;
    case "nostalgic":
    break;
    }
    switch(activity){
      case "mrn":
      break;
      case "sh":
      break;
      case "evn":
      break;
      case "go":
      break;
      case "ga":
      break;
      case "g":
      break;
      
      case "le":
      break;
      case "lt":
      break;
      case "st":
      break;
    }
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
}
