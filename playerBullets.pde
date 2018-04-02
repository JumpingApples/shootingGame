class PlayerBullet {
  PVector pos;
  PVector vel;
  PFloat dir;
  float speed;
  float time;
  float damage = 0;
  Collider[] colliders;
  PlayerBullet(PVector pos) {
    this.pos = pos;
    time = 0;
  }
  
  void checkUpgrades() {
  }
  
  void move() {
  }
  
  void checkCollision() {
  }
  
  void appearance() {
  }
  
  void show() {
    PVector posInCam = inCam(pos);
    
    pushMatrix();
    translate(posInCam.x, posInCam.y);
    rotate(dir.n);
    
    appearance();
    
    popMatrix();
    
    if (debugMenu && debugState == 2) {
      stroke(255, 255, 0);
      for (int i = 0; i < colliders.length; i++) {
        colliders[i].show();
      }
    }
  }
}
ArrayList<PlayerBullet> playerBullets = new ArrayList<PlayerBullet>();

class PBShoot extends PlayerBullet {
  float diam;
  ArrayList<Collider> collisions;
  float maxCollisions;
  PBShoot(PVector pos, PFloat dir) {
    super(pos);
    this.dir = dir;
    
    damage = abilityShoot.bulletDamage;
    diam = abilityShoot.bulletDiam;
    speed = abilityShoot.bulletSpeed;
    maxCollisions = abilityShoot.bulletMaxCollisions;
    
    vel = new PVector(speed * cos(dir.n), speed * sin(dir.n));
    
    colliders = new Collider[1];
    colliders[0] = new CircleCollider(pos, dir, new PVector(0, 0), diam / 2);
    collisions = new ArrayList<Collider>();
  }
  
  void move() {
    pos.x += vel.x * frameTime;
    pos.y += vel.y * frameTime;
    
    time += frameTime;
    if (time > 3) {
      playerBullets.remove(playerBullets.indexOf(this));
    }
  }
  
  void checkCollision() {
    boolean alreadyCollided;
    for (int i = 0; i < colliders.length; i++) {
      for (int j = allShips.size() - 1; j >= 0; j--) {
        for (int k = 0; k < allShips.get(j).colliders.length; k++) {
          if (colliders[i].checkCollision(allShips.get(j).colliders[k])) {
            alreadyCollided = false;
            for (int l = 0; l < collisions.size(); l++) {
              if (collisions.get(l) == allShips.get(j).colliders[k]) {
                alreadyCollided = true;
                break;
              }
            }
            if (!alreadyCollided) {
              collisions.add(allShips.get(j).colliders[k]);
              
              allShips.get(j).damage(damage);
              
              if (collisions.size() >= maxCollisions) {
                playerBullets.remove(playerBullets.indexOf(this));
                return;
              }
              break;
            }
          }
        }
      }
    }
  }
  
  void appearance() {
    noFill();
    strokeWeight(1);
    stroke(180, 220, 255);
    ellipse(0, 0, diam, diam);
  }
}