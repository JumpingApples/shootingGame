class Collider {
  PVector pos;
  PFloat dir;
  
  // Line
  PVector vertex;
  PVector direct;
  
  // Circle
  PVector offset;
  float radius;
  PVector center() {
    return new PVector(0, 0);
  }
  
  String colType;
  Collider(String colType) {
    this.colType = colType;
  }
  
  boolean checkCollision(Collider col) {
    switch (col.colType) {
    case "line":
      return lineCollision(col);
    case "circle":
      return circleCollision(col);
    default:
      return false;
    }
  }
  
  boolean lineCollision(Collider col) {
    return false;
  }
  
  boolean circleCollision(Collider col) {
    return false;
  }
  
  void show() {
  }
}

class LineCollider extends Collider {
  LineCollider(PVector vertex1, PVector vertex2) {
    super("line");
    vertex = new PVector(vertex1.x, vertex1.y);
    direct = new PVector(vertex2.x - vertex1.x, vertex2.y - vertex1.y);
  }
}

class CircleCollider extends Collider {
  CircleCollider(PVector pos, PFloat dir, PVector offset, float radius) {
    super("circle");
    this.pos = pos;
    this.dir = dir;
    this.offset = offset;
    this.radius = radius;
  }
  
  PVector center() {
    return new PVector(pos.x, pos.y).add(new PVector(offset.x, offset.y).rotate(dir.n));
  }
  
  boolean circleCollision(Collider col) {
    PVector center = center();
    if (sqr(center.x - col.center().x) + sqr(center.y - col.center().y) < sqr(radius + col.radius)) {
      return true;
    }
    return false;
  }
  
  void show() {
    noFill();
    strokeWeight(1);
    PVector center = inCam(center());
    ellipse(center.x, center.y, 2 * radius, 2 * radius);
  }
}