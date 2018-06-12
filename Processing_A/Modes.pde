class Mode {

  public ArrayList<Cube> cubes = new ArrayList<Cube>();
  private ArrayList<Displayable> displayables = new ArrayList<Displayable>(); 

  public Mode() {
  }

  public Mode(ArrayList<Cube> cubes) {
    this.cubes = cubes;
  }

  public void display() {
    for (Displayable d : displayables) {
      d.display();
    }
  }

  public void onKeyPressed() {
  }

  void setCubesRectColor(color c) {
    setCubesRectColor(c, c);
  }

  void setCubesRectColor(color c1, color c2) {
    for (Cube cube : cubes) {
      cube.setRectsColor(c1, c2);
    }
  }

  void setCubesRectType(int t) {
    for (Cube cube : cubes) {
      cube.setRectsType(t);
    }
  }

  void setCubesLineColor(color c) {
    for (Cube cube : cubes) {
      cube.setLinesColor(c);
    }
  }

  void setCubesLineWidth(int w) {
    for (Cube cube : cubes) {
      cube.setLinesWidth(w);
    }
  }
}

class InfiniteMode extends Mode {

  private ArrayList<Cube> cubes = new ArrayList<Cube>();
  private ArrayList<Rect> tiles = new ArrayList<Rect>();

  public InfiniteMode() { 
    cubes.add(new Cube(50, -50, 250, 100));
    cubes.add(new Cube(150, -50, 150, 100));
    cubes.add(new Cube(250, -50, 50, 100));
    cubes.add(new Cube(50, -150, 150, 100));
    cubes.add(new Cube(150, -150, 50, 100));
    cubes.add(new Cube(50, -250, 50, 100));

    color cc1 = #1E88E5;
    color cc2 = #1565C0;
    color cc3 = #0D47A1;

    for (Cube cube : cubes) {

      cube.setRectColor(Cube.TOP, cc1);
      cube.setRectColor(Cube.FRONT, cc2);
      cube.setRectColor(Cube.RIGHT, cc3);
    }


    int tileSize = 100;
    PVector pos = new PVector(0, 0, 0);
    PVector dir = new PVector(1, 1, 0);
    int y = -400;
    for (int x = 100; x < 1000; x += 200) {
      pos.x = x;
      for (int i = 0; i < 5; i++) {
        PVector p = new PVector(pos.x, pos.y, pos.z);
        p.y = y + i * tileSize;
        if (p.y > -100) {
          continue;
        }
        Rect r = new Rect(p, dir, tileSize);
        switch(i) {
        case 0:
          r.type = 2;
          r.setColor(#000000, cc1);
          break;
        case 1:
          r.type = 0;
          r.setColor(cc2);
          break;
        case 2:
          r.type = 2;
          r.setColor(cc1, cc3);
          break;
        case 3:
          r.type = 2;
          r.setColor(cc3, cc1);
          break;
        case 4:
          r.type = 0;
          r.setColor(cc2);
          break;
        }
        tiles.add(r);
      }
      pos.x = x + 100;
      for (int i = 0; i < 5; i++) {
        PVector p = new PVector(pos.x, pos.y, pos.z);
        p.y = y + i * tileSize;
        if(p.y > -100) {
          continue;
        }
        Rect r = new Rect(p, dir, tileSize);
        switch(i) {
        case 0:
          r.type = 2;
          r.setColor(cc1, cc3);
          break;
        case 1:
          r.type = 2;
          r.setColor(cc3, cc1);
          break;
        case 2:
          r.type = 0;
          r.setColor(cc2);
          break;
        case 3:
          r.type = 2;
          r.setColor(cc1, cc3);
          break;
        case 4:
          r.type = 2;
          r.setColor(cc3, #000000);
          break;
        }
        tiles.add(r);
      }
      y -= 100;
    }
  }

  public void display() {
    for (Rect tile : tiles) {
      tile.display();
    }
    for (Cube cube : cubes) {
      cube.display();
    }
  }
}

class FlowerMode extends Mode {

  private ArrayList<Cube> cubes = new ArrayList<Cube>();
  private ArrayList<FlowerWall> walls = new ArrayList<FlowerWall>();

  private ArrayList<Line> s1 = new ArrayList<Line>();

  public FlowerMode() {
    cubes.add(new Cube(50, -50, 250, 100));
    cubes.add(new Cube(150, -50, 150, 100));
    cubes.add(new Cube(250, -50, 50, 100));
    cubes.add(new Cube(50, -150, 150, 100));
    cubes.add(new Cube(150, -150, 50, 100));
    cubes.add(new Cube(50, -250, 50, 100));
    for (Cube c : cubes) {
      c.setRectsColor(#000000);
      c.setRectType(Cube.FRONT, Rect.TYPE_TRI_2);
      c.setRectType(Cube.RIGHT, Rect.TYPE_TRI_1);
      c.setRectType(Cube.TOP, Rect.TYPE_TRI_1);
      c.setLinesColor(#ffffff);
      c.setLineColor(Cube.FRONT, Rect.RIGHT, #000000);
      c.setLineColor(Cube.TOP, Rect.BOTTOM, #000000);
      c.setLineColor(Cube.RIGHT, Rect.TOP, #000000);
    }

    walls.add(new FlowerWall(0, 0, 0, 1, -1, 0, 100, 5));
    walls.add(new FlowerWall(0, 0, 0, 0, -1, 1, 100, 5));
    walls.add(new FlowerWall(0, 0, 0, 1, 0, 1, 100, 5));
  }

  public void display() {
    for (Cube c : cubes) {
      c.display();
    }
    for (Wall w : walls) {
      w.display();
    }
    if (currentFrame > 0) {
      currentFrame--;
    }
  }

  public void onKeyPressed() {
    if (key == 'x') {
      animate();
    }
  }

  private int currentFrame;
  private int maxDistance = 1;

  private void animate() {
    int maxDistance = (int)(9 * (currentFrame / 60f)) + 1;
    for (int i = 0; i < maxDistance; i++) {
      color to = color(255, 255, 255, 0.5*255*((float)(maxDistance-i)/maxDistance));
      for (FlowerWall w : walls) {
        ArrayList<Line> ls = w.getLinesWithDistance(i);
        for (Line l : ls) {
          l.animateColor(#ffffff, to, 60);
        }
      }
    }
    currentFrame = 60;
  }
}
