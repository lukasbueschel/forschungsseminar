class Wall implements Displayable {

  protected PVector pos;
  protected PVector dir;
  protected int tileSize;

  protected ArrayList<Rect> tiles = new ArrayList<Rect>();
  private HashMap<Integer, HashMap<Integer, Rect>> ts = new HashMap<Integer, HashMap<Integer, Rect>>();

  public Wall(PVector pos, PVector dir, int tileSize) {
    this.pos = pos;
    this.dir = dir;
    this.tileSize = tileSize;
  }

  public Wall(float px, float py, float pz, float dx, float dy, float dz, int tileSize) {
    this(new PVector(px, py, pz), new PVector(dx, dy, dz), tileSize);
  }

  public Rect setTile(int x, int y) {
    Rect tile = new Rect(x * tileSize, y * tileSize, 0, 1, 1, 0, tileSize);
    tiles.add(tile);
    insert(x, y, tile);
    return tile;
  }

  private void insert(int x, int y, Rect r) {
    HashMap<Integer, Rect> ys = ts.get(x);
    if (ys == null) {
      ys = new HashMap<Integer, Rect>();
      ts.put(x, ys);
    }
    ys.put(y, r);
  }

  public Rect getTile(int x, int y) {
    return ts.get(x).get(y);
  }

  public void display() {
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
    for (Rect tile : tiles) {
      tile.display();
    }
    popMatrix();
  }
}

/*
 * Infinite Wall
 */

class InfiniteWall extends Wall {

  public InfiniteWall(PVector pos, PVector dir, int tileSize) {
    super(pos, dir, tileSize);
  }
}

/*
 * Flower Wall
 */

class FlowerWall extends Wall {

  private HashMap<Integer, ArrayList<Rect>> distances = new HashMap<Integer, ArrayList<Rect>>();

  public FlowerWall(PVector pos, PVector dir, int tileSize, int loops) {
    super(pos, dir, tileSize);
    initialize(loops);
  }

  public FlowerWall(float px, float py, float pz, float dx, float dy, float dz, int tileSize, int loops) {
    super(new PVector(px, py, pz), new PVector(dx, dy, dz), tileSize);
    initialize(loops);
  }

  private void initialize(int loops) {
    int index = 0;
    int currentIndex = 0;
    int type = -1;
    for (int l = 0; l < loops; l++) {
      color c = color(255, 255, 255, 0.5*255*((float)(loops-l)/loops));
      currentIndex = index;
      if (index == 2) {
        index = 0;
      } else {
        index++;
      }
      int x;
      int y = l;
      for (x = 0; x < l; x++) {
        if (currentIndex == 2) {
          type = Rect.TYPE_RECT;
        } else {
          type = Rect.TYPE_TRI_1;
        }
        initializeTile(x, y, type, currentIndex, c);
        currentIndex = (currentIndex + 1) % 3;
      }
      if (currentIndex == 2) {
        type = Rect.TYPE_RECT;
      } else {
        type = Rect.TYPE_TRI_1;
      }
      initializeTile(x, y, type, currentIndex, c);
      for (y--; y >= 0; y--) {
        currentIndex--;
        if (currentIndex < 0) {
          currentIndex = 2;
        }
        initializeTile(x, y, getTile(y, x).getType(), currentIndex, c);
      }
    }
    for (Rect tile : tiles) {
      tile.setDisplayFill(false);
    }
  }

  private void initializeTile(int x, int y, int type, int currentIndex, color c) {
    Rect tile = setTile(x, y);
    tile.setType(type);
    tile.setLine(Rect.TOP, c);
    tile.setLine(Rect.LEFT, c);
    if (type == Rect.TYPE_TRI_1) {
      tile.setLine(Rect.LINE_TRI_1, c);
    } else if (type == Rect.TYPE_TRI_2) {
      tile.setLine(Rect.LINE_TRI_2, c);
    }
    if (currentIndex == 0) {
      tile.removeLine(Rect.BOTTOM);
      tile.removeLine(Rect.RIGHT);
    } else if (currentIndex == 1) {
      tile.removeLine(Rect.LEFT);
      tile.removeLine(Rect.TOP);
    }
    insertDistance(x, y, tile);
  }

  private void insertDistance(int x, int y, Rect tile) {
    int d = x + y;
    ArrayList<Rect> l = distances.get(d);
    if (l == null) {
      l = new ArrayList<Rect>();
      distances.put(d, l);
    }
    l.add(tile);
  }
  
  public ArrayList<Line> getLines() {
    ArrayList<Line> lines = new ArrayList<Line>();
    for(Rect r : tiles) {
      lines.addAll(r.getLines());
    }
    return lines;
  }

  public ArrayList<Line> getLinesWithDistance(int d) {
    ArrayList<Rect> rs = distances.get(d);
    ArrayList<Line> ls = new ArrayList<Line>();
    for (Rect r : rs) {
      ArrayList<Line> temp = r.getLines();
      for (Line l : temp) {
        ls.add(l);
      }
    }
    return ls;
  }
}
