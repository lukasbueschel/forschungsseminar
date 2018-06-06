class Cube {

  int x, y, z, size;
  ArrayList<Rect> rects = new ArrayList<Rect>();
  ArrayList<Line> lines = new ArrayList<Line>();

  Cube(int posX, int posY, int posZ, int size) {
    this.x = posX - size / 2;
    this.y = posY - size / 2;
    this.z = posZ + size / 2;
    this.size = size;

    rects.add(new Rect(x, y, z, 0, 0, 0));
    rects.add(new Rect(x + size, y, z - size, 0, PI, 0));
    rects.add(new Rect(x, y, z - size, 0, -PI/2, 0));
    rects.add(new Rect(x + size, y, z, 0, PI/2, 0));
    rects.add(new Rect(x, y, z - size, PI/2, 0, 0));
    rects.add(new Rect(x + size, y + size, z - size, PI/2, PI, 0));

    lines.add(new Line(x, y, z, x, y + size, z));
    lines.add(new Line(x, y + size, z, x + size, y + size, z));
    lines.add(new Line(x + size, y + size, z, x + size, y, z));
    lines.add(new Line(x + size, y, z, x, y, z));
    lines.add(new Line(x + size, y, z - size, x + size, y + size, z - size));
    lines.add(new Line(x + size, y + size, z - size, x, y + size, z - size));
    lines.add(new Line(x, y + size, z - size, x, y, z - size));
    lines.add(new Line(x, y, z - size, x + size, y, z - size));
    lines.add(new Line(x, y, z - size, x, y, z));
    lines.add(new Line(x + size, y, z, x + size, y, z - size));
    lines.add(new Line(x + size, y + size, z - size, x + size, y + size, z));
    lines.add(new Line(x, y + size, z, x, y + size, z - size));
  }

  Line getLine(int rectId, int lineId) {
    int id = -1;
    switch (rectId) {
    case Rect.FRONT: 
      {
        id = lineId;
        break;
      }
    case Rect.BACK: 
      {
        id = lineId + 4;
        break;
      }
    case Rect.LEFT: 
      {
        switch (lineId) {
        case Line.LEFT:
          id = 7;
          break;
        case Line.BOTTOM:
          id = 12;
          break;
        case Line.RIGHT:
          id = 8;
          break;
        case Line.TOP:
          id = 9;
          break;
        }
        break;
      }
    case Rect.RIGHT: 
      {
        switch (lineId) {
        case Line.LEFT:
          id = 2;
          break;
        case Line.BOTTOM:
          id = 10;
          break;
        case Line.RIGHT:
          id = 4;
          break;
        case Line.TOP:
          id = 9;
          break;
        }
        break;
      }
    case Rect.TOP: 
      {
        switch (lineId) {
        case Line.LEFT:
          id = 8;
          break;
        case Line.BOTTOM:
          id = 3;
          break;
        case Line.RIGHT:
          id = 9;
          break;
        case Line.TOP:
          id = 7;
          break;
        }
        break;
      }
    case Rect.BOTTOM: 
      {
        switch (lineId) {
        case Line.LEFT:
          id = 10;
          break;
        case Line.BOTTOM:
          id = 1;
          break;
        case Line.RIGHT:
          id = 11;
          break;
        case Line.TOP:
          id = 5;
          break;
        }
        break;
      }
    }
    return lines.get(id);
  }

  void setRectsColor(color c) {
    setRectsColor(c, c);
  }

  void setRectsColor(color c1, color c2) {
    for (Rect r : rects) {
      r.c1 = c1;
      r.c2 = c2;
    }
  }

  void setRectColor(int id, color c) {
    setRectColor(id, c, c);
  }

  void setRectColor(int id, color c1, color c2) {
    Rect r = rects.get(id);
    r.c1 = c1;
    r.c2 = c2;
  }

  void setRectsType(int t) {
    for (Rect r : rects) {
      r.type = t;
    }
  }

  void setRectType(int id, int t) {
    Rect r = rects.get(id);
    r.type = t;
  }

  void setRectType(int id, int t, color c) {
    setRectType(id, t, c, c);
  }

  void setRectType(int id, int t, color c1, color c2) {
    Rect r = rects.get(id);
    r.type = t;
    r.c1 = c1;
    r.c2 = c2;
  }

  void setLinesColor(color c) {
    for (Line line : lines) {
      line.setColor(c);
    }
  }

  void setLineColor(int rectId, int lineId, color c) {
    Line l = getLine(rectId, lineId);
    l.setColor(c);
  }

  void setLinesWidth(int w) {
    for (Line line : lines) {
      line.setWidth(w);
    }
  }

  void setLineWidth(int rectId, int lineId, int w) {
    Line l = getLine(rectId, lineId);
    l.setWidth(w);
  }

  void setRectsDisplayEnabled(boolean enabled) {
    for (Rect rect : rects) {
      rect.setDisplayEnabled(enabled);
    }
  }

  void setLinesDisplayEnabled(boolean enabled) {
    for (Line line : lines) {
      line.setDisplayEnabled(enabled);
    }
  }

  void display() {
    for (Rect r : rects) {
      r.display();
    }

    for (Line l : lines) {
      l.display();
    }
  }

  /*
   * Rect
   */

  class Rect {
    public final static int FRONT = 0;
    public final static int BACK = 1;
    public final static int LEFT = 2;
    public final static int RIGHT = 3;
    public final static int TOP = 4;
    public final static int BOTTOM = 5;

    public final static int TYPE_RECT = 0;
    public final static int TYPE_TRI_1 = 1;
    public final static int TYPE_TRI_2 = 2;

    public boolean displayEnabled = true;
    public int type = 0;
    public float tx, ty, tz, rx, ry, rz;
    public color c1 = #0066FF;
    public color c2 = #FFCC00;

    public Rect(float tx, float ty, float tz, float rx, float ry, float rz) {
      this.tx = tx;
      this.ty = ty;
      this.tz = tz;
      this.rx = rx;
      this.ry = ry;
      this.rz = rz;
    }

    void setDisplayEnabled(boolean d) {
      displayEnabled = d;
    }

    void display() {
      if (!displayEnabled) {
        return;
      }

      strokeWeight(0);
      
      pushMatrix();

      translate(tx, ty, tz);
      rotateX(rx);
      rotateY(ry);
      rotateZ(rz);

      switch(type) {
      case TYPE_RECT:
        fill(c1);
        beginShape();
        vertex(0, 0, 0);
        vertex(0, size, 0);
        vertex(size, size, 0);
        vertex(size, 0, 0);
        endShape(CLOSE);
        break;
      case TYPE_TRI_1:
        fill(c1);
        beginShape();
        vertex(0, 0, 0);
        vertex(0, size, 0);
        vertex(size, size, 0);
        endShape(CLOSE);
        fill(c2);
        beginShape();
        vertex(0, 0, 0);
        vertex(size, size, 0);
        vertex(size, 0, 0);
        endShape(CLOSE);
        break;
      case TYPE_TRI_2:
        fill(c1);
        beginShape();
        vertex(0, 0, 0);
        vertex(0, size, 0);
        vertex(size, 0, 0);
        endShape(CLOSE);
        fill(c2);
        beginShape();
        vertex(0, size, 0);
        vertex(size, size, 0);
        vertex(size, 0, 0);
        endShape(CLOSE);
        break;
      }

      popMatrix();
    }
  }

  /*
   * Line
   */

  class Line {
    public final static int LEFT = 0;
    public final static int BOTTOM = 1;
    public final static int RIGHT = 2;
    public final static int TOP = 3;

    private boolean displayEnabled = true;
    private color c = #ffffff;
    private int w = 3;

    float x1, y1, z1, x2, y2, z2;

    public Line(float x1, float y1, float z1, float x2, float y2, float z2) {
      this.x1 = x1;
      this.y1 = y1;
      this.z1 = z1;
      this.x2 = x2;
      this.y2 = y2;
      this.z2 = z2;
    }

    void setColor(color c) {
      this.c = c;
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

      stroke(c);
      strokeWeight(w);
      line(x1, y1, z1, x2, y2, z2);
    }
  }
}
