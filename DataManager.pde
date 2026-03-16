// DataManager handles:
// -Loading data from API
// -grouping observations by date
// -computing statistics
// -preparing points for visualisation


class DataManager {

  private ArrayList<String> uniqueDates = new ArrayList<String>();// To Sort dates in order from (Oldest first to newest dates)
  private HashMap<String, ArrayList<Observation>> byDate = new HashMap<>();// To Store all Observations according to Date - Observation
  private HashMap<String, Daystats> statistics = new HashMap<>();// To store Statistics for a certain day, eg date - overall_mood
  private HashMap<String, ArrayList<Point>> graphPoints = new HashMap<>(); // Storing all Points on graph, accessible by date

  private HashSet<String> seenDateHours = new HashSet<>();


  DataManager() {
    loadData();
  }

  void loadData() {
    JSONArray dataSheet;
    dataSheet = loadJSONArray("https://sheetdb.io/api/v1/fihpw4vfao5lh");

    for (int i = 0; i < dataSheet.size(); i++) { // Through Words lines[i] - word

      JSONObject e = dataSheet.getJSONObject(i);
      String ts = e.getString("Timestamp");

      if (ts == null || ts.equals("")) {
        println("There is no data for line " + i  +" in DB ");
        continue;
      }

      String[] timestamp_tokens = split(ts, " ");

      if (timestamp_tokens.length < 2) {
        println("There is no data for line " + i  +" in DB ");

        continue;
      }
      String[] time_tokens = split(timestamp_tokens[1], ":");
      String date = timestamp_tokens[0];
      String hour = time_tokens[0];
      String customDate  = e.getString("custom_date");
      String customHour  = e.getString("custom_hour");
      if (customDate != null && !customDate.equals("")) {
        date = customDate;
      }
      if (customHour != null && !customHour.equals("")) {
        hour = customHour;
      }
      String key = date + "-" + hour;
      if (seenDateHours.contains(key)) continue;
      seenDateHours.add(key);

      String emotion = e.getString("emotion");
      String activity = e.getString("activity");
      int overall_mood = Integer.parseInt(e.getString("overall_mood"));


      //Create an Object - Observation with tokens parameters
      Observation obs = new Observation(date, hour, emotion, activity, overall_mood);
     
      if (!statistics.containsKey(date)) {
        statistics.put(date, new Daystats(date));
      }
      statistics.get(date).addObservation(obs);
      if (!graphPoints.containsKey(date)) {
        graphPoints.put(date, new ArrayList<Point>());
      }
      graphPoints.get(date).add(new Point(Integer.parseInt(hour), activity, emotion, overall_mood));
      //Making statement with day's Observations Hashmap filling
      if (!byDate.containsKey(date)) {
        byDate.put(date, new ArrayList<Observation>());
        uniqueDates.add(date);
      }
      byDate.get(date).add(obs);
    }
    for (String d : graphPoints.keySet()) {
      graphPoints.get(d).sort((a, b) -> a.hour - b.hour);
    }
    sortDates();
    //Debug about how many observation been parsed
    println("There are: " + (dataSheet.size()) + " observations" );
    total_days = uniqueDates.size();
  }


  void sortDates() {
    uniqueDates.sort((a, b) -> {
      String[] pa= a.split("/");
      String[] pb= b.split("/");

      int dayA = Integer.parseInt(pa[0]);
      int monthA = Integer.parseInt(pa[1]);

      int dayB = Integer.parseInt(pb[0]);
      int monthB = Integer.parseInt(pb[1]);
      if (monthA != monthB) {
        return monthA - monthB;
      }
      return dayA - dayB;
    }
    );
  }
  public String getDate(int index) {
    return uniqueDates.get(index);
  }
  public int getDate(String date) {
    for(int i = 0 ; i < uniqueDates.size(); i++){
      String currentDate = uniqueDates.get(i);
      if (currentDate.equals(date)) return i;
    }
    return 0;
    
  }
  public ArrayList<String> getAllDates() {
    return uniqueDates;
  }
  public ArrayList<Observation> getDayObs(int index) {
    String date = uniqueDates.get(index);
    return byDate.get(date);
  }

  public ArrayList<Daystats> getAllStats() {
    ArrayList<Daystats> allStats = new ArrayList<>();
    for (String d : statistics.keySet()) {
      allStats.add(statistics.get(d));
    }
    return allStats;
  }
  public ArrayList<Point> getDayPoints(int index) {
    String date = uniqueDates.get(index);
    ArrayList<Point> pts = graphPoints.get(date);
    
    if(pts == null) {
      println("No data!");
      return new ArrayList<Point>();
    }
    
    return pts;
}
  public Daystats getDayStats(int index) {
    String date = uniqueDates.get(index);
    Daystats ds = statistics.get(date);

    if(ds == null) return new Daystats(date);

    return ds;
}
  public void refreshData(){
    uniqueDates.clear();
    byDate.clear();
    statistics.clear();
    graphPoints.clear();
    seenDateHours.clear();
    
    loadData();
    
  }
}
