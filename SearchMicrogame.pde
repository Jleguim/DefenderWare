Object[][][] searchPool = new Object[][][]{
  {
    { "Banco" },
    { "Banco de la República", "bancorepubli.co", 1 },
    { "Bancolombia Personas", "bancolombia.com", 0 },
    { "Mi banco - Acceso Rápido", "mibanco.xyz", 1 },
    { "Banco de la República: Principal", "banrep.gov.co", 0 },
    { "Bancos en Colombia", "banco-lista.org", 1 },
    { "Acceso a sucursal virtual", "bancolombia.com.co/acceso", 0 },
    { "[AD] BancoYa tu Crédito", "bancoya.ru", 1 },
    { "Simulador de Créditos", "simulador.finanzasc.com", 1 },
  },
  {
    { "PC Gamer" },
    { "PC Gaming: Amazon", "amazon.com", 0 },
    { "PC Gamer R7 5700g 32GB RAM", "armazon.com", 1 },
    { "Ofertas PC Gaming", "mercadolibre.com.co", 0 },
    { "[AD] PC Barata", "temu.com", 0 },
    { "Arma tu PC Online", "pc-gamer-personalizada.net", 1 },
    { "Guía de Componentes", "pc-hardware.info", 1 },
    { "Nuevos Modelos ASUS", "asus.com/gaming", 0 },
    { "PC Gamer", "pc-gamer-gratis.xyz", 1 },
  },
  {
    { "Uninorte" },
    { "Universidad del Norte", "uninorte.edu.co", 0 },
    { "Matrículas Abiertas", "unisur.co", 1 },
    { "Ingresa a tu portal", "unimorte.com", 1 },
    { "Portal de Estudiantes", "portalestudiantes.uninorte.edu.co", 0 },
    { "Becas y Ayudas", "unicorte.xyz", 1 },
    { "Facultad de Ingeniería", "ingenieria.uninorte.edu.co", 0 },
    { "Inscripciones 2025", "ingreso-uninorte.net", 1 },
    { "Wikipedia: Universidad del Norte (Colombia)", "es.wikipedia.org", 0 },
  },
  {
    { "Microsoft Teams" },
    { "Microsoft Teams | Colaboración y reunión...", "microsoft.com/es-es/microsoft-teams", 0 },
    { "[AD] Instalar Teams ahora", "download-teams-official.site", 1 },
    { "Teams App Store", "teams.microsoft.com/downloads", 0 },
    { "Descarga Teams GRATIS", "microsoft-teams.net", 1 },
    { "Soporte y Ayuda", "support.microsoft.com/teams", 0 },
    { "Microsoft 365 Login", "login.microsoftonline.com", 0 },
    { "Teams para Windows", "get-teams-online.info", 1 },
    { "Actualización urgente de Teams", "teams-security-patch.ru", 1 },
  },
  {
    { "Instagram Login" },
    { "Instagram", "instagram.com/login", 0 },
    { "Iniciar Sesión Rápido", "instagraam.com", 1 },
    { "Recuperar Contraseña", "help.instagram.com", 0 },
    { "[AD] Inicia Sesión Ahora", "insta-login.net", 1 },
    { "Instagram Iniciar Sesión", "login-instagram-web.xyz", 1 },
    { "Instagram Web Login", "web.instagram.com", 0 },
    { "Instagram (Sitio Oficial)", "about.instagram.com", 0 },
    { "Servicio al Cliente", "instagram-servicio.info", 1 },
  },
  {
    { "TikTok" },
    { "TikTok - Make Your Day", "tiktok.com", 0 },
    { "Ver TikToks sin cuenta", "tiktok-viewer.ru", 1 },
    { "[AD] Descargar TikTok", "tiktok-app-gratis.xyz", 1 },
    { "Iniciar sesión o registrarse", "www.tiktok.com/login", 0 },
    { "TikTok Live Studio", "studio.tiktok.com", 0 },
    { "TikTok Web Login", "tiktok.net.co", 1 },
    { "TikTok para Empresas", "business.tiktok.com", 0 },
    { "TikTok Account Recovery", "tiktok-recuperacion.org", 1 },
  }
};

class SearchMicrogame extends WindowContent {
  PImage[] sprites;
  float scaleX, scaleY;
  int startms, timeSpent;
  Result[] results = new Result[6];
  String currentSearchQuery;

  SearchMicrogame(float x, float y, int w, int h) {
    super(x, y, w, h);
    this.sprites = new PImage[]{
      loadImage("/sprites/microgames/search.png"),
      loadImage("/sprites/microgames/www.png")
    };
    this.calculatePixelSize();
    this.reset();
  }

  void updatePositions(PVector newPosition) {
    PVector oldPos = this.pos.copy();
    this.pos = newPosition;
    PVector diff = PVector.sub(this.pos, oldPos);

    for (Result r : this.results) {
      r.pos.add(diff);
      r.image.pos.add(diff);
    }
  }

  void reset() {
    Object[][] currentResults = searchPool[(int) random(0, searchPool.length)];
    this.currentSearchQuery = (String) currentResults[0][0];
    this.startms = millis();
    this.timeSpent = 0;
    this.madeDecision = false;
    this.isRightDecision = false;

    for (int i = 0; i < this.results.length; i++) {
      Object[] data = currentResults[i+1];
      this.results[i] = new Result(this.pos.x+(this.scaleX*4), (this.pos.y+(this.scaleY*10)) + (i*this.scaleY*6), (int)(this.w - (this.scaleX*12)), 32, this.sprites[1], (String)data[0], (String)data[1], this);
      if ((int)data[2] == 1) {
        this.results[i].isMalicious = true;
      }
    }
  }

  boolean isDone() {
    int now = millis();
    this.timeSpent = (now - this.startms) / 1000;

    return this.timeSpent > 5 || this.madeDecision;
  }

  boolean madeDecision = false;
  boolean isRightDecision = false;
  void handleMouseClicked() {
    for (Result r : this.results) {
      if (r.isOver()) {
        this.madeDecision = true;
        if (!r.isMalicious) {
          this.isRightDecision = true;
        }
        break;
      }
    }
  }

  boolean shouldAddScore() {
    return madeDecision && isRightDecision;
  }

  void calculatePixelSize() {
    this.scaleX = this.w / this.sprites[0].width;
    this.scaleY = this.h / this.sprites[0].height;
  }

  void draw() {
    image(this.sprites[0], this.pos.x, this.pos.y, this.w, this.h);
    textSize(16);
    text(this.currentSearchQuery, this.pos.x+(this.scaleX*28), this.pos.y+(this.scaleY*4));

    for (Result r : this.results) {
      r.draw();
    }

    fill(0);
    textSize(10);
    text("Tiempo: " + this.timeSpent + "s", this.pos.x, this.pos.y);
  }
}

class Result extends GameElement {
  ImageElement image;
  String name, url;
  SearchMicrogame parent;
  boolean isMalicious = false;
  Result(float x, float y, int w, int h, PImage sprite, String name, String url, SearchMicrogame parent) {
    super(x, y, w, h);
    this.image = new ImageElement(this.pos.x, this.pos.y, 12, 12, sprite);
    this.name = name;
    this.url = url;
    this.parent = parent;
  }

  void draw() {
    fill(0);
    this.image.draw();
    textSize(16);
    text(this.url, this.pos.x + this.image.w + this.parent.scaleX, this.pos.y);
    fill(19, 113, 172);
    textSize(18);
    text(this.name, this.pos.x, this.pos.y+(this.parent.scaleY*2));
  }
}
