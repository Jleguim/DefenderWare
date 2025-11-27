class CodeMicroGame extends WindowContent {
  PImage[] sprites;
  float scaleX, scaleY;

  int startms, timeSpent;
  Phone phone;

  PVector keysPos;
  GameElement[] keys = new GameElement[10];

  String code = "";
  String input = "";
  PVector codePos;

  CodeMicroGame(float x, float y, int w, int h) {
    super(x, y, w, h);
    this.sprites = new PImage[]{
      loadImage("/sprites/microgames/2fa.png"),
      loadImage("/sprites/microgames/celular.png"),
    };
    this.calculatePixelSize();
    this.keysPos = new PVector(this.scaleX*26, this.scaleY*20);
    this.codePos = new PVector(this.scaleX*22, this.scaleY*10);
    this.reset();

    int keysWidth = (int) this.scaleX*6;
    int keysHeight = (int) this.scaleY*7;

    int j = 0, k = 0;
    for (int i = 0; i < this.keys.length; i++) {
      if (i==0) {
        this.keys[i] = new GameElement(this.keysPos.x +(this.scaleX*1.8) + (keysWidth), this.keysPos.y + (keysHeight*3) + (this.scaleY*3), keysWidth, keysHeight);
        continue;
      }

      if (i <= 3) {
        this.keys[i] = new GameElement(this.keysPos.x +((i-1)*this.scaleX*1.8) + ((i-1)*keysWidth), this.keysPos.y, keysWidth, keysHeight);
      } else if (i <= 6) {
        this.keys[i] = new GameElement(this.keysPos.x +(j*this.scaleX*1.8) + (j*keysWidth), this.keysPos.y + keysHeight + this.scaleY, keysWidth, keysHeight);
        j++;
      } else if (i <= 9) {
        this.keys[i] = new GameElement(this.keysPos.x +(k*this.scaleX*1.8) + (k*keysWidth), this.keysPos.y + (keysHeight*2) + (this.scaleY*2), keysWidth, keysHeight);
        k++;
      }
    }
  }

  void updatePositions(PVector newPosition) {
    PVector oldPos = this.pos.copy();
    this.pos = newPosition;
    PVector diff = PVector.sub(this.pos, oldPos);

    this.keysPos.add(diff);
    this.codePos.add(diff);

    for (GameElement k : this.keys) {
      k.pos.add(diff);
    }
  }

  void calculatePixelSize() {
    this.scaleX = this.w / this.sprites[0].width;
    this.scaleY = this.h / this.sprites[0].height;
  }

  String generateCode() {
    String abc = "0123456789";
    int size = 4;
    String code = "";

    for (int i = 0; i < size; i++) {
      char c = abc.charAt((int) random(0, abc.length()));
      code += c;
    }

    return code;
  }

  void reset() {
    this.startms = millis();
    this.input = "";
    this.timeSpent = 0;
    this.code = generateCode();
    this.phone = new Phone(width-(122*3.3), 500, 112*4, 176*4, this.sprites[1]);
    this.phone.code = this.code;
  }

  void update() {
    if (this.timeSpent > 2) {
      this.phone.raise(width-(122*3.3), 900);
    }
  }

  void handleMouseClicked() {
    for (int i = 0; i < this.keys.length; i++) {
      GameElement k = this.keys[i];
      if (k.isOver() && this.input.length() < 4) {
        this.input += String.valueOf(i);
        break;
      }
    }
  }

  boolean shouldAddScore() {
    return this.input.equals(this.code);
  }

  boolean isDone() {
    int now = millis();
    this.timeSpent = (now - this.startms) / 1000;

    return this.timeSpent > 5 || this.input.length() == 4 || this.input.equals(this.code);
  }

  void draw() {
    image(this.sprites[0], this.pos.x, this.pos.y, this.w, this.h);
    this.update();

    if (!this.phone.isMoving) {
      this.phone.raise(width-(122*3.3), height-(176*4));
    }

    fill(0);
    textSize(32);
    for (int i = 0; i < this.input.length(); i++) {
      char c = this.input.charAt(i);
      text(c, this.codePos.x + (i*this.scaleX*9), this.codePos.y);
    }
    textSize(10);
    fill(255);

    this.phone.draw();
  }
}

class Phone extends GameElement {
  PImage sprite;
  PVector contentPos;
  float contentWidth;
  float contentHeight;

  PVector targetPos = new PVector(0, 0);
  float moveSpeed = 8f;
  boolean isMoving = false;

  String code = "1234";

  Phone(float x, float y, int w, int h, PImage sprite) {
    super(x, y, w, h);
    this.sprite = sprite;
    this.contentPos = new PVector(this.pos.x + (21*4), this.pos.y + (16*4));
    this.contentWidth = 52*4;
    this.contentHeight = 32*4;
  }

  void raise(float x, float y) {
    this.targetPos.set(x, y);
    this.isMoving = true;
  }

  void updateMovement() {
    if (!this.isMoving) {
      return;
    }

    PVector distanceVector = PVector.sub(this.targetPos, this.pos);
    float distance = distanceVector.mag();
    if (distance < this.moveSpeed) {
      float oldX = this.pos.x;
      float oldY = this.pos.y;
      this.pos.set(this.targetPos);
      this.isMoving = false;
      this.updateContentPosition(this.pos.x - oldX, this.pos.y - oldY);
    } else {
      distanceVector.normalize();
      distanceVector.mult(this.moveSpeed);
      this.pos.add(distanceVector);
      this.updateContentPosition(distanceVector.x, distanceVector.y);
    }
  }

  void updateContentPosition(float dx, float dy) {
    this.contentPos.x += dx;
    this.contentPos.y += dy;
  }

  void draw() {
    this.updateMovement();
    image(this.sprite, this.pos.x, this.pos.y, this.w, this.h);
    textSize(32);
    textAlign(CENTER);
    fill(0);
    text("Código 2FA", this.contentPos.x + (contentWidth/2), this.contentPos.y + 32);
    fill(255);
    text(this.code, this.contentPos.x + (contentWidth/2), this.contentPos.y + 62);
    textAlign(LEFT, TOP);
  }
}
