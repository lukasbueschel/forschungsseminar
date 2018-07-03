class Mode {

  protected ArrayList<Displayable> displayables = new ArrayList<Displayable>(); 

  public Mode() {
  }

  public void display() {
    for (Displayable d : displayables) {
      d.display();
    }
  }

  public void onKeyPressed() {
  }
}

class CubeMode extends Mode {

  private static final int LEVELS = 3;
  private static final int SIZE = 100;

  protected int levels = 3;
  protected int size = 100;

  protected ArrayList<Cube> cubes = new ArrayList<Cube>();

  public CubeMode() {
    this(LEVELS, SIZE);
  }

  public CubeMode(int ls, int s) {
    levels = ls;
    size= s;

    int t = size / 2;
    for (int l = 0; l < levels; l++) {
      int max = (levels - l) * size;
      int y = -(l * size) - t;
      for (int x = t; x < max; x += size) {
        Cube c = new Cube(x, y, max - x, size);
        displayables.add(c);
        cubes.add(c);
      }
    }
  }

  public Cube getCube(int l, int n) {
    if (l >= levels) {
      return null;
    }
    int i = 0; // index of cube
    int c = 0; // current level
    int t = levels; // number of cubes on current level
    while (c < l) {
      i += t;
      t--;
      c++;
    }
    if (n >= t) {
      return null;
    }
    return cubes.get(i + n);
  }
}

class FourCubes extends CubeMode {

