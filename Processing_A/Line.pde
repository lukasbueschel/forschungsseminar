class Line implements Displayable {
  private final static int WIDTH = 3;
  private final static color COLOR = #ffffff;

  private boolean displayEnabled = true;
  private PVector pos, dim;
  private color c = COLOR;
  private int w = WIDTH;

  private boolean animate = false;
  private LineAnimation animation = null;
  private int STEPS = 20;
  private PVector length;
  private int duration;
  private int currentFrame = -1;
  private color from, to;

  public Line(PVector p, PVector d) {
    pos = p;
    dim = d;
    length = new PVector(dim.x/STEPS, dim.y/STEPS, dim.z/STEPS);
  }

  public Line(float x, float y, float z, float dx, float dy, float dz) {
    this(new PVector(x, y, z), new PVector(dx, dy, dz));
  }

  public Line(float x, float y, float z, float dx, float dy, float dz, color c) {
    this(x, y, z, dx, dy, dz);
    setColor(c);
  }

  public void setColor(color c) {
    this.c = c;
  }

  public color getColor() {
    return c;
  }

  public float getAlpha() {
    return alpha(c);
  }

  public void setWidth(int w) {
    this.w = w;
  }

  public int getWidth() {
    return w;
  }

  public void setDisplayEnabled(boolean d) {
    displayEnabled = d;
  }

  private final PVector ZERO = new PVector(0, 0, 0);

  public void display() {
    if (!displayEnabled) {
      return;
    }
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    if (animate && currentFrame == duration) {
      animate = false;
      switch(animation) {
      case COLOR:
      case PROGRESS:
        c = to;
        break;
      case STAR:
      case GRADIENT:
        c = from;
        break;
      }
    }
    if (animate) {
      float progress = (float)currentFrame / duration;
      switch(animation) {
      case COLOR:
        c = lerpColor(from, to, progress);
        drawLine(ZERO, dim);
        break;
      case PROGRESS:
        PVector l = PVector.mult(dim, progress);
        c = to;
        drawLine(ZERO, l);
        translate(l.x, l.y, l.z);
        c = from;
        l = PVector.mult(dim, (1-progress));
        drawLine(ZERO, l);
        break;
      case STAR:
        float m = STEPS * progress;
        PVector temp = PVector.mult(length, m);
        translate(temp.x, temp.y, temp.z);
        c = to;
        drawLine(ZERO, length);
        break;
      case GRADIENT:
        for (int s = 0; s < STEPS; s++) {
          float shift = 1 - (progress * 2);
          float t = ((float)s+1) / STEPS;
          if (t + shift > 1) {
            c = from;
          } else {
            c = lerpColor(from, to, t + shift);
          }
          drawLine(ZERO, length);
          translate(length.x, length.y, length.z);
        }
        break;
      }
      currentFrame++;
    } else {
      drawLine(ZERO, dim);
    }
    popMatrix();
  }

  private void drawLine(PVector start, PVector end) {
    stroke(c);
    strokeWeight(w);
    beginShape(LINES);
    vertex(start.x, start.y, start.z);
    vertex(end.x, end.y, end.z);
    endShape();
  }

  public void animate(LineAnimation a, color from, color to, int d) {
    animation = a;
    duration = d;
    this.from = from;
    this.to = to;
    currentFrame = 0;
    animate = true;
  }
}

public enum LineAnimation {
  COLOR, PROGRESS, STAR, GRADIENT
}
