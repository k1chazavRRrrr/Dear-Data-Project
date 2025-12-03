class Daystats   {

  String date;
  ArrayList <Observation> allObs = new ArrayList<>();
  
  float avgmood = 0;
   HashMap<String, Integer> avgEmotion = new HashMap<>();
   
  Daystats(String date){
    this.date = date;
  }
  void addObservation(Observation d){
    this.allObs.add(d);
    
  }
  void calculate(){
    int overallMood = 0;
    for(Observation o : allObs){
      overallMood += o.overall_mood;
      
      avgEmotion.put(o.emotion, avgEmotion.getOrDefault(o.emotion, 0 ) + 1);
    }
    if (allObs.size() > 0){
      avgmood = (float) overallMood / allObs.size();
    }
   }
   float getAvgMood(){
     calculate();
     return round(avgmood);
   }
    String getFrequentEmotion(){
      String top = "";
      int topCount = 0;
      for(String e : avgEmotion.keySet()){
        int count = avgEmotion.get(e);
        if(count > topCount){
          topCount = count;
          top = e;
        }
      }
      return top ;
    }
}
