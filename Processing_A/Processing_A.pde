int mode = 1;
ArrayList<Mode> modes = new ArrayList<Mode>();

PVector center = new PVector(700, 250, 700);
int eyeX = 0;
int eyeY = 0;
float cameraDirectionXZ = 225f;
float cameraDirectionXY = 0;
boolean moveCameraXZ = false;
boolean ortho = true;
int mouseWheel = 0;

void setup() {
  size(1200, 800, P3D);
  smooth(8);

  if (ortho) {
    ortho();
  }
  //
  calculateCamera();

  modes.add(new FourCubes());
  modes.add(new FlowerMode());
  modes.add(new InfiniteMode());
  modes.add(new PointsMode());
  modes.add(new AnimatedCubesMode());
}

void draw() {
  background(0);
  //translate(width/2, height/2, 0);
  moveCamera(); 

  modes.get(mode).display();
}

int mxStart, myStart; 
float eyeDirectionStart; 
float eyeAngleStart; 

void mousePressed() {
  mxStart = mouseX; 
  myStart = mouseY; 
  eyeDirectionStart = cameraDirectionXZ; 
  eyeAngleStart = cameraDirectionXY;
}

void mouseDragged() {
  cameraDirectionXZ =  -(mouseX - mxStart) / 10f + eyeDirectionStart; 
  cameraDirectionXY = (mouseY - myStart) / 10f + eyeAngleStart; 
  calculateCamera();
}

void mouseWheel(MouseEvent event) {
  mouseWheel += event.getCount();
  calculateCamera();
}

void keyPressed() {
  if (key == 'm') {
    mode = (mode + 1) % modes.size();
  } else if (key == 'r') {
  } else if (key == 'h') {
  } else if (key == 'x') {
  } else if (key == ' ') {
    moveCameraXZ = !moveCameraXZ;
  }
  modes.get(mode).onKeyPressed();
}

void moveCamera() {
  if (!keyPressed) {
    return;
  }
  int k = keyCode; 
  if (k == 0) {
    switch(key) {
    case 'w' : 
      k = UP; 
      break; 
    case 'a' : 
      k = LEFT; 
      break; 
    case 's' : 
      k = DOWN; 
      break; 
    case 'd' : 
      k = RIGHT; 
      break;
    }
  }
  PVector v; 
  boolean switchZAndY = true; 
  switch(k) {
  case LEFT : 
    v = angleToVector(cameraDirectionXZ + 90); 
    break; 
  case RIGHT : 
    v = angleToVector(cameraDirectionXZ - 90); 
    break; 
  case UP : 
    if (moveCameraXZ) {
      v = angleToVector(cameraDirectionXZ);
    } else {
      v = new PVector(0, -1, 0); 
      switchZAndY = false;
    }
    break; 
  case DOWN : 
    if (moveCameraXZ) {
      v = angleToVector(cameraDirectionXZ + 180);
    } else {
      v = new PVector(0, 1, 0); 
      switchZAndY = false;
    }
    break; 
  default : 
    return;
  }
  if (switchZAndY) {
    v.z = v.y; 
    v.y = 0;
  }
  v.mult(10); 
  center.add(v); 

  calculateCamera();
}

PVector angleToVector(float angle) {
  if (angle < 0) {
    angle += 360f;
  } else {
    angle = angle % 360;
  }
  return new PVector(sin(radians(angle)), cos(radians(angle)));
}

PVector calculateDirection() {
  PVector direction = angleToVector(cameraDirectionXZ); 
  direction.z = direction.y; 
  direction.y = angleToVector(cameraDirectionXY).x; 
  return direction;
}

void calculateCamera() {
  PVector direction = calculateDirection(); 
  camera(center.x, center.y, center.z, 
    center.x + direction.x, center.y + direction.y, center.z + direction.z, 
    0, 1.0, 0);

  float fov = PI/2.0 + mouseWheel * PI/32.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
    cameraZ/10.0, cameraZ*10.0);
}
