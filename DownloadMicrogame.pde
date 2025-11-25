
class DownloadMicrogame extends WindowContent {
  PImage[] sprites;
  PVector[] positions;
  float scaleX, scaleY;

  boolean madeDecision = false;
  boolean madeRightDecision = false;
  int startms, timeSpent;

  ImageElement fakeBtn, realBtn;

  DownloadMicrogame(float x, float y, int w, int h) {
    super(x, y, w, h);
    this.sprites = new PImage[]{
      loadImage("/sprites/microgames/downloadpage.png"),
      loadImage("sprites/microgames/downloadbtn1.png"),
      loadImage("sprites/microgames/downloadbtn2.png")
    };
    this.calculatePixelSize();
    this.positions = new PVector[]{
      new PVector(this.pos.x+(this.scaleX*12), this.pos.y+(this.scaleY*30)),
      new PVector(this.pos.x + (this.scaleX*35), this.pos.y+(this.scaleY*30)),
    };
    this.reset();
  }

  void updatePositions(PVector newPosition) {
    PVector oldPos = this.pos.copy();
    this.pos = newPosition;
    PVector diff = PVector.sub(this.pos, oldPos);

    this.fakeBtn.pos.add(diff);
    this.realBtn.pos.add(diff);

    this.positions = new PVector[]{
      new PVector(this.pos.x+(this.scaleX*12), this.pos.y+(this.scaleY*30)),
      new PVector(this.pos.x + (this.scaleX*35), this.pos.y+(this.scaleY*30)),
    };
  }


  void reset() {
    this.startms = millis();
    this.timeSpent = 0;
    this.madeDecision = false;

    if (random(0, 1) > 0.5) {
      this.fakeBtn = new ImageElement(this.positions[0].x, this.positions[0].y, 20*(int)this.scaleX, 7*(int)this.scaleY);
      this.realBtn = new ImageElement(this.positions[1].x, this.positions[1].y, 20*(int)this.scaleX, 7*(int)this.scaleY);
    } else {
      this.realBtn = new ImageElement(this.positions[0].x, this.positions[0].y, 20*(int)this.scaleX, 7*(int)this.scaleY);
      this.fakeBtn = new ImageElement(this.positions[1].x, this.positions[1].y, 20*(int)this.scaleX, 7*(int)this.scaleY);
    }

    if (random(0, 1) > 0.5) {
      this.fakeBtn.sprite = this.sprites[1];
      this.realBtn.sprite = this.sprites[2];
    } else {
      this.realBtn.sprite = this.sprites[1];
      this.fakeBtn.sprite = this.sprites[2];
    }
  }

  boolean isDone() {
    int now = millis();
    this.timeSpent = (now - this.startms) / 1000;

    return this.timeSpent > 5 || this.madeDecision;
  }

  void handleMouseClicked() {
    madeDecision = fakeBtn.isOver() || realBtn.isOver();
    madeRightDecision = (realBtn.isOver()) ? true : false;
  }

  boolean shouldAddScore() {
    return madeRightDecision;
  }

  void calculatePixelSize() {
    this.scaleX = this.w / this.sprites[0].width;
    this.scaleY = this.h / this.sprites[0].height;
  }


  void draw() {
    image(this.sprites[0], this.pos.x, this.pos.y, this.w, this.h);

    fill(255);
    textSize(30);
    text("peoplefiles", this.pos.x + this.scaleX, this.pos.y + this.scaleY);
    textSize(50);
    text("Tu archivo está listo", this.pos.x + (this.scaleX * 8), this.pos.y+(this.scaleY*14));

    fakeBtn.draw();
    realBtn.draw();

    textSize(24);
    text("Descargar", realBtn.pos.x + (this.scaleX * 7), realBtn.pos.y + (this.scaleY * 2));
    text("Download", fakeBtn.pos.x+ (this.scaleX * 7), fakeBtn.pos.y + (this.scaleY * 2));

    fill(0);
    textSize(10);
    text("Tiempo: " + this.timeSpent + "s", this.pos.x, this.pos.y);
  }
}