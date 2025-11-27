String[] fileNames = new String[]{
  "document.docx",
  "reporte.pdf",
  "data.xlsx",
  "photo_album.zip",
  "script.py",
  "style.css",
  "index.html",
  "config.json",
  "notes.txt",
  "backupr.gz",
  "cancion.mp3",
  "assets.dat",
  "logo_final.svg",
  "license.md",
  "todo.csv",
  "patches.log",
  "map_data.xml",
  "user_guide.rtf",
  "font_display.ttf",
  "icon_small.ico"
};

String[] exeNames = new String[]{
  "VBucksGen.exe",
  "System32Fix.exe",
  "keylogger.exe",
  "pwsdStealer.exe",
  "crackedSoftware.exe",
  "BackdoorServer.exe",
  "DiscordGrabber.exe",
  "Cryptocurrency_Miner.exe",
  "RegistryOptimizerPRO.exe",
  "Antivirus_Cracker.exe",
  "RobloxExploiter.exe",
  "SteamWalletGen.exe",
};

String[] dirNames = new String[]{
  "Documentos",
  "Aplicaciones",
  "Temporal",
  "Mis Proyectos",
  "Fotos de Viajes",
  "Trabajo",
  "Música",
  "Configuracion",
  "Clientes",
  "Scripts",
  "Datos",
  "Modelos 3D",
  "Archivos",
  "Videos de Clase",
  "Recursos",
  "Logs del Sistema",
  "Fuentes",
  "Biblioteca",
  "Backup",
  "Assets"
};

class FileExplorerMicrogame extends WindowContent {
  PImage[] sprites;
  float scaleX, scaleY;

  int startms, timeSpent;

  PVector filesPos;
  float filesWidth;
  float filesHeight;
  File[] files = new File[10];

  boolean foundVirus = false;
  FileExplorerMicrogame(float x, float y, int w, int h) {
    super(x, y, w, h);
    this.sprites = new PImage[]{
      loadImage("/sprites/microgames/explorer.png"),
      loadImage("sprites/microgames/file.png"),
      loadImage("sprites/microgames/exe.png"),
      loadImage("sprites/microgames/dir.png"),
    };
    this.calculatePixelSize();
    this.filesPos = new PVector(this.pos.x + (this.scaleX*16), this.pos.y + (this.scaleY*10));
    this.filesWidth = this.scaleX * 52;
    this.filesHeight = this.scaleY * 36;
    this.reset();
  }

  void updatePositions(PVector newPosition) {
    PVector oldPos = this.pos.copy();
    this.pos = newPosition;
    PVector diff = PVector.sub(this.pos, oldPos);

    this.filesPos.add(diff);
    for (File el : this.files) {
      el.pos.add(diff);
      el.image.pos.add(diff);
    }
  }

  void reset() {
    this.startms = millis();
    this.timeSpent = 0;
    this.foundVirus = false;

    for (int i = 0; i < this.files.length; i++) {
      PVector v = new PVector(random(this.filesPos.x, this.filesPos.x + this.filesWidth - (int)this.scaleX * 8), random(this.filesPos.y, this.filesPos.y + this.filesHeight - (int)this.scaleY*8));
      this.files[i] = new File(v.x, v.y, (int)this.scaleX * 8, (int)this.scaleY*8, this.sprites[1], fileNames[(int)random(0, fileNames.length)]);

      if (i == this.files.length-1) {
        this.files[i].image.sprite = this.sprites[2];
        this.files[i].name = exeNames[(int)random(0, exeNames.length)];
        this.files[i].isMalicious = true;
      } else if (random(1) >= 0.8) {
        this.files[i].image.sprite = this.sprites[3];
        this.files[i].name = dirNames[(int)random(0, dirNames.length)];
      }
    }
  }

  boolean isDone() {
    int now = millis();
    this.timeSpent = (now - this.startms) / 1000;

    return this.timeSpent > 5 || this.foundVirus;
  }

  void handleMouseClicked() {
    for (File file : files) {
      if (file.isOver() && file.isMalicious) {
        this.foundVirus = true;
      }
    }
  }

  boolean shouldAddScore() {
    return this.foundVirus;
  }

  void calculatePixelSize() {
    this.scaleX = this.w / this.sprites[0].width;
    this.scaleY = this.h / this.sprites[0].height;
  }

  void draw() {
    image(this.sprites[0], this.pos.x, this.pos.y, this.w, this.h);

    for (File el : this.files) {
      el.draw();
    }

    fill(0);
    textSize(10);
    text("Tiempo: " + this.timeSpent + "s", this.pos.x, this.pos.y);
  }
}

class File extends GameElement {
  ImageElement image;
  String name = "file";
  Boolean isMalicious = false;
  File(float x, float y, int w, int h, PImage sprite, String name) {
    super(x, y, w, h + 15);
    this.image = new ImageElement(this.pos.x, this.pos.y, w, h, sprite);
    this.name = name;
  }

  void draw() {
    this.image.draw();
    fill(0, 0, 0, 80);
    noStroke();
    rect(this.pos.x, this.pos.y + this.image.h + 2, this.w, 10);
    fill(255);
    textSize(8);
    textAlign(CENTER);
    text(this.name, this.pos.x + (this.w/2), this.pos.y + this.image.h + 10, this.w);
    textAlign(LEFT, TOP);
  }
}
