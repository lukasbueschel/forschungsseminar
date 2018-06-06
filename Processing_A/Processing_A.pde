int mode = 0;
ArrayList<Mode> modes = new ArrayList<Mode>();

int centerX = 0;
int centerY = 0;
int eyeX = 0;
int eyeY = 0;

void setup() {
  size(800, 600, P3D);
  //centerX = width/2;
  //centerY = height/2;
  centerY = -100;
  smooth(8);

  ortho(-width/2, width/2, -height/2, height/2);
  calculateCamera();

  ArrayList<Cube> cubes;
  Cube cube;
  Mode m;

  // Mode 1
  cubes = new ArrayList<Cube>();
  cube = new Cube(0, 0, 0, 100);
  cube.setLinesWidth(0);
  color c1 = #0066FF;
  color c2 = #004499;
  cube.setRectsType(Cube.Rect.TYPE_TRI_1);
  cube.setRectsColor(c1, c2);
  cube.setRectType(Cube.Rect.LEFT, Cube.Rect.TYPE_TRI_2, c2, c1);
  cube.setRectType(Cube.Rect.TOP, Cube.Rect.TYPE_RECT, c2);
  cubes.add(cube);
  modes.add(new Mode(cubes));

  // Mode 2
  cubes = new ArrayList<Cube>();
  cubes.add(new Cube(-100, 0, 100, 100));
  cubes.add(new Cube(0, 0, 0, 100));
  cubes.add(new Cube(100, 0, -100, 100));
  cubes.add(new Cube(-100, -100, 0, 100));
  cubes.add(new Cube(0, -100, -100, 100));
  cubes.add(new Cube(-100, -200, -100, 100));
  m = new Mode(cubes);
  m.setCubesRectColor(#ffffff);
  m.setCubesLineColor(#000000);
  modes.add(m);

  // Mode 3
  color colorAccent = c1;
  cubes = new ArrayList<Cube>();
  cube = new Cube(-100, 0, 100, 100);
  cubes.add(cube);
  cube = new Cube(0, 0, 0, 100);
  cube.setLineColor(Cube.Rect.TOP, Cube.Line.BOTTOM, colorAccent);
  cube.setLineColor(Cube.Rect.TOP, Cube.Line.RIGHT, colorAccent);
  cubes.add(cube);
  cube = new Cube(100, 0, -100, 100);
  cubes.add(cube);
  cube = new Cube(-100, -100, 0, 100);
  cube.setLineColor(Cube.Rect.FRONT, Cube.Line.TOP, colorAccent);
  cube.setLineColor(Cube.Rect.FRONT, Cube.Line.RIGHT, colorAccent);
  cubes.add(cube);
  cube = new Cube(0, -100, -100, 100);
  cube.setLineColor(Cube.Rect.RIGHT, Cube.Line.TOP, colorAccent);
  cube.setLineColor(Cube.Rect.RIGHT, Cube.Line.LEFT, colorAccent);
  cubes.add(cube);
  cube = new Cube(-100, -200, -100, 100);
  cubes.add(cube);
  m = new Mode(cubes);
  m.setCubesRectColor(color(255, 186, 0));
  for(Cube c : cubes) {
    c.setRectsDisplayEnabled(false);
  }
  //m.setCubesLineWidth(3);
  //m.setCubesLineColor(#ffffff);
  modes.add(m);
}

void draw() {
  background(0);
  //translate(width/2, height/2, 0);

  for (Cube c : modes.get(mode).cubes) {
    c.display();
  }
}

int mx = -1, my = -1;
int mxStart, myStart;

void mousePressed() {
  mxStart = mouseX;
  myStart = mouseY;
}

void mouseDragged() {
  //println(mouseX + ", " + mouseY);
  if (mx == -1 && my == -1) {
    mx = mouseX;
    my = mouseY;
  }
  eyeX = mx + (mouseX - mxStart) - (width/2);
  eyeY = my + (mouseY - myStart) - (height/2);
  calculateCamera();
}

void mouseReleased() {
  mx += (mouseX - mxStart);
  my += (mouseY - myStart);
}

void keyPressed() {
  if (key == 'm') {
    mode++;
    if (mode == modes.size()) {
      mode = 0;
    }
  } else {
    switch(keyCode) {
    case LEFT:
      centerX -= 10;
      break;
    case RIGHT:
      centerX += 10;
      break;
    case UP:
      centerY -= 10;
      break;
    case DOWN:
      centerY += 10;
      break;
    }
    calculateCamera();
  }
}

void calculateCamera() {
  println("cx= " + centerX + ", cy= " + centerY + " -- ex= " + eyeX + ", ey=" + eyeY);
  camera(centerX + eyeX, centerY + eyeY, (height/2) / tan(PI/6), 
    centerX, centerY, 0, 
    0, 1, 0);
}

class Mode {

  public ArrayList<Cube> cubes = new ArrayList<Cube>(); 

  public Mode(ArrayList<Cube> cubes) {
    this.cubes = cubes;
  }

  void setCamera(int c) {
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
