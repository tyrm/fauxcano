Fauxcano volcano;

void setup() {
  size(200,200, P2D);
  frameRate(5);
  
  volcano = new Fauxcano();
}

void draw() {
  clear();
  background(0);
  
  volcano.draw(0,0);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      volcano.incSetTemp();
    } else if (keyCode == DOWN) {
      volcano.decSetTemp();
    } 
  } else if (key == 'a') {
    volcano.togglePump();
  } else if (key == 'p') {
    volcano.togglePower();
  } else if (key == 'f') {
    volcano.toF();
  } else if (key == 'c') {
    volcano.toC();
  }
}
