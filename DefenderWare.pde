DefenderWareGame dw;

void mouseClicked() {
  dw.mouseClicked();
}

void mousePressed() {
  dw.mousePressed();
}

void mouseDragged() {
  dw.mouseDragged();
}

void mouseReleased() {
  dw.mouseReleased();
}

void settings() {
  size(1280, 720);
  smooth(8);
}

void setup() {
  dw = new DefenderWareGame();
}

void draw() {
  dw.start();
  dw.draw();
}
