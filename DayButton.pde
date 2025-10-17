class DayButton {
  color activebutton = #A5C8FF;
  color hoveredbutton = #B8D2DA;
  color sleepbutton = #C8DEE3;
  color text_color = #2C2C2C;
  float x;
  float y;
  float w;
  float h;
  int idx;
  boolean isHovered = false;
  DayButton(float x, float y, float w, float h, int idx) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.idx = idx;
  }
  
  boolean isHovered(){
  return (mouseX >= x && mouseX <= x + w && mouseY >= y  && mouseY <= y + h);
  }
  void update(){
    isHovered = isHovered();
  }
  void display(){
    if (selectIndex == idx){
      fill(activebutton);
    }
      else if(isHovered){
      fill(hoveredbutton);}
      else{
        fill(sleepbutton);
    }
    rect(x, y, w, h, 6);
     fill(text_color);
     textAlign(CENTER, CENTER);
     text("Day - " + (idx + 1), x + w/2, y + h/2);
  }
}
