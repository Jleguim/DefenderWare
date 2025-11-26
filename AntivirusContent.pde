String RUTA_DESCARGAS = "C:/.../downloads/",
  RUTA_PROGRAMAS86 = "C:/Program Files (x86)/.../",
  RUTA_PROGRAMAS = "C:/Program Files/.../",
  RUTA_NAVEGADOR = RUTA_PROGRAMAS86 + "msedge.exe";

Object[][] piscinaEventos = {
  {"[steem.com] Verifiacion de cuenta", RUTA_NAVEGADOR, 1},
  {"[uninorte.edu.co] Portal estudiantes", RUTA_NAVEGADOR, 0},
  {"Elevación de permisos", RUTA_DESCARGAS + "Apache-NetBeans-25-bin-windows-x64.exe", 0},
  {"Elevación de permisos", RUTA_DESCARGAS + "r3spuest4sdelp4rcial.exe", 1},
  {"[mail.google.com] Factura adjunta - Comprobante de pago", RUTA_DESCARGAS + "Factura_12345.pdf", 0},
  {"[mail.google.com] Factura adjunta - Contraseña: 1234", RUTA_DESCARGAS + "Factura_abril_2025.zip", 1},
  {"Elevación de permisos", RUTA_DESCARGAS + "r3spuest4sdelp4rcial.exe", 1},
  {"[bancoIombia.com] Cuenta de Banco comprometida", RUTA_NAVEGADOR, 1},
  {"[bancolombia.com] Inicio de sesión", RUTA_NAVEGADOR, 0},
  {"[mail.google.com] Boletín Cátedra Europa", RUTA_NAVEGADOR, 1},
  {"Actualización del sistema", RUTA_PROGRAMAS + "/Updater/updater.exe", 0},
  {"[intel.com] Descarga de Drivers", RUTA_DESCARGAS + "driver_intel_setup.exe", 0},
  {"[driversgratis.com] Drivers del Fabricante", RUTA_DESCARGAS + "drivers.zip", 1}
};

class AntivirusContent extends WindowContent {
  PImage[] sprites;
  ImageElement bg;
  // ImageElement logo;
  float scaleX, scaleY;

  AntivirusContent(float x, float y, int w, int h) {
    super(x, y, w, h);
    this.sprites = new PImage[]{
      loadImage("sprites/antivirus/detectionhistory.png"),
      // loadImage("sprites/antivirus/logoferia.png")
      loadImage("sprites/antivirus/btn.png")
    };

    this.bg = new ImageElement(this.pos.x, this.pos.y, this.w, this.h, this.sprites[0]);
    this.calculatePixelSize();
    // this.logo = new ImageElement(this.pos.x + (this.scaleX * 2), this.pos.y + (this.scaleY * 2), 20, 20, this.sprites[1]);
  }

  void updatePositions(PVector newPosition) {
    PVector oldPos = this.pos.copy();
    this.pos = newPosition;
    PVector diff = PVector.sub(this.pos, oldPos);

    this.bg.pos.add(diff);
    // this.logo.pos.add(diff);
  }

  void calculatePixelSize() {
    this.scaleX = this.w / this.sprites[0].width;
    this.scaleY = this.h / this.sprites[0].height;
  }

  void draw() {
    this.bg.draw();
    // this.logo.draw();

    fill(255);
    textSize(32);
    text("Historial de Deteccion", this.pos.x + (this.scaleX * 2), this.pos.y + (this.scaleY * 2));
    textSize(24);
    text("Evento", this.pos.x + (this.scaleX * 4), this.pos.y + (this.scaleY * 9));
    text("Ruta", this.pos.x + (this.scaleX * 32), this.pos.y + (this.scaleY * 9));
    text("Accion", this.pos.x + (this.scaleX * 56), this.pos.y + (this.scaleY * 9));

    textSize(16);
    text((String) piscinaEventos[7][0], this.pos.x + (this.scaleX * 4), this.pos.y + (this.scaleY * 13));
    text((String) piscinaEventos[7][1], this.pos.x + (this.scaleX * 32), this.pos.y + (this.scaleY * 13));

    image(this.sprites[1], this.pos.x + (this.scaleX * 56), this.pos.y + (this.scaleY * 13), this.scaleX * 8, this.scaleY * 2);
    text("Eliminar", this.pos.x + (this.scaleX * 57.8), this.pos.y + (this.scaleY * 13.3));
  }
}
