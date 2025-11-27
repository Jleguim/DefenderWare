CursorElement customCursor;
int playerScore = 0;
int lives = 3;

class DefenderWareGame {
  PFont typography;
  ImageElement bg;
  ImageElement tb;

  AppElement[] apps;
  WindowElement frontWindow;

  PImage heart;

  int startTime;
  int gameplayTime = 1 * 60 * 1000;

  DefenderWareGame() {
    smooth(8);
    frameRate(144);

    typography = createFont("5mikropix.ttf", 128);
    heart = loadImage("/sprites/heart.png");

    customCursor = new CursorElement();
    bg = new ImageElement(0, 0, width, height, "/sprites/wallpaper.png");

    apps = new AppElement[]{
      new AppElement(0, 0, CHROME_SPRITE_FILE),
      new AppElement(0, 0, ANTIVIRUS_SPRITE_FILE),
    };

    float appsY = height-(apps[0].w);
    for (int i = 0; i < apps.length; i++) {
      AppElement app = apps[i];
      app.pos.set(i*(app.w), appsY);
    }

    apps[0].win = new WindowElement(0, 0, .8, 0.8);
    WindowElement chromeWindow = apps[0].win;
    chromeWindow.addContent(new BugSmashMicrogame(chromeWindow.contentPos.x,
      chromeWindow.contentPos.y,
      WIN_CONTENT_WIDTH * (int) chromeWindow.scaleX,
      WIN_CONTENT_HEIGHT * (int) chromeWindow.scaleY));
    chromeWindow.addContent(new DownloadMicrogame(chromeWindow.contentPos.x,
      chromeWindow.contentPos.y,
      WIN_CONTENT_WIDTH * (int) chromeWindow.scaleX,
      WIN_CONTENT_HEIGHT * (int) chromeWindow.scaleY));
    chromeWindow.addContent(new GalagaMicrogame(chromeWindow.contentPos.x,
      chromeWindow.contentPos.y,
      WIN_CONTENT_WIDTH * (int) chromeWindow.scaleX,
      WIN_CONTENT_HEIGHT * (int) chromeWindow.scaleY));
    chromeWindow.addContent(new FileExplorerMicrogame(chromeWindow.contentPos.x,
      chromeWindow.contentPos.y,
      WIN_CONTENT_WIDTH * (int) chromeWindow.scaleX,
      WIN_CONTENT_HEIGHT * (int) chromeWindow.scaleY));
    chromeWindow.addContent(new SearchMicrogame(chromeWindow.contentPos.x,
      chromeWindow.contentPos.y,
      WIN_CONTENT_WIDTH * (int) chromeWindow.scaleX,
      WIN_CONTENT_HEIGHT * (int) chromeWindow.scaleY));
    chromeWindow.addContent(new CodeMicroGame(chromeWindow.contentPos.x,
      chromeWindow.contentPos.y,
      WIN_CONTENT_WIDTH * (int) chromeWindow.scaleX,
      WIN_CONTENT_HEIGHT * (int) chromeWindow.scaleY));

    apps[1].win = new WindowElement(0, 0, 1.5, 1);
    WindowElement antivirusWindow = apps[1].win;
    antivirusWindow.addContent(new AntivirusContent(antivirusWindow.contentPos.x,
      antivirusWindow.contentPos.y,
      WIN_CONTENT_WIDTH * (int) antivirusWindow.scaleX,
      WIN_CONTENT_HEIGHT * (int) antivirusWindow.scaleY));
  }

  void start() {
    if (startTime == 0) {
      startTime = millis();
      playerScore = 0;
      lives = 3;
    }
  }

  void draw() {
    pushStyle();
    noCursor();
    textFont(typography);
    textSize(10);
    textAlign(LEFT, TOP);
    pushStyle();

    bg.draw();

    customCursor.update();
    AntivirusContent antivirus = (AntivirusContent) (apps[1].win.getCurrentContent());
    antivirus.update();

    for (AppElement app : apps) {
      if (app.win.isVisible) {
        if (app.win != frontWindow) {
          app.win.draw();
        }
      }
    }

    if (frontWindow != null) {
      frontWindow.draw();
    }

    for (AppElement app : apps) {
      app.draw();
    }

    fill(255);
    textSize(32);
    text("Puntos: " + playerScore + "   Tiempo restante (s): " + (gameplayTime-(millis() - startTime)) / 1000, 34*4, 0);
    for (int i = 0; i < lives; i++) {
      image(heart, 34*i, 0, 32, 32);
    }

    customCursor.draw();

    if (lives <= 0 || (gameplayTime-(millis() - startTime)) / 1000 <= 0) {
      playerScore = 0;
      lives = 3;
      startTime = 0;
      cursor();
    }
    popStyle();
  }

  void mouseClicked() {
    for (AppElement app : apps) {
      if (app.isOver()) {
        app.win.isVisible = !app.win.isVisible;
        app.win.getCurrentContent().reset();
        frontWindow = app.win;
      }
    }
  }

  void mousePressed() {
    if (frontWindow != null && frontWindow.isVisible) {
      if (frontWindow.isOver()) {
        frontWindow.handleMouseClicked();
        if (frontWindow.titleBar.isOver()) {
          frontWindow.handleMousePressed();
          return;
        }
        return;
      }
    }

    for (AppElement app : apps) {
      WindowElement currentWindow = app.win;
      if (currentWindow.isVisible) {

        if (currentWindow.titleBar.isOver()) {
          frontWindow = currentWindow;
          frontWindow.handleMousePressed();
          return;
        }

        if (currentWindow.isOver()) {
          frontWindow = currentWindow;
          currentWindow.handleMouseClicked();
          return;
        }
      }
    }
  }

  void mouseDragged() {
    for (AppElement app : apps) {
      app.win.handleMouseDragged();
    }
  }

  void mouseReleased() {
    for (AppElement app : apps) {
      app.win.handleMouseReleased();
    }
  }
}
