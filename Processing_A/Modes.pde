class Mode {

  public ArrayList<Cube> cubes = new ArrayList<Cube>();
  protected ArrayList<Displayable> displayables = new ArrayList<Displayable>(); 

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

class FlowerMode extends Mode {

  private ArrayList<Cube> cubes = new ArrayList<Cube>();
  private ArrayList<FlowerWall> walls = new ArrayList<FlowerWall>();
  private ArrayList<ArrayList<Line>> lines = new ArrayList<ArrayList<Line>>();

  private boolean displayCubes = true;

  public FlowerMode() {
    cubes.add(new Cube(50, -50, 250, 100));
    cubes.add(new Cube(150, -50, 150, 100));
    cubes.add(new Cube(250, -50, 50, 100));
    cubes.add(new Cube(50, -150, 150, 100));
    cubes.add(new Cube(150, -150, 50, 100));
    cubes.add(new Cube(50, -250, 50, 100));
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
      for (Cube c : cubes) {
        c.display();
      }
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

class PointsMode extends Mode {

  private int size = 100;

  public PointsMode() {
  }

  public void display() {
    int r = 3;
    int y = -1;
    for (int i = 3; i > 0; i--) {
      fill(color(204, 153, 0, abs((float)y / 4) * 255));
      for (int x = 0; x <= i; x++) {
        pushMatrix();
        translate(x * size, y * size, (i-x) * size);
        sphere(r);
        translate(0, size, 0);
        sphere(r);
        if (i == x) {
          popMatrix();
          continue;
        }
        translate(size, 0, 0);
        sphere(r);
        translate(0, -size, 0);
        sphere(r);
        popMatrix();
      }
      y--;
    }
    translate(0, -3 * size, 0);
    sphere(r);
  }
}

class NewMode extends Mode {

  private Line l1, l2;

  private boolean animate = false;
  private int frame = 0;

  public NewMode() {
    super();
    l1 = new Line(0, 0, 0, 200, -100, 0);
    l2 = new Line(200, -100, 0, 200, -100, 0);
    color c = color(255, 255, 255, 0);
    l1.setColor(c);
    l2.setColor(c);
    displayables.add(l1);
    displayables.add(l2);
  }

  public void display() {
    super.display();
    if (frame == 120) {
      animate = false;
    }
    if (animate) {
      if (frame == 60) {
        l2.animate(LineAnimation.GRADIENT, 
          color(255, 255, 255, 0), 
          color(255, 255, 255, 255), 
          120);
      } else if (frame == 120) {
      }
      frame++;
    }
  }

  public void onKeyPressed() {
    if (key == 'x') {
      frame = 0;
      animate = true;
      l1.animate(LineAnimation.GRADIENT, 
        color(255, 255, 255, 0), 
        color(255, 255, 255, 255), 
        120);
    }
  }
}


class LinesMode extends Mode {

  private ArrayList<Cube> cubes = new ArrayList<Cube>();
  private ArrayList<FlowerWall> walls = new ArrayList<FlowerWall>();

  public LinesMode() {
    color lineColor = #333333;
    cubes.add(new Cube(50, -50, 250, 100));
    cubes.add(new Cube(150, -50, 150, 100));
    cubes.add(new Cube(250, -50, 50, 100));
    cubes.add(new Cube(50, -150, 150, 100));
    cubes.add(new Cube(150, -150, 50, 100));
    cubes.add(new Cube(50, -250, 50, 100));
    for (int i = 0; i < cubes.size(); i++) {
      Cube c = cubes.get(i);
      c.setRectsColor(#000000);
      c.setRectType(Cube.FRONT, Rect.TYPE_TRI_2);
      c.setRectType(Cube.RIGHT, Rect.TYPE_TRI_1);
      c.setRectType(Cube.TOP, Rect.TYPE_TRI_1);
      c.setLineColor(Cube.FRONT, Rect.LINE_TRI_2, lineColor);
      c.setLineColor(Cube.RIGHT, Rect.LINE_TRI_1, lineColor);
      c.setLineColor(Cube.TOP, Rect.LINE_TRI_1, lineColor);
      if (i > 2) {
        c.setLineColor(Cube.FRONT, Rect.BOTTOM, lineColor);
        c.setLineColor(Cube.RIGHT, Rect.BOTTOM, lineColor);
      }
      if (i < 4 && i != 2) {
        c.setLineColor(Cube.RIGHT, Rect.RIGHT, lineColor);
      }
    }

    walls.add(new FlowerWall(0, 0, 0, 1, -1, 0, 100, 8));
    walls.add(new FlowerWall(0, 0, 0, 0, -1, 1, 100, 8));
    walls.add(new FlowerWall(0, 0, 0, 1, 0, 1, 100, 8));

    for (FlowerWall w : walls) {
      for (Line l : w.getLines()) {
        l.setColor(lineColor);
      }
    }
  }

  public void display() {
    super.display();
    for (Cube c : cubes) {
      c.display();
    }
    for (Wall w : walls) {
      w.display();
    }
  }
}

public class CubesMode extends Mode {

  private boolean animate = false;
  private int frame = 0;

  private ArrayList<Cube> cubes = new ArrayList<Cube>();

  public CubesMode() {
    color lineColor = #333333;
    cubes.add(new Cube(50, -50, 250, 100));
    cubes.add(new Cube(150, -50, 150, 100));
    cubes.add(new Cube(250, -50, 50, 100));
    cubes.add(new Cube(50, -150, 150, 100));
    cubes.add(new Cube(150, -150, 50, 100));
    cubes.add(new Cube(50, -250, 50, 100));
    for (Cube c : cubes) {
      c.setRectsDisplayFill(false);
    }
  }

  private color from = #000000;
  private color to = #ffffff;
  private int d = 110;

  public void display() {
    super.display();
    for (Cube c : cubes) {
      c.display();
    }
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
    for (int i = 0; i < 3; i++) {
      Cube c = cubes.get(i);
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
    cubes.get(2).getLine(Cube.RIGHT, Rect.RIGHT).animate(LineAnimation.GRADIENT, from, to, d);
    cubes.get(4).getLine(Cube.RIGHT, Rect.RIGHT).animate(LineAnimation.GRADIENT, from, to, d);
    cubes.get(5).getLine(Cube.RIGHT, Rect.RIGHT).animate(LineAnimation.GRADIENT, from, to, d);
  }
}
