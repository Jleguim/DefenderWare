PFont typography;
CursorElement customCursor;
ImageElement bg;
ImageElement tb;

AppElement[] apps;
WindowElement frontWindow;

void setup() {
  size(1280, 800);
  smooth(8);
  frameRate(144);

  typography = createFont("5mikropix.ttf", 128);

  customCursor = new CursorElement();
  bg = new ImageElement(0, 0, width, height, "/sprites/wallpaper.png");
  // tb = new ImageElement(0, 0, width, height, "/sprites/taskbar.png");

  apps = new AppElement[]{
    new AppElement(0, 0, CHROME_SPRITE_FILE),
    new AppElement(0, 0, ANTIVIRUS_SPRITE_FILE),
  };

  float appsY = height-(apps[0].w);
  for (int i = 0; i < apps.length; i++) {
    AppElement app = apps[i];
    app.pos.set(i*(app.w), appsY);
  }

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

  apps[1].win = new WindowElement(0, 0, 1.5);
  WindowElement antivirusWindow = apps[1].win;
  antivirusWindow.addContent(new AntivirusContent(antivirusWindow.contentPos.x,
    antivirusWindow.contentPos.y,
    WIN_CONTENT_WIDTH * (int) antivirusWindow.scaleX,
    WIN_CONTENT_HEIGHT * (int) antivirusWindow.scaleY));
}

void draw() {
  noCursor();
  textFont(typography);
  textSize(10);
  textAlign(LEFT, TOP);

  bg.draw();

  customCursor.update();

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

  customCursor.draw();
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
