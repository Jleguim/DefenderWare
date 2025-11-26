String RUTA_DESCARGAS = "C:/.../downloads/",
  RUTA_PROGRAMAS86 = "C:/Program Files (x86)/.../",
  RUTA_PROGRAMAS = "C:/Program Files/.../";
Object[][] piscinaEventos = {
  {"Elevación de permisos", RUTA_DESCARGAS + "NetBeans.exe", 0},
  {"Elevación de permisos", RUTA_DESCARGAS + "r3spuest4sdelp4rcial.exe", 1},
};

class EventEntry extends GameElement {
  Object[] data;
  ImageElement actionBtn;
  AntivirusContent parent;
  int creationTime;

  EventEntry(float x, float y, int w, int h, Object[] eventData, AntivirusContent parent, PImage btnSprite) {
    super(x, y, w, h);
    this.data = eventData;
    this.parent = parent;

    this.creationTime = millis();

    int btnWidth = (int) this.parent.scaleX * 8;
    int btnHeight = (int) this.parent.scaleY * 2;
    this.actionBtn = new ImageElement(this.pos.x + (this.parent.scaleX * 54), this.pos.y, btnWidth, btnHeight, btnSprite);
  }

  void draw() {
    text((String) this.data[0], this.pos.x + (this.parent.scaleX * 2), this.pos.y);
    text((String) this.data[1], this.pos.x + (this.parent.scaleX * 30), this.pos.y);
    this.actionBtn.draw();
    text("Eliminar", this.actionBtn.pos.x + (this.parent.scaleX * 1.8), this.actionBtn.pos.y + (this.parent.scaleY * .3));
  }
}

class AntivirusContent extends WindowContent {
  PImage[] sprites;
  ImageElement bg;
  float scaleX, scaleY;
  ArrayList<EventEntry> events;

  AntivirusContent(float x, float y, int w, int h) {
    super(x, y, w, h);
    this.sprites = new PImage[]{
      loadImage("sprites/antivirus/detectionhistory.png"),
      loadImage("sprites/antivirus/btn.png")
    };
    this.events = new ArrayList<EventEntry>();
    this.bg = new ImageElement(this.pos.x, this.pos.y, this.w, this.h, this.sprites[0]);
    this.calculatePixelSize();
  }

  void updatePositions(PVector newPosition) {
    PVector oldPos = this.pos.copy();
    this.pos = newPosition;
    PVector diff = PVector.sub(this.pos, oldPos);

    this.bg.pos.add(diff);

    for (EventEntry e : events) {
      e.pos.add(diff);
      e.actionBtn.pos.add(diff);
    }
  }

  void calculatePixelSize() {
    this.scaleX = this.w / this.sprites[0].width;
    this.scaleY = this.h / this.sprites[0].height;
  }

  void handleMouseClicked() {
    for (int i = this.events.size() - 1; i >= 0; i--) {
      EventEntry e = this.events.get(i);
      if (e.actionBtn.isOver()) {
        this.events.remove(i);
        this.repositionEvents();
        if ((int) e.data[2] == 1) {
          playerScore += 3;
        } else {
          lives--;
        }
        break;
      }
    }
  }

  float spawnRate = 0.9;
  int spawnTime = 5;
  int lastSpawnTime = 0;
  void update() {
    int now = millis();
    int timeSpent = (now - this.lastSpawnTime) / 1000;

    if (random(1) > spawnRate && this.events.size() < 10 && timeSpent >= spawnTime) {
      lastSpawnTime = millis();
      Object[] ranData = piscinaEventos[(int) random(0, piscinaEventos.length)];
      EventEntry e = new EventEntry(this.pos.x + (this.scaleX * 2), 0, 62*(int)this.scaleX, 2 * (int)this.scaleY, ranData, this, this.sprites[1]);
      this.events.add(e);
      this.repositionEvents();
    }

    for (int i = this.events.size() - 1; i >= 0; i--) {
      EventEntry e = this.events.get(i);
      long elapsedTime = (now - e.creationTime) / 1000;
      if (elapsedTime >= 10) {
        if ((int) e.data[2] == 1) {
          lives--;
        }
        this.events.remove(i);
        this.repositionEvents();
        break;
      }
    }
  }

  void repositionEvents() {
    float yStep = this.scaleY * 4;
    float colNamesY = this.pos.y + (this.scaleY * 9);

    for (int i = 0; i < this.events.size(); i++) {
      EventEntry e = this.events.get(i);
      float newY = colNamesY + (yStep * (i + 1));
      e.pos.y = newY;
      float newX = this.pos.x + (this.scaleX * 2);
      e.pos.x = newX;
      float btnX = e.pos.x + (this.scaleX * 54);
      e.actionBtn.pos.set(btnX, newY);
    }
  }

  void draw() {
    this.bg.draw();

    float colNamesY = this.pos.y + (this.scaleY * 9);
    float eventX = this.pos.x + (this.scaleX * 4);
    float locX = this.pos.x + (this.scaleX * 32);
    float actX = this.pos.x + (this.scaleX * 56);

    fill(255);
    textSize(32);
    text("Historial de Deteccion", this.pos.x + (this.scaleX * 2), this.pos.y + (this.scaleY * 2));
    textSize(24);
    text("Evento", eventX, colNamesY);
    text("Ruta", locX, colNamesY);
    text("Accion", actX, colNamesY);

    textSize(16);
    for (EventEntry e : events) {
      e.draw();
    }
  }
}
