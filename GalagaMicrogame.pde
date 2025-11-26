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
  int amtnGroups = 5;

  EnemyGroup[] enemyGroups = new EnemyGroup[amtnGroups];
  ArrayList<ImageElement> projectiles = new ArrayList<ImageElement>();

  int startms, timeSpent;

  int enemyCount = amntPerGroup * amtnGroups;
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
    this.enemyCount = amntPerGroup * amtnGroups;

    for (int i = 0; i < enemyGroups.length; i++) {
      float gx = random(this.pos.x, this.w + this.pos.x - this.spriteSize);
      float gy = random(this.pos.y, this.h + this.pos.y - (this.spriteSize*3));
      enemyGroups[i] = new EnemyGroup(gx, gy, 2*this.spriteSize, this.spriteSize, this.amntPerGroup, this.sprites[1], this);
    }
  }

  void update() {
    float constrainedX = constrain(mouseX, this.pos.x, this.pos.x + this.w - this.ship.w);
    float constrainedY = constrain(mouseY, this.pos.y + this.h - this.ship.h, this.pos.y + this.h - this.ship.h);
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
    return this.shipDestroyed == false || this.enemyCount == 0;
  }

  boolean isDone() {
    int now = millis();
    this.timeSpent = (now - this.startms) / 1000;

    return this.timeSpent > 5 || this.shipDestroyed || this.enemyCount == 0;
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
      for (EnemyGroup g : this.enemyGroups) {
        if (g.enemies.isEmpty()) continue;
        for (int eIndex = g.enemies.size() - 1; eIndex >= 0; eIndex--) {
          ImageElement enemy = g.enemies.get(eIndex);
          if (projectile.isColliding(enemy)) {
            g.enemies.remove(eIndex);
            this.projectiles.remove(pIndex);
            this.enemyCount--;
            break;
          }
        }
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
