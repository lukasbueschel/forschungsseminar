class Line implements Displayable {
  private final static int WIDTH = 3;
  private final static color COLOR = #ffffff;

  private boolean displayEnabled = true;
  private PVector pos, dim;
  private color c = COLOR;
  private int w = WIDTH;

  public Line(PVector p, PVector d) {
    pos = p;
    dim = d;
  }

  public Line(float x, float y, float z, float dx, float dy, float dz) {
    this(new PVector(x, y, z), new PVector(dx, dy, dz));
  }

  public Line(float x, float y, float z, float dx, float dy, float dz, color c) {
    this(x, y, z, dx, dy, dz);
    setColor(c);
  }

  void setColor(color c) {
    this.c = c;
  }
  
  public color getColor() {
    return c;
  }

  void setWidth(int w) {
    this.w = w;
  }

  void setDisplayEnabled(boolean d) {
    displayEnabled = d;
  }

  void display() {
    if (!displayEnabled) {
      return;
    }
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    if (currentFrame != -1) {
      c = lerpColor(from, to, (float)(duration - currentFrame) / duration);
      currentFrame--;
    }
    stroke(c);
    strokeWeight(w);
    beginShape(LINES);
    vertex(0, 0, 0);
    vertex(dim.x, dim.y, dim.z);
    endShape();
    popMatrix();
  }

  public float getAlpha() {
    return alpha(c);
  }

  private float alphaStart, alphaStep;
  private int duration;
  private int currentFrame = -1;
  private color from, to;

  public void animateAlpha(color c, float start, float end, int duration) {
    alphaStart = start;
    alphaStep = (end - start) / duration;
    currentFrame = duration;
  }

  public void animateColor(color from, color to, int duration) {
    this.duration = duration;
    this.from = from;
    this.to = to;
    currentFrame = duration;
  }
}
