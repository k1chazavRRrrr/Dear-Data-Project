class GlobalStats {

  float avgMood;
  String frequentEmotion;
  int freqEmotionAm;

  String bestDay;
  float bestDayMood;

  String worstDay;
  float worstDayMood;

  int avgAwakeTime = 0;
  int avgBedTime = 0;

  HashMap<String, Integer> emotionFreq = new HashMap<>();

  GlobalStats(ArrayList<Daystats> stats) {
    calculate(stats);
  }

  void calculate(ArrayList<Daystats> stats) {

    int totalMood = 0;
    int totalCount = 0;

    bestDayMood = 0;
    worstDayMood = 11;

    for (Daystats d : stats) {
      
     
      float average = d.getAvgMood();
      int count = d.getCount();

      totalMood += average * count;
      totalCount += count;

      for (String emo : d.avgEmotion.keySet()) {
        int emoCount = d.avgEmotion.get(emo);
        emotionFreq.put(emo, emotionFreq.getOrDefault(emo, 0) + emoCount);
      }

      if (average > bestDayMood) {
        bestDayMood = average;
        bestDay = d.date;
      }
      if (average < worstDayMood) {
        worstDayMood = average;
        worstDay = d.date;
      }
    }

    avgMood = totalMood / (float) totalCount;

    int top = 0;
    for (String e : emotionFreq.keySet()) {
      if (emotionFreq.get(e) > top) {
        top = emotionFreq.get(e);
        frequentEmotion = e;
        freqEmotionAm = emotionFreq.get(e);
      }
    }
    int allAwakes = 0;
    int allBedTime = 0;
    for (Daystats d : stats) {
      
      allAwakes += Integer.parseInt(d.getAwakeTime()); 
      allBedTime += Integer.parseInt(d.getBedTime());
    }
    avgAwakeTime = floor(allAwakes / stats.size());
    avgBedTime = floor(allBedTime / stats.size());
  }

  float getAvgMood() {
    return avgMood;
  }

  String getFrequentEmotion() {
    return frequentEmotion;
  }
  String getAvgAwakeTime() {
    return Integer.toString(avgAwakeTime);
  }
  int getFrequentEmotionAmount() {
    return freqEmotionAm;
  }
  String getAvgBedTime() {
    return Integer.toString(avgBedTime);
  }
  String getBestDay() {
    return bestDay + " (" + bestDayMood + ")";
  }

  String getWorstDay() {
    return worstDay + " (" + worstDayMood + ")";
  }
}
