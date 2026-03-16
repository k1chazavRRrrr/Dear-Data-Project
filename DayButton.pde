class DayButton {
  color activebutton = #A5C8FF;
  color hoveredbutton = #B8D2DA;
  color sleepbutton = #C8DEE3;
  color text_color = #2C2C2C;
  float x;
  float y;
  float w;
  float h;
  String date;
  boolean isHoveredstatus = false;
  DayButton(float x, float y, float w, float h, String date) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.date = date;
  }
  
  boolean isHovered(){
  return (mouseX >= x && mouseX <= x + w && mouseY >= y  && mouseY <= y + h);
  }
  void update(){
    isHoveredstatus = isHovered();
  }
  void display(String selectedDate){
    if (selectedDate.equals(this.date)){
      fill(activebutton);
    }
      else if(isHoveredstatus){
      fill(hoveredbutton);}
      else{
        fill(sleepbutton);
    }
    rect(x, y, w, h, 6);
     fill(text_color);
     textAlign(CENTER, CENTER);
     
     text(this.date, x + w/2, y + h/2);
  }
}
