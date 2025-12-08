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

  GlobalStats(HashMap<String, Daystats> stats) {
    calculate(stats);
  }

  void calculate(HashMap<String, Daystats> stats) {

    int totalMood = 0;
    int totalCount = 0;

    bestDayMood = 0;
    worstDayMood = 11;

    for (String d : stats.keySet()) {
      Daystats ds = stats.get(d);
      float average = ds.getAvgMood();
      int count = ds.getCount();

      totalMood += average * count;
      totalCount += count;

      for (String emo : ds.avgEmotion.keySet()) {
        int emoCount = ds.avgEmotion.get(emo);
        emotionFreq.put(emo, emotionFreq.getOrDefault(emo, 0) + emoCount);
      }

      // best/worst days
      if (average > bestDayMood) {
        bestDayMood = average;
        bestDay = d;
      }
      if (average < worstDayMood) {
        worstDayMood = average;
        worstDay = d;
      }
    }

    avgMood = totalMood / (float) totalCount;

    // find most common emotion
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
    for (String d : stats.keySet()) {
      Daystats ds = stats.get(d);
      allAwakes += Integer.parseInt(ds.getAwakeTime());
      allBedTime += Integer.parseInt(ds.getBedTime());
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
