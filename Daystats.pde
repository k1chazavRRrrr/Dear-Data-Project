class Daystats   {
  String date;
  int count = 0;
  float sumMood;
  float avgMood;
  Daystats(String date){ //To ensure that all stats will be at the same date
  this.date = date;
  }
  
 ArrayList<Observation> observations = new ArrayList<Observation>(); 
   
  void countEverything(Observation day){
   //AvgMood count
    observations.add(day);
    sumMood += day.overall_mood;
    count++;
    avgMood /= count;
    
  }
  
  void debug(){
    for(Observation obs : observations){
      println("Day stats of  " + obs.date + ". Overall Mood for this day is: " + this.avgMood);
    }
  
  }
}