  public FourCubes() {
    super(2, 100);

    for (Cube c : cubes) {
      c.setRectsColor(#000000);
      c.setLinesColor(#ffffff);
    }
  }

  public void onKeyPressed() {
    if (key == 'x') {
      for (Cube c : cubes) {
        c.setRectsColor(color(random(255), random(255), random(255)));
      }
    }
  }
}

class InfiniteMode extends CubeMode {

  private ArrayList<Rect> tiles = new ArrayList<Rect>();

  public InfiniteMode() {
    super(3, 100);

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
        if (p.y > -100) {
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

class FlowerMode extends CubeMode {

  private ArrayList<FlowerWall> walls = new ArrayList<FlowerWall>();
  private ArrayList<ArrayList<Line>> lines = new ArrayList<ArrayList<Line>>();

  private boolean displayCubes = true;

  public FlowerMode() {
    super(3, 100);

    for (int i = 0; i < cubes.size(); i++) {
      Cube c = cubes.get(i);
      //c.setRectsColor(#000000);
      c.setRectsDisplayFill(false);
      c.setRectType(Cube.FRONT, Rect.TYPE_TRI_2);
      c.setRectType(Cube.RIGHT, Rect.TYPE_TRI_1);
      c.setRectType(Cube.TOP, Rect.TYPE_TRI_1);
      c.setLineColor(Cube.FRONT, Rect.LINE_TRI_2, #ffffff);
      c.setLineColor(Cube.RIGHT, Rect.LINE_TRI_1, #ffffff);
      c.setLineColor(Cube.TOP, Rect.LINE_TRI_1, #ffffff);
      if (i > 2) {
        c.setLineColor(Cube.FRONT, Rect.BOTTOM, #ffffff);
        c.setLineColor(Cube.RIGHT, Rect.BOTTOM, #ffffff);
      }
      if (i < 4 && i != 2) {
        c.setLineColor(Cube.RIGHT, Rect.RIGHT, #ffffff);
      }
    }

    walls.add(new FlowerWall(0, 0, 0, 1, -1, 0, 100, 5));
    walls.add(new FlowerWall(0, 0, 0, 0, -1, 1, 100, 5));
    walls.add(new FlowerWall(0, 0, 0, 1, 0, 1, 100, 5));

    ArrayList<Line> temp;
    for (int distance = 0; distance < 9; distance++) {
      temp = new ArrayList<Line>();
      for (FlowerWall wall : walls) {
        temp.addAll(wall.getLinesWithDistance(distance));
      }
      lines.add(temp);
    }
    temp = lines.get(0);
    for (Line l : temp) {
      l.setColor(#000000);
    }
    temp.clear();    
    temp.add(cubes.get(3).getLine(Cube.RIGHT, Rect.RIGHT));
    temp.add(cubes.get(3).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
    temp.add(cubes.get(3).getLine(Cube.RIGHT, Rect.BOTTOM));
    temp.add(cubes.get(1).getLine(Cube.TOP, Rect.LINE_TRI_1));
    temp.add(cubes.get(4).getLine(Cube.FRONT, Rect.BOTTOM));
    temp.add(cubes.get(4).getLine(Cube.FRONT, Rect.LINE_TRI_2));
    temp = lines.get(1);
    for (Line l : temp) {
      l.setColor(#000000);
    }
    temp.clear();   
    temp.add(cubes.get(5).getLine(Cube.FRONT, Rect.BOTTOM));
    temp.add(cubes.get(3).getLine(Cube.FRONT, Rect.BOTTOM));
    temp.add(cubes.get(0).getLine(Cube.RIGHT, Rect.RIGHT));
    temp.add(cubes.get(1).getLine(Cube.RIGHT, Rect.RIGHT));
    temp.add(cubes.get(4).getLine(Cube.RIGHT, Rect.BOTTOM));  
    temp.add(cubes.get(5).getLine(Cube.RIGHT, Rect.BOTTOM));
    temp = lines.get(2);
    for (Line l : temp) {
      l.setColor(#000000);
    }
    temp.clear();
    temp.add(cubes.get(5).getLine(Cube.TOP, Rect.LINE_TRI_1));
    temp.add(cubes.get(5).getLine(Cube.FRONT, Rect.LINE_TRI_2));
    temp.add(cubes.get(3).getLine(Cube.TOP, Rect.LINE_TRI_1));
    temp.add(cubes.get(3).getLine(Cube.FRONT, Rect.LINE_TRI_2));
    temp.add(cubes.get(0).getLine(Cube.TOP, Rect.LINE_TRI_1));
    temp.add(cubes.get(0).getLine(Cube.FRONT, Rect.LINE_TRI_2));
    temp.add(cubes.get(0).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
    temp.add(cubes.get(1).getLine(Cube.FRONT, Rect.LINE_TRI_2));
    temp.add(cubes.get(1).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
    temp.add(cubes.get(2).getLine(Cube.FRONT, Rect.LINE_TRI_2));
    temp.add(cubes.get(2).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
    temp.add(cubes.get(2).getLine(Cube.TOP, Rect.LINE_TRI_1));
    temp.add(cubes.get(4).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
    temp.add(cubes.get(4).getLine(Cube.TOP, Rect.LINE_TRI_1));  
    temp.add(cubes.get(5).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
    for (int i = 0; i < 9; i++) {
      color c = color(255, 255, 255, getAlpha(i, 9));
      for (Line l : lines.get(i)) {
        l.setColor(c);
      }
    }
  }

  public void display() {
    if (displayCubes) {
      super.display();
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
    } else if (key == 'y') {
      displayCubes = !displayCubes;
    }
  }

  private int currentFrame;

  private void animate() {
    int maxDistance = (int)(9 * (currentFrame / 60f)) + 1;
    for (int i = 0; i < maxDistance; i++) {
      float alpha = alpha(lines.get(i).get(0).getColor());
      color from = color(255, 255, 255, alpha * 2);
      color to = color(255, 255, 255, getAlpha(i, maxDistance));
      for (Line l : lines.get(i)) {
        l.animate(LineAnimation.COLOR, from, to, 60 * maxDistance / 3);
      }
    }
    currentFrame = 60;
  }

  private float getAlpha(int d, int max) {
    return 0.3*255*((float)(max-d)/max);
  }
}

/*
 * Flower Mode (Advanced)
 */

class AdvancedFlowerMode extends CubeMode {

  private ArrayList<FlowerWall> walls = new ArrayList<FlowerWall>();
  private ArrayList<ArrayList<Line>> lines = new ArrayList<ArrayList<Line>>();

  public AdvancedFlowerMode(int l) {
    super(l, 100);

    walls.add(new FlowerWall(0, 0, 0, 1, -1, 0, 100, 5));
    walls.add(new FlowerWall(0, 0, 0, 0, -1, 1, 100, 5));
    walls.add(new FlowerWall(0, 0, 0, 1, 0, 1, 100, 5));

    ArrayList<Line> temp;
    for (int distance = 0; distance < 9; distance++) {
      temp = new ArrayList<Line>();
      for (FlowerWall wall : walls) {
        temp.addAll(wall.getLinesWithDistance(distance));
      }
      lines.add(temp);
    }
    temp = lines.get(0);
    for (Line line : temp) {
      line.setColor(#000000);
    }

    if (l % 2 == 0) {
      for (Cube c : cubes) {
        c.setRectsColor(#000000);
        c.setLinesColor(#ffffff);
      }
    } else {
      for (int i = 0; i < cubes.size(); i++) {
        Cube c = cubes.get(i);
        //c.setRectsColor(#000000);
        c.setRectsDisplayFill(false);
        c.setRectType(Cube.FRONT, Rect.TYPE_TRI_2);
        c.setRectType(Cube.RIGHT, Rect.TYPE_TRI_1);
        c.setRectType(Cube.TOP, Rect.TYPE_TRI_1);
        c.setLineColor(Cube.FRONT, Rect.LINE_TRI_2, #ffffff);
        c.setLineColor(Cube.RIGHT, Rect.LINE_TRI_1, #ffffff);
        c.setLineColor(Cube.TOP, Rect.LINE_TRI_1, #ffffff);
        if (i > 2) {
          c.setLineColor(Cube.FRONT, Rect.BOTTOM, #ffffff);
          c.setLineColor(Cube.RIGHT, Rect.BOTTOM, #ffffff);
        }
        if (i < 4 && i != 2) {
          c.setLineColor(Cube.RIGHT, Rect.RIGHT, #ffffff);
        }
      }
    }
    /*
     temp.clear();    
     temp.add(cubes.get(3).getLine(Cube.RIGHT, Rect.RIGHT));
     temp.add(cubes.get(3).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
     temp.add(cubes.get(3).getLine(Cube.RIGHT, Rect.BOTTOM));
     temp.add(cubes.get(1).getLine(Cube.TOP, Rect.LINE_TRI_1));
     temp.add(cubes.get(4).getLine(Cube.FRONT, Rect.BOTTOM));
     temp.add(cubes.get(4).getLine(Cube.FRONT, Rect.LINE_TRI_2));
     temp = lines.get(1);
     for (Line l : temp) {
     l.setColor(#000000);
     }
     temp.clear();   
     temp.add(cubes.get(5).getLine(Cube.FRONT, Rect.BOTTOM));
     temp.add(cubes.get(3).getLine(Cube.FRONT, Rect.BOTTOM));
     temp.add(cubes.get(0).getLine(Cube.RIGHT, Rect.RIGHT));
     temp.add(cubes.get(1).getLine(Cube.RIGHT, Rect.RIGHT));
     temp.add(cubes.get(4).getLine(Cube.RIGHT, Rect.BOTTOM));  
     temp.add(cubes.get(5).getLine(Cube.RIGHT, Rect.BOTTOM));
     temp = lines.get(2);
     for (Line l : temp) {
     l.setColor(#000000);
     }
     temp.clear();
     temp.add(cubes.get(5).getLine(Cube.TOP, Rect.LINE_TRI_1));
     temp.add(cubes.get(5).getLine(Cube.FRONT, Rect.LINE_TRI_2));
     temp.add(cubes.get(3).getLine(Cube.TOP, Rect.LINE_TRI_1));
     temp.add(cubes.get(3).getLine(Cube.FRONT, Rect.LINE_TRI_2));
     temp.add(cubes.get(0).getLine(Cube.TOP, Rect.LINE_TRI_1));
     temp.add(cubes.get(0).getLine(Cube.FRONT, Rect.LINE_TRI_2));
     temp.add(cubes.get(0).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
     temp.add(cubes.get(1).getLine(Cube.FRONT, Rect.LINE_TRI_2));
     temp.add(cubes.get(1).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
     temp.add(cubes.get(2).getLine(Cube.FRONT, Rect.LINE_TRI_2));
     temp.add(cubes.get(2).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
     temp.add(cubes.get(2).getLine(Cube.TOP, Rect.LINE_TRI_1));
     temp.add(cubes.get(4).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
     temp.add(cubes.get(4).getLine(Cube.TOP, Rect.LINE_TRI_1));  
     temp.add(cubes.get(5).getLine(Cube.RIGHT, Rect.LINE_TRI_1));
     for (int i = 0; i < 9; i++) {
     color c = color(255, 255, 255, getAlpha(i, 9));
     for (Line l : lines.get(i)) {
     l.setColor(c);
     }
     }*/
  }

  public void display() {
    super.display();
    for (Wall w : walls) {
      w.display();
    }
  }

  public void onKeyPressed() {
  }
}

/*
 * Points Mode
 */

class PointsMode extends Mode {

  private int size = 100;

  public PointsMode() {
  }

  public void display() {
    int r = 3;
    int y = -1;
    for (int i = 3; i > 0; i--) {
      stroke(color(204, 153, 0, abs((float)y / 2) * 255));
      strokeWeight(r);
      for (int x = 0; x <= i; x++) {
        pushMatrix();
        translate(x * size, y * size, (i-x) * size);
        beginShape(POINTS);
        vertex(0, 0, 0);
        vertex(0, size, 0);
        if (i == x) {
          endShape();
          popMatrix();
          continue;
        }
        vertex(size, 0, 0);
        vertex(size, size, 0);
        endShape();
        popMatrix();
      }
      y--;
    }
    translate(0, -3 * size, 0);
    beginShape(POINTS);
    vertex(0, 0, 0);
    endShape();
  }
}

public class AnimatedCubesMode extends CubeMode {

  private boolean animate = false;
  private int frame = 0;

  public AnimatedCubesMode(int l) {
    super(l, 100);

    for (Cube c : cubes) {
      c.setRectsDisplayFill(false);
    }
  }

  private color from = #000000;
  private color to = #ffffff;
  private int d = 110;

  public void display() {
    super.display();

    if (animate) {
      if (frame == d/2) {
        animateVerticals(from, to, d);
      } else if (frame == d) {
        animateHorizontals(from, to, d);
        frame = 0;
        to = color(random(255), random(255), random(255));
      }
      frame++;
    }
  }

  public void onKeyPressed() {
    if (key == 'x') {
      frame = 0;
      animate = true;
      animateHorizontals(from, to, d);
    }
  }

  private void animateHorizontals(color from, color to, int d) {
    animate = true;
    for (Cube c : cubes) {
      c.getLine(Cube.TOP, Rect.LEFT).animate(LineAnimation.GRADIENT, from, to, d); 
      c.getLine(Cube.TOP, Rect.TOP).animate(LineAnimation.GRADIENT, from, to, d);
      c.getLine(Cube.TOP, Rect.RIGHT).animate(LineAnimation.GRADIENT, from, to, d); 
      c.getLine(Cube.TOP, Rect.BOTTOM).animate(LineAnimation.GRADIENT, from, to, d);
    }
    for (int i = 0; i < levels; i++) {
      Cube c = getCube(0, i);
      c.getLine(Cube.FRONT, Rect.BOTTOM).animate(LineAnimation.GRADIENT, from, to, d);
      c.getLine(Cube.RIGHT, Rect.BOTTOM).animate(LineAnimation.GRADIENT, from, to, d);
    }
  }

  private void animateVerticals(color from, color to, int d) {
    animate = true;
    for (Cube c : cubes) {
      c.getLine(Cube.FRONT, Rect.LEFT).animate(LineAnimation.GRADIENT, from, to, d); 
      c.getLine(Cube.FRONT, Rect.RIGHT).animate(LineAnimation.GRADIENT, from, to, d);
    }
    for (int l = 0; l < levels; l++) {
      getCube(l, levels - l - 1).getLine(Cube.RIGHT, Rect.RIGHT).animate(LineAnimation.GRADIENT, from, to, d);
    }
  }
}
