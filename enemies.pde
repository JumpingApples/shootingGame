class Ship {
  PVector pos;
  PVector vel;
  float speed = 100;
  PFloat dir;
  float turnSpeed = 50;
  color c = color(255);
  
  float health = 1;
  Collider[] colliders;
  Ship(PVector pos, PFloat dir) {
    this.pos = pos;
    this.dir = dir;
    this.vel = new PVector(0, 0);
  }
  
  void move() {
  }
  
  void checkCollision() {
  }
  
  void damage(float n) {
    health -= n;
    if (health <= 0) {
      death();
    }
  }
  
  void death() {
  }
  
  void appearance() {
  }
  
  void extraAppearance() {
  }
  
  void show() {
    PVector posInCam = inCam(pos);
    
    pushMatrix();
    translate(posInCam.x, posInCam.y);
    rotate(dir.n);
    
    appearance();
    
    popMatrix();
    
    if (debugMenu && debugState == 2) {
      stroke(255, 0, 0);
      for (int i = 0; i < colliders.length; i++) {
        colliders[i].show();
      }
    }
    
    extraAppearance();
  }
}
ArrayList<Ship> allShips = new ArrayList<Ship>();

class Chaser extends Ship {
  Chaser(PVector pos, PFloat dir) {
    super(pos, dir);
    turnSpeed = 7.5;
    speed = 200;
    
    c = color(255, 100, 100);
    
    health = 1;
    colliders = new Collider[1];
    colliders[0] = new CircleCollider(pos, dir, new PVector(0, 0), 4);
  }
  
  void move() {
    vel.add(new PVector(player.pos.x - pos.x, player.pos.y - pos.y).setMag(turnSpeed)).limit(speed);
    
    pos.x += vel.x * frameTime;
    pos.y += vel.y * frameTime;
    
    dir.n = atan(vel.y / vel.x) + (vel.x < 0 ? PI : 0);
  }
  
  void checkCollision() {
    for (int i = 0; i < colliders.length; i++) {
      for (int j = 0; j < player.colliders.size(); j++) {
        if (colliders[i].checkCollision(player.colliders.get(j))) {
          player.damage(5);
          player.vel.add(vel.copy().mult(0.5));
          explosions.add(new Explosion(pos, 0.5, 30));
          allShips.remove(allShips.indexOf(this));
          return;
        }
      }
    }
  }
  
  void death() {
    spawnMoney(pos, int(random(2, 8)));
    explosions.add(new Explosion(pos, 0.5, 30));
    allShips.remove(allShips.indexOf(this));
  }
  
  void appearance() {
    noFill();
    strokeWeight(1);
    stroke(c);
    triangle(8, 0, -4, 3, -4, -3);
    /*rotate(time * 15);
    arc(30, 0, 60, 60, 0, PI, OPEN);
    arc(-30, 0, 60, 60, PI, 2 * PI, OPEN);*/
  }
}

class Shooter extends Ship {
  PVector target;
  PVector proxLimits = new PVector(200, 350);
  float targetAllowance = 150;
  PVector shootClockLimits = new PVector(1, 1.3);
  float shootClock;
  Shooter(PVector pos, PFloat dir) {
    super(pos, dir);
    turnSpeed = 2;
    speed = 150;
    
    c = color(200, 255, 160);
    
    health = 2;
    colliders = new Collider[1];
    colliders[0] = new CircleCollider(pos, dir, new PVector(0, 0), 5);
    
    target = new PVector(0, 0);
    
    shootClock = random(shootClockLimits.x, shootClockLimits.y);
  }
  
  void move() {
    PVector toTarget = new PVector(player.pos.x + target.x - pos.x, player.pos.y + target.y - pos.y);
    
    if (sqr(toTarget.x) + sqr(toTarget.y) <= sqr(targetAllowance)) {
      target = new PVector(random(-1, 1), random(-1, 1)).setMag(random(proxLimits.x, proxLimits.y));
    }
    
    vel.add(toTarget.setMag(turnSpeed)).limit(speed);
    pos.x += vel.x * frameTime;
    pos.y += vel.y * frameTime;
    
    dir.n = atan((player.pos.y - pos.y) / (player.pos.x - pos.x)) + (player.pos.x - pos.x < 0 ? PI : 0);
    
    shootClock -= frameTime;
    if (shootClock <= 0) {
      shootClock += random(shootClockLimits.x, shootClockLimits.y);
      float shootDir = dir.n + random(-PI / 8, PI / 8);
      bullets.add(new Bullet(pos.copy(), new PVector(cos(shootDir), sin(shootDir)).setMag(random(180, 220))));
    }
  }
  
  void death() {
    spawnMoney(pos, int(random(7, 15)));
    explosions.add(new Explosion(pos, 0.5, 30));
    allShips.remove(allShips.indexOf(this));
  }
  
  void appearance() {
    noFill();
    strokeWeight(1);
    stroke(c);
    triangle(10, 0, -5, 4, -5, -4);
  }
  
  void extraAppearance() {
    if (debugMenu && debugState == 2) {
      stroke(c);
      ellipse(player.posInCam.x + target.x, player.posInCam.y + target.y, 2 * targetAllowance, 2 * targetAllowance);
    }
  }
}

class Bullet {
  PVector pos;
  PVector vel;
  PVector posInCam = new PVector(-50, -50);
  
  float damage;
  Collider collider;
  Bullet(PVector pos, PVector vel) {
    this.pos = pos;
    this.vel = vel;
    
    damage = 3;
    collider = new CircleCollider(pos, new PFloat(0), new PVector(0, 0), 3);
  }
  
  void move() {
    pos.x += vel.x * frameTime;
    pos.y += vel.y * frameTime;
    
    posInCam = inCam(pos);
    if (posInCam.x < -200 || posInCam.x > width + 200 || posInCam.y < -200 || posInCam.y > height + 200) {
      bullets.remove(bullets.indexOf(this));
    }
    
    for (int i = 0; i < player.colliders.size(); i++) {
      if (collider.checkCollision(player.colliders.get(i))) {
        player.damage(damage);
        player.vel.add(vel.copy().setMag(25));
        bullets.remove(bullets.indexOf(this));
        return;
      }
    }
  }
  
  void show() {
    noFill();
    strokeWeight(1);
    stroke(255, 200, 90);
    ellipse(posInCam.x, posInCam.y, 6, 6);
    
    if (debugMenu && debugState == 2) {
      stroke(255, 0, 0);
      collider.show();
    }
  }
}
ArrayList<Bullet> bullets = new ArrayList<Bullet>();