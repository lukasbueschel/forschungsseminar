class Cube implements Displayable {
  public final static int FRONT = 0;
  public final static int BACK = 1;
  public final static int LEFT = 2;
  public final static int RIGHT = 3;
  public final static int TOP = 4;
  public final static int BOTTOM = 5;

  private int x, y, z, size;
  ArrayList<Rect> rects = new ArrayList<Rect>();
  ArrayList<Line> lines = new ArrayList<Line>();

  public Cube(int posX, int posY, int posZ, int size) {
    this.x = posX - size / 2;
    this.y = posY - size / 2;
    this.z = posZ + size / 2;
    this.size = size;

    rects.add(new Rect(x, y, z, 1, 1, 0, size));
    rects.add(new Rect(x + size, y, z - size, -1, 1, 0, size));
    rects.add(new Rect(x, y, z - size, 0, 1, 1, size));
    rects.add(new Rect(x + size, y, z, 0, 1, -1, size));
    rects.add(new Rect(x, y, z - size, 1, 0, 1, size));
    rects.add(new Rect(x + size, y + size, z - size, -1, 0, 1, size));
  }

  public Rect getRect(int id) {
    return rects.get(id);
  }

  void setRectsColor(color c) {
    setRectsColor(c, c);
  }

  void setRectsColor(color c1, color c2) {
    for (Rect r : rects) {
      r.setColor(c1, c2);
    }
  }

  void setRectColor(int id, color c) {
    setRectColor(id, c, c);
  }

  void setRectColor(int id, color c1, color c2) {
    Rect r = rects.get(id);
    r.setColor(c1, c2);
  }

  void setRectsType(int t) {
    for (Rect r : rects) {
      r.type = t;
    }
  }

  public void setRectType(int id, int t) {
    Rect r = rects.get(id);
    r.type = t;
  }

  void setRectType(int id, int t, color c) {
    setRectType(id, t, c, c);
  }

  void setRectType(int id, int t, color c1, color c2) {
    Rect r = rects.get(id);
    r.type = t;
    r.setColor(c1, c2);
  }

  void setLinesColor(color c) {
    for (int i = 0; i < 12; i ++) {
      getLine(i).setColor(c);
    }
    for (Rect r : rects) {
      switch(r.getType()) {
      case Rect.TYPE_TRI_1:
        r.setLine(Rect.LINE_TRI_1, c);
        break;
      case Rect.TYPE_TRI_2:
        r.setLine(Rect.LINE_TRI_2, c);
        break;
      }
    }
  }

  void setLineColor(int rectId, int lineId, color c) {
    Line l = getLine(rectId, lineId);
    l.setColor(c);
  }

  void setLinesWidth(int w) {
    for (int i = 0; i < 12; i ++) {
      getLine(i).setWidth(w);
    }
  }

  void setLineWidth(int rectId, int lineId, int w) {
    Line l = getLine(rectId, lineId);
    l.setWidth(w);
  }

  public void setRectsDisplayFill(boolean display) {
    for (Rect rect : rects) {
      rect.setDisplayFill(display);
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
  }

  private Line getLine(int rectId, int lineId) {
    int id = -1;
    switch (rectId) {
    case Cube.FRONT: 
      {
        id = lineId;
        break;
      }
    case Cube.BACK: 
      {
        id = lineId + 4;
        break;
      }
    case Cube.LEFT: 
      {
        switch (lineId) {
        case Rect.LEFT:
          id = 7;
          break;
        case Rect.BOTTOM:
          id = 12;
          break;
        case Rect.RIGHT:
          id = 8;
          break;
        case Rect.TOP:
          id = 9;
          break;
        }
        break;
      }
    case Cube.RIGHT: 
      {
        switch (lineId) {
        case Rect.LEFT:
          id = 2;
          break;
        case Rect.BOTTOM:
          id = 10;
          break;
        case Rect.RIGHT:
          id = 4;
          break;
        case Rect.TOP:
          id = 9;
          break;
        }
        break;
      }
    case Cube.TOP: 
      {
        switch (lineId) {
        case Rect.LEFT:
          id = 8;
          break;
        case Rect.BOTTOM:
          id = 3;
          break;
        case Rect.RIGHT:
          id = 9;
          break;
        case Rect.TOP:
          id = 7;
          break;
        }
        break;
      }
    case Cube.BOTTOM: 
      {
        switch (lineId) {
        case Rect.LEFT:
          id = 10;
          break;
        case Rect.BOTTOM:
          id = 1;
          break;
        case Rect.RIGHT:
          id = 11;
          break;
        case Rect.TOP:
          id = 5;
          break;
        }
        break;
      }
    }
    if (id == -1) {
      return getRect(rectId).getLine(lineId);
    } else {
      return getLine(id);
    }
  }

  private Line getLine(int id) {
    Line line = null;
    if (id < 4) {
      line = getRect(FRONT).getLine(id);
    } else if (id < 8) {
      line = getRect(BACK).getLine(id % 4);
    } else if (id < 10) {
      line = getRect(TOP).getLine((id % 8) * 2);
    } else {
      line = getRect(BOTTOM).getLine((id % 10) * 2);
    }
    return line;
  }
}
