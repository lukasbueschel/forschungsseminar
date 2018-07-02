class Rect implements Displayable {
  private final static color COLOR_LINE = #ffffff;

  public final static int TYPE_RECT = 0;
  public final static int TYPE_TRI_1 = 1;
  public final static int TYPE_TRI_2 = 2;

  public final static int LEFT = 0;
  public final static int BOTTOM = 1;
  public final static int RIGHT = 2;
  public final static int TOP = 3;
  public final static int LINE_TRI_1 = 4;
  public final static int LINE_TRI_2 = 5;

  private boolean displayEnabled = true;
  private boolean displayFill = true;
  public int type = 0;

  private PVector pos;
  private PVector dir;

  private color color1 = #ffffff;
  private color color2 = #ffffff;

  private int size;

  private HashMap<Integer, Line> lines = new HashMap<Integer, Line>();

  public Rect(PVector pos, PVector dir, int size) {
    this.pos = pos;
    this.dir = dir;
    this.size = size;
  }

  public Rect(float px, float py, float pz, float dx, float dy, float dz, int size) {
    pos = new PVector(px, py, pz);
    dir = new PVector(dx, dy, dz);
    this.size = size;
  }

  public void setDisplayEnabled(boolean d) {
    displayEnabled = d;
  }

  public void setDisplayFill(boolean f) {
    displayFill = f;
  }

  public void setType(int t) {
    type = t;
    if (t == TYPE_TRI_1) {
      lines.remove(LINE_TRI_1);
    } else if (t == TYPE_TRI_2) {
      lines.remove(LINE_TRI_2);
    }
  }
  
  public int getType() {
    return type;
  }

  public void setColor(color c) {
    setColor(c, c);
  }

  public void setColor(color c1, color c2) {
    color1 = c1;
    color2 = c2;
  }

  public void display() {
    if (!displayEnabled) {
      return;
    }
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    if (dir.z == 0) {
      if (dir.x == -1) {
        rotateY(PI);
      }
      if (dir.y == -1) {
        rotateX(PI);
      }
    } else if (dir.y == 0) {
      rotateX(PI/2);
      if (dir.x == -1) {
        rotateY(PI);
      }
      if (dir.z == -1) {
        rotateX(PI);
      }
    } else {
      rotateY(-PI/2);
      if (dir.y == -1) {
        rotateX(PI);
      }
      if (dir.z == -1) {
        rotateY(PI);
      }
    }
    strokeWeight(0);
    if (displayFill) {
      switch(type) {
      case TYPE_RECT:
        fill(color1);
        beginShape();
        vertex(0, 0, 0);
        vertex(0, size, 0);
        vertex(size, size, 0);
        vertex(size, 0, 0);
        endShape(CLOSE);
        break;
      case TYPE_TRI_1:
        fill(color1);
        beginShape();
        vertex(0, 0, 0);
        vertex(0, size, 0);
        vertex(size, size, 0);
        endShape(CLOSE);
        fill(color2);
        beginShape();
        vertex(0, 0, 0);
        vertex(size, size, 0);
        vertex(size, 0, 0);
        endShape(CLOSE);
        break;
      case TYPE_TRI_2:
        fill(color1);
        beginShape();
        vertex(0, 0, 0);
        vertex(0, size, 0);
        vertex(size, 0, 0);
        endShape(CLOSE);
        fill(color2);
        beginShape();
        vertex(0, size, 0);
        vertex(size, size, 0);
        vertex(size, 0, 0);
        endShape(CLOSE);
        break;
      }
    }
    for (Line line : lines.values()) {
      line.display();
    }
    popMatrix();
  }

  public Line setLine(int i, color c) {
    float x = 0, y = 0, z = 0;
    float dx = 0, dy = 0, dz = 0;
    switch(i) {
    case LEFT:
      dy = size;
      break;
    case BOTTOM:
      y = size;
      dx = size;
      break;
    case RIGHT:
      x = size;
      y = size;
      dy = -size;
      break;
    case TOP:
      x = size;
      dx = -size;
      break;
    case LINE_TRI_1:
      dx = size;
      dy = size;
      break;
    case LINE_TRI_2:
      y = size;
      dx = size;
      dy = -size;
      break;
    }
    Line line = new Line(x, y, z, dx, dy, dz, c);
    lines.put(i, line);
    return line;
  }

  public Line getLine(int i) {
    Line line = lines.get(i);
    if (line == null) {
      line = setLine(i, COLOR_LINE);
    }
    return line;
  }
  
  public ArrayList<Line> getLines() {
    return new ArrayList<Line>(lines.values());
  }
  
  public void removeLine(int i) {
    lines.remove(i);
  }

  public void setLinesColor(color c) {
    for (int i = 0; i < 4; i++) {
      setLine(i, c);
    }
    if (type == TYPE_TRI_1) {
      setLine(LINE_TRI_1, c);
    } else if (type == TYPE_TRI_2) {
      setLine(LINE_TRI_2, c);
    }
  }
}
