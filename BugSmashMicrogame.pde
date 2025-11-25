class Bug extends ImageElement {
  PImage[] sprites;
  int status = 0; // 0 alive, 1 dead
  int orientation = (int) random(0, 3);
  float movementSpeed = 10f;
  float continuousSpeed = 0.5;

  PVector[] directionVectors = {
    new PVector(0, -1), // 0: Up
    new PVector(1, 0), // 1: Right
    new PVector(0, 1), // 2: Down
    new PVector(-1, 0)  // 3: Left
  };

  Bug(float x, float y, int size, PImage[] sprites) {
    super(x, y, size, sprites[0]);
    this.sprites = sprites;
  }

  void rotate90Degrees() {
    if (random(1) > 0.5) {
      orientation = (orientation + 1) % directionVectors.length;
    } else {
      orientation = (orientation + 3) % directionVectors.length;
    }
  }

  void moveContinuously() {
    if (status != 0) return;
    PVector direction = directionVectors[orientation];
    PVector displacement = PVector.mult(direction, continuousSpeed);
    this.pos.add(displacement);
  }

  void draw() {
    this.sprite = this.sprites[this.status];

    pushMatrix();

    float centerX = this.pos.x + this.w / 2.0;
    float centerY = this.pos.y + this.h / 2.0;
    translate(centerX, centerY);

    float angle = radians(this.orientation * 90);
    rotate(angle);

    image(this.sprite, -this.w / 2.0, -this.h / 2.0, this.w, this.h);

    popMatrix();
  }
}

class BugSmashMicrogame extends WindowContent {
  PImage[] sprites;
  int bugSize;

  int startms, timeSpent, aliveBugs = 5;

  Bug[] bugs = new Bug[5];
  int lastActionTime = 0;
  int actionInterval = 500;

  BugSmashMicrogame(float x, float y, int w, int h) {
    super(x, y, w, h);
    this.sprites = new PImage[]{
      loadImage("sprites/microgames/bug.png"),
      loadImage("sprites/microgames/dead.png")
    };
    this.bugSize = (int) min(w, h) / 6;
    this.reset();
  }

  void update() {
    int now = millis();

    for (Bug bug : bugs) {
      bug.moveContinuously();
      this.constrainBug(bug);
    }

    if (now - lastActionTime > actionInterval) {
      lastActionTime = now;

      for (Bug bug : bugs) {
        if (random(1) > 0.80) {
          bug.rotate90Degrees();
        }
      }
    }
  }

  void constrainBug(Bug bug) {
    float minX = this.pos.x;
    float minY = this.pos.y;
    float maxX = this.pos.x + this.w - bug.w;
    float maxY = this.pos.y + this.h - bug.h;

    PVector direction = bug.directionVectors[bug.orientation];

    float nextX = bug.pos.x + direction.x * bug.continuousSpeed;
    float nextY = bug.pos.y + direction.y * bug.continuousSpeed;

    boolean hitWall = false;

    if (nextX < minX || nextX > maxX || nextY < minY || nextY > maxY) {
      hitWall = true;
    }

    bug.pos.x = constrain(bug.pos.x, minX, maxX);
    bug.pos.y = constrain(bug.pos.y, minY, maxY);

    if (hitWall) {
      bug.rotate90Degrees();
    }
  }

  void handleMouseClicked() {
    for (Bug b : this.bugs) {
      if (b.isOver() && b.status == 0) {
        b.status = 1;
        this.aliveBugs--;
      }
    }
  }

  void reset() {
    this.startms = millis();
    this.timeSpent = 0;
    this.aliveBugs = 5;

    for (int i = 0; i < bugs.length; i++) {
      float bx = random(this.pos.x, this.w + this.pos.x - this.bugSize);
      float by = random(this.pos.y, this.h + this.pos.y - this.bugSize);
      bugs[i] = new Bug(bx, by, this.bugSize, this.sprites);
    }
  }

  boolean shouldAddScore() {
    return this.aliveBugs == 0;
  }

  boolean isDone() {
    int now = millis();
    this.timeSpent = (now - this.startms) / 1000;

    return this.timeSpent > 5 || this.aliveBugs == 0;
  }

  void updatePositions(PVector newPosition) {
    PVector oldPos = this.pos.copy();
    this.pos = newPosition;
    PVector diff = PVector.sub(this.pos, oldPos);

    for (Bug bug : bugs) {
      bug.pos.add(diff);
    }
  }

  void draw() {
    this.update();

    fill(0);
    text("Tiempo: " + this.timeSpent + "s", this.pos.x, this.pos.y);
    for (Bug bug : bugs) {
      bug.draw();
    }
  }
}
