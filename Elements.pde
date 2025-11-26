class GameElement {
  PVector pos = new PVector(0, 0);
  int w, h;

  GameElement(float x, float y, int size) {
    this.pos = new PVector(x, y);
    this.w = size;
    this.h = size;
  }

  GameElement(float x, float y, int w, int h) {
    this.pos = new PVector(x, y);
    this.w = w;
    this.h = h;
  }

  void debug() {
    fill(0, 255, 0, 50);
    strokeWeight(1);
    stroke(0, 255, 0);
    rect(this.pos.x, this.pos.y, this.w, this.h);

    fill(0);
    text(this.pos.x + "," + this.pos.y, this.pos.x, this.pos.y-30);
    text((this.isOver()) ? "hovering" : "idle", this.pos.x, this.pos.y+30);
  }

  boolean isOver() {
    return mouseX >= pos.x && mouseX <= pos.x + w && mouseY >= pos.y && mouseY <= pos.y + h;
  }

  boolean isColliding(GameElement element) {
    if (this.pos.x + this.w <= element.pos.x || element.pos.x + element.w <= this.pos.x) {
      return false;
    }
    if (this.pos.y + this.h <= element.pos.y || element.pos.y + element.h <= this.pos.y) {
      return false;
    }

    return true;
  }
}

class ImageElement extends GameElement {
  PImage sprite;
  float scaleX, scaleY;

  ImageElement(float x, float y, int size) {
    super(x, y, size);
  }

  ImageElement(float x, float y, int w, int h) {
    super(x, y, w, h);
  }

  ImageElement(float x, float y, int size, String spritePath) {
    super(x, y, size);

    if (spritePath != null) {
      this.sprite = loadImage(spritePath);
      this.calculatePixelSize();
    }
  }

  ImageElement(float x, float y, int w, int h, String spritePath) {
    super(x, y, w, h);
    this.sprite = loadImage(spritePath);
    this.calculatePixelSize();
  }

  ImageElement(float x, float y, int size, PImage sprite) {
    super(x, y, size);
    this.sprite = sprite;
    this.calculatePixelSize();
  }

  ImageElement(float x, float y, int w, int h, PImage sprite) {
    super(x, y, w, h);
    this.sprite = sprite;
    this.calculatePixelSize();
  }

  void calculatePixelSize() {
    this.scaleX = this.w / this.sprite.width;
    this.scaleY = this.h / this.sprite.height;
  }

  void debug() {
    fill(0, 255, 0, 50);
    strokeWeight(1);
    stroke(0, 255, 0);
    rect(this.pos.x, this.pos.y, this.w, this.h);

    fill(255);
    textSize(10);
    text(this.pos.x + "," + this.pos.y, this.pos.x, this.pos.y-30);
    text(this.scaleX + "," + this.scaleY, this.pos.x, this.pos.y-60);
    text((this.isOver()) ? "hovering" : "idle", this.pos.x, this.pos.y+30);
  }

  void draw() {
    image(this.sprite, this.pos.x, this.pos.y, this.w, this.h);
  }
}
