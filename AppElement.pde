int APP_SPRITE_SIZE = 16;
int APP_SPRITE_MULT = 4;

String CHROME_SPRITE_FILE = "/sprites/chrome.png";
String ANTIVIRUS_SPRITE_FILE = "/sprites/antivirus.png";
String TASKMGR_SPRITE_FILE = "/sprites/taskmanager.png";

class AppElement extends ImageElement {
  WindowElement win;
  AppElement(float x, float y, String spriteFile) {
    super(x, y, APP_SPRITE_SIZE*APP_SPRITE_MULT, spriteFile);
    this.win = new WindowElement(0, 0);
  }
}
