class Daystats   {
  String date;
  int countforavg = 0;
  float sumMood;
  float avgMood;
  
  Daystats(String date){ //To ensure that all stats will be at the same date
  this.date = date;
  }
  

  
  void addObservation(Observation day){
   //AvgMood count
 
    sumMood += day.overall_mood;
    countforavg++;
    avgMood = sumMood / countforavg; 
   
  }

   void debug(){
    
      println("Day stats of  " + this.date+ ". Overall Mood for this day is: " + this.avgMood);
    
  
  }
}
