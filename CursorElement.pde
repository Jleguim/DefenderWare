class CursorElement extends ImageElement {
  PImage[] sprites;
  int state = 0;

  CursorElement() {
    super(mouseX, mouseY, 27);

    this.sprites = new PImage[] {
      loadImage("/sprites/pointer.png"),
      loadImage("/sprites/hand.png")
    };

    this.sprite = this.sprites[this.state];
    this.calculatePixelSize();
  }

  void hide() {
    this.pos.set(-500, -500);
  }

  void update() {
    if (this.sprite != this.sprites[this.state]) {
      this.sprite = this.sprites[this.state];
      this.calculatePixelSize();
    }

    float limitedX = constrain(mouseX, 0, width);
    float limitedY = constrain(mouseY, 0, height);

    this.pos.set(limitedX - (this.scaleX * 2), limitedY - this.scaleY);
  }
}
