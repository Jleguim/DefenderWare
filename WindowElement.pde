int WIN_SPRITE_WIDTH = 64;
int WIN_SPRITE_HEIGHT = 48;
int WIN_SIZE_MULT = 10;

int WIN_TITLEBAR_HEIGHT = 4;
int WIN_BTN_SIZE = 2;
int WIN_BTNS_WIDTH_OFFSET = -7;

int WIN_CONTENT_WIDTH = 62;
int WIN_CONTENT_HEIGHT = 43;

String WIN_SPRITE_FILE = "/sprites/window.png";

class WindowElement extends ImageElement {
  GameElement minimizeButton, closeButton, titleBar;

  PVector contentPos;
  WindowContent[] contents = new WindowContent[]{};
  int currentContent = 0;

  boolean isDragging = false;
  boolean isVisible = false;

  PVector draggingOffset = new PVector(0, 0);

  WindowElement(float x, float y, float wmult, float hmult) {
    super(x, y, (int) (WIN_SPRITE_WIDTH*WIN_SIZE_MULT*wmult), (int) (WIN_SPRITE_HEIGHT*WIN_SIZE_MULT*hmult), WIN_SPRITE_FILE);

    float buttonsY = this.pos.y + this.scaleY;
    float buttonsX = this.pos.x + this.w + (this.scaleX * WIN_BTNS_WIDTH_OFFSET);
    this.minimizeButton = new GameElement(buttonsX, buttonsY, (int) this.scaleX * WIN_BTN_SIZE, (int) this.scaleY * WIN_BTN_SIZE);
    this.closeButton = new GameElement(buttonsX + (this.scaleX * WIN_BTN_SIZE), buttonsY, (int) this.scaleX * WIN_BTN_SIZE, (int) this.scaleY * WIN_BTN_SIZE);
    this.titleBar = new GameElement(this.pos.x, this.pos.y, this.w, (int) this.scaleY * WIN_TITLEBAR_HEIGHT);

    this.contentPos = new PVector(this.pos.x + this.scaleX, this.titleBar.pos.y + this.titleBar.h);
  }

  WindowElement(float x, float y) {
    super(x, y, WIN_SPRITE_WIDTH*WIN_SIZE_MULT, WIN_SPRITE_HEIGHT*WIN_SIZE_MULT, WIN_SPRITE_FILE);

    float buttonsY = this.pos.y + this.scaleY;
    float buttonsX = this.pos.x + this.w + (this.scaleX * WIN_BTNS_WIDTH_OFFSET);
    this.minimizeButton = new GameElement(buttonsX, buttonsY, (int) this.scaleX * WIN_BTN_SIZE, (int) this.scaleY * WIN_BTN_SIZE);
    this.closeButton = new GameElement(buttonsX + (this.scaleX * WIN_BTN_SIZE), buttonsY, (int) this.scaleX * WIN_BTN_SIZE, (int) this.scaleY * WIN_BTN_SIZE);
    this.titleBar = new GameElement(this.pos.x, this.pos.y, this.w, (int) this.scaleY * WIN_TITLEBAR_HEIGHT);

    this.contentPos = new PVector(this.pos.x + this.scaleX, this.titleBar.pos.y + this.titleBar.h);
  }

  void handleMouseClicked() {
    if (this.currentContent < this.contents.length) {
      this.getCurrentContent().handleMouseClicked();
    }

    if (this.minimizeButton.isOver() || this.closeButton.isOver()) {
      this.isVisible = false;
      this.getCurrentContent().reset();
    }
  }

  void handleMousePressed() {
    if (this.titleBar.isOver() && this.isVisible) {
      this.isDragging = true;
      this.draggingOffset.set(mouseX - this.pos.x, mouseY - this.pos.y);
    }
  }

