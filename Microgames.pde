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

class EnemyGroup extends GameElement {
  ArrayList<ImageElement> enemies;
  PImage sprite;
  GalagaMicrogame parent;

  boolean boundaryHit = false;
  int moveDirection = -1;
  float groupSpeed = 1.5, descentStep;

  EnemyGroup(float x, float y, int w, int h, int amnt, PImage sprite, GalagaMicrogame parent) {
    super(x, y, w, h);
    this.sprite = sprite;
    this.enemies = new ArrayList<ImageElement>();
    this.parent = parent;

    int spriteSize = w/amnt;
    this.descentStep = spriteSize*0.5;

    for (int i = 0; i < amnt; i++) {
      this.enemies.add(new ImageElement(x + (i * spriteSize), y, spriteSize, this.sprite));
    }
  }

  void update() {
    if (this.enemies.isEmpty()) return;

    boolean boundaryHit = false;

    float minX = parent.pos.x;
    float maxX = parent.pos.x + parent.w;

    ImageElement first = enemies.get(0);
    ImageElement last = enemies.get(enemies.size() - 1);

    float shiftX = groupSpeed * moveDirection;
    PVector horizontalShift = new PVector(shiftX, 0);

    for (ImageElement e : enemies) {
      e.pos.add(horizontalShift);
    }

    if (!boundaryHit) {
      if (moveDirection == -1 && first.pos.x <= minX) {
        boundaryHit = true;
      } else if (moveDirection == 1 && (last.pos.x + last.w) >= maxX) {
        boundaryHit = true;
      }
    }

    if (boundaryHit) {
      moveDirection *= -1;
      PVector verticalDescent = new PVector(0, descentStep);
      for (ImageElement e : enemies) {
        e.pos.add(verticalDescent);
      }
    }
  }

  void updatePositions(PVector diff) {
    this.pos.add(diff);
    for (ImageElement enemy : enemies) {
      enemy.pos.add(diff);
    }
  }

  void draw() {
    for (ImageElement enemy : enemies) {
      if (enemy.pos.y < parent.pos.y + parent.h - enemy.w - parent.ship.w) {
        enemy.draw();
      }
    }
  }
}

class GalagaMicrogame extends WindowContent {
  PImage[] sprites;
  ImageElement ship;
  int spriteSize;

  int amntPerGroup = 2;
  EnemyGroup[] enemyGroups = new EnemyGroup[5];
  ArrayList<ImageElement> projectiles = new ArrayList<ImageElement>();

  int startms, timeSpent;
  boolean shipDestroyed = false;

  GalagaMicrogame(float x, float y, int w, int h) {
    super(x, y, w, h);
    this.sprites = new PImage[]{
      loadImage("/sprites/microgames/galaga_ship.png"),
      loadImage("sprites/microgames/galaga_enemy1.png"),
      loadImage("sprites/microgames/galaga_enemy2.png"),
      loadImage("sprites/microgames/galaga_arrow.png")
    };
    this.spriteSize = min(w, h) / 8;
    this.ship = new ImageElement((this.pos.x + this.w) / 2, this.pos.y + this.h - spriteSize, spriteSize, this.sprites[0]);
    this.reset();
  }

  void reset() {
    this.startms = millis();
    this.timeSpent = 0;
    this.shipDestroyed = false;

    for (int i = 0; i < enemyGroups.length; i++) {
      float gx = random(this.pos.x, this.w + this.pos.x - this.spriteSize);
      float gy = random(this.pos.y, this.h + this.pos.y - (this.spriteSize*3));
      enemyGroups[i] = new EnemyGroup(gx, gy, 2*this.spriteSize, this.spriteSize, this.amntPerGroup, this.sprites[1], this);
    }
  }

  void update() {
    float constrainedX = constrain(mouseX, this.pos.x, this.pos.x + this.w - this.ship.w);
    float constrainedY = constrain(mouseY, this.pos.y, this.pos.y + this.h - this.ship.h);
    this.ship.pos.set(constrainedX, constrainedY);

    for (int i = this.projectiles.size() - 1; i >= 0; i--) {
      ImageElement p = this.projectiles.get(i);
      p.pos.add(0, p.scaleY * -2);
      if (p.pos.y < this.pos.y) {
        this.projectiles.remove(i);
      }
    }
  }

  void updatePositions(PVector newPosition) {
    PVector oldPos = this.pos.copy();
    this.pos = newPosition;
    PVector diff = PVector.sub(this.pos, oldPos);

    this.ship.pos.add(diff);

    for (EnemyGroup g : this.enemyGroups) {
      g.updatePositions(diff);
    }
  }

  void handleMouseClicked() {
    ImageElement proj = new ImageElement(this.ship.pos.x, this.ship.pos.y, 16, this.sprites[3]);
    this.projectiles.add(proj);
  }

  boolean shouldAddScore() {
    return !this.shipDestroyed;
  }

  boolean isDone() {
    int now = millis();
    this.timeSpent = (now - this.startms) / 1000;

    return this.timeSpent > 5 || this.shipDestroyed;
  }

  void draw() {
    if (this.isOver()) {
      customCursor.hide();
    }

    fill(0);
    rect(this.pos.x, this.pos.y, this.w, this.h);
    this.update();

    for (int pIndex = this.projectiles.size() - 1; pIndex >= 0; pIndex--) {
      ImageElement projectile = this.projectiles.get(pIndex);
      boolean projectileHit = false;

      for (EnemyGroup g : this.enemyGroups) {
        if (g.enemies.isEmpty()) continue;
        for (int eIndex = g.enemies.size() - 1; eIndex >= 0; eIndex--) {
          ImageElement enemy = g.enemies.get(eIndex);
          if (projectile.isColliding(enemy)) {
            g.enemies.remove(eIndex);
            projectileHit = true;
            break;
          }
        }
      }

      if (projectileHit) {
        this.projectiles.remove(pIndex);
      }
    }

    for (EnemyGroup g : this.enemyGroups) {
      g.update();
      g.draw();

      for (ImageElement e : g.enemies) {
        if (e.isColliding(this.ship)) {
          this.shipDestroyed = true;
        }
      }
    }

    for (ImageElement p : this.projectiles) {
      p.draw();
    }

    this.ship.draw();

    fill(255);
    textSize(10);
    text("Tiempo: " + this.timeSpent + "s", this.pos.x, this.pos.y);
  }
}
