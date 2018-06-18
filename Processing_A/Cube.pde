class Cube implements Displayable {
  public final static int FRONT = 0;
  public final static int BACK = 1;
  public final static int LEFT = 2;
  public final static int RIGHT = 3;
  public final static int TOP = 4;
  public final static int BOTTOM = 5;

  private PVector pos;
  private ArrayList<Rect> rects = new ArrayList<Rect>();
  private ArrayList<Line> lines = new ArrayList<Line>();

  public Cube(int posX, int posY, int posZ, int size) {
    pos = new PVector(posX - size / 2, posY - size / 2, posZ + size / 2);

    rects.add(new Rect(0, 0, 0, 1, 1, 0, size));
    rects.add(new Rect(size, 0, -size, -1, 1, 0, size));
    rects.add(new Rect(0, 0, -size, 0, 1, 1, size));
    rects.add(new Rect(size, 0, 0, 0, 1, -1, size));
    rects.add(new Rect(0, 0, -size, 1, 0, 1, size));
    rects.add(new Rect(size, size, -size, -1, 0, 1, size));
  }

  public void display() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    for (Rect r : rects) {
      r.display();
    }
    popMatrix();
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
    rects.get(id).setColor(c1, c2);
  }

  void setRectsType(int t) {
    for (Rect r : rects) {
      r.type = t;
    }
  }

  public void setRectType(int id, int t) {
    rects.get(id).type = t;
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

  public void setLineColor(int rectId, int lineId, color c) {
    getLine(rectId, lineId).setColor(c);
  }

  public void setLinesWidth(int w) {
    for (int i = 0; i < 12; i ++) {
      getLine(i).setWidth(w);
    }
  }

  public void setLineWidth(int rectId, int lineId, int w) {
    getLine(rectId, lineId).setWidth(w);
  }

  public void setRectsDisplayFill(boolean display) {
    for (Rect rect : rects) {
      rect.setDisplayFill(display);
    }
  }

  public void setLinesDisplayEnabled(boolean enabled) {
    for (Line line : lines) {
      line.setDisplayEnabled(enabled);
    }
  }

  public Line getLine(int rectId, int lineId) {
    int id = -1;
    switch (rectId) {
    case Cube.FRONT: 
      {
        if (lineId < 4) {
          id = lineId;
        }
        break;
      }
    case Cube.BACK: 
      {
        if (lineId < 4) {
          id = lineId + 4;
        }
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