  void handleMouseDragged() {
    if (this.isDragging && this.isVisible) {
      float restrictedMouseX = constrain(mouseX, 0, width);
      float restrictedMouseY = constrain(mouseY, 0, height);

      float nextX = restrictedMouseX - draggingOffset.x;
      float nextY = restrictedMouseY - draggingOffset.y;

      float MIN_VISIBLE_WIDTH = 30;
      float MIN_VISIBLE_HEIGHT = this.titleBar.h;

      float minLimitX = -(this.w - MIN_VISIBLE_WIDTH);
      float maxLimitX = width - MIN_VISIBLE_WIDTH;

      float minLimitY = 0;
      float maxLimitY = height - MIN_VISIBLE_HEIGHT;

      float constrainedX = constrain(nextX, minLimitX, maxLimitX);
      float constrainedY = constrain(nextY, minLimitY, maxLimitY);

      if (nextX != constrainedX) {
        this.draggingOffset.set(restrictedMouseX - constrainedX, this.draggingOffset.y);
      }

      if (nextY != constrainedY) {
        this.draggingOffset.set(this.draggingOffset.x, restrictedMouseY - constrainedY);
      }

      this.pos.set(constrainedX, constrainedY);

      this.updatePositions();
    }
  }

  void updatePositions() {
    float buttonsY = this.pos.y + this.scaleY;
    float buttonsX = this.pos.x + this.w + (this.scaleX * WIN_BTNS_WIDTH_OFFSET);

    this.minimizeButton.pos.set(buttonsX, buttonsY);
    this.closeButton.pos.set(buttonsX + (this.scaleX * WIN_BTN_SIZE), buttonsY);
    this.titleBar.pos.set(this.pos.x, this.pos.y);

    for (WindowContent content : contents) {
      PVector newPosition = new PVector(this.pos.x + this.scaleX, this.titleBar.pos.y + this.titleBar.h);
      content.updatePositions(newPosition);
    }
  }

  void handleMouseReleased() {
    this.isDragging = false;
  }

  void draw() {
    if (this.isVisible) {
      image(this.sprite, this.pos.x, this.pos.y, this.w, this.h);
      if (this.currentContent < this.contents.length) {
        WindowContent content = this.getCurrentContent();
        content.draw();

        if (content.isDone()) {
          if (content.shouldAddScore()) {
            playerScore += content.score;
          }
          this.advanceToNextContent();
        }
      }
    }
  }

  void advanceToNextContent() {
    this.currentContent++;

    if (this.currentContent >= this.contents.length) {
      this.currentContent = 0;
    }

    WindowContent content = this.getCurrentContent();
    content.reset();

    this.updatePositions();
    println("Advanced to Microgame: " + currentContent);
  }

  WindowContent getCurrentContent() {
    return this.contents[this.currentContent];
  }

  void addContent(WindowContent content) {
    content.pos.set(this.contentPos);
    content.w = WIN_CONTENT_WIDTH * (int) this.scaleX;
    content.h = WIN_CONTENT_HEIGHT * (int) this.scaleY;

    int size = this.contents.length;
    WindowContent[] old = this.contents.clone();
    this.contents = new WindowContent[size+1];
    for (int i = 0; i < size; i++) {
      this.contents[i] = old[i];
    }
    this.contents[size] = content;
  }

  void createContentWindow() {
    WindowContent content = new WindowContent(this.contentPos.x, this.contentPos.y, WIN_CONTENT_WIDTH * (int) this.scaleX, WIN_CONTENT_HEIGHT * (int) this.scaleY);
    int size = this.contents.length;
    WindowContent[] old = this.contents.clone();
    this.contents = new WindowContent[size+1];
    for (int i = 0; i < size; i++) {
      this.contents[i] = old[i];
    }
    this.contents[size] = content;
  }
}

class WindowContent extends GameElement {
  int score = 5;
  WindowContent(float x, float y, int w, int h) {
    super(x, y, w, h);
  }

  void draw() {
  }

  void reset() {
  }

  boolean isDone() {
    return false;
  }

  boolean shouldAddScore() {
    return false;
  }

  void updatePositions(PVector newPosition) {
  }

  void handleMouseClicked() {
  }
}
