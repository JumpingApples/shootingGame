PGraphics pgOverlay;
class Player {
  class Controls {
    int upKey;
    int downKey;
    int leftKey;
    int rightKey;
    boolean upPressed = false;
    boolean downPressed = false;
    boolean leftPressed = false;
    boolean rightPressed = false;
    boolean lmbPressed = false;
    Controls() {
      upKey = 'w';
      downKey = 's';
      leftKey = 'a';
      rightKey = 'd';
    }
  }
  Controls controls = new Controls();
  
  PVector pos;
  PVector vel;
  float acc = 400;
  float maxVel = 250;
  float velDecay;
  PFloat dir;
  PVector posInCam;
  
  float health;
  float maxHealth = 20;
  float healthRegen = 0;
  float shields;
  float maxShields = 10;
  float shieldRegen = 4;
  float shieldRegenClock;
  PGraphics pgHealthBar;
  float fullHealthClock;
  int currency;
  float collectionRange = 20;
  
  color c = color(100, 200, 255);
  
  ArrayList<Collider> colliders = new ArrayList<Collider>();
  Ability[] abilities = new Ability[5];
  Player() {
    pos = new PVector(width / 2, height / 2);
    vel = new PVector(0, 0);
    velDecay = pow(0.5, float(1) / 60);
    dir = new PFloat(-PI / 2);
    posInCam = new PVector(pos.x - camCoords.x, pos.y - camCoords.y);
    
    colliders.add(new CircleCollider(pos, dir, new PVector(-2, 0), 4.5));
    colliders.add(new CircleCollider(pos, dir, new PVector(6, 0), 3));
    colliders.add(new CircleCollider(pos, dir, new PVector(11, 0), 2));
    
    health = maxHealth;
    shields = maxShields;
    shieldRegenClock = 0;
    fullHealthClock = -5;
    pgHealthBar = createGraphics(width, height);
    currency = 10000;
    
    abilities[0] = abilityShoot;
    for (int i = 1; i < abilities.length; i++) {
      abilities[i] = new Ability("none");
    }
  }
  
  void tick() {
    health += healthRegen * frameTime;
    if (health > maxHealth) {
      health = maxHealth;
    }
    
    shieldRegenClock += frameTime;
    if (shieldRegenClock > 1.5) {
      shields += shieldRegen * frameTime;
    }
    if (shields > maxShields) {
      shields = maxShields;
    }
    
    if (health == maxHealth && shields == maxShields) {
      fullHealthClock -= frameTime;
    }
  }
  
  void move() {
    int cardinalAcc = 0;
    if (controls.leftPressed != controls.rightPressed) {
      cardinalAcc++;
    }
    if (controls.upPressed != controls.downPressed) {
      cardinalAcc++;
    }
    
    if (cardinalAcc > 0) {
      if (controls.leftPressed) {
        vel.x -= acc / pow(cardinalAcc, 0.5) * frameTime;
      }
      if (controls.rightPressed) {
        vel.x += acc / pow(cardinalAcc, 0.5) * frameTime;
      }
      if (controls.upPressed) {
        vel.y -= acc / pow(cardinalAcc, 0.5) * frameTime;
      }
      if (controls.downPressed) {
        vel.y += acc / pow(cardinalAcc, 0.5) * frameTime;
      }
    }
    
    vel.x *= velDecay;
    vel.y *= velDecay;
    
    if (vel.x > maxVel) {
      vel.x = maxVel;
    }
    if (vel.x < -maxVel) {
      vel.x = -maxVel;
    }
    if (vel.y > maxVel) {
      vel.y = maxVel;
    }
    if (vel.y < -maxVel) {
      vel.y = -maxVel;
    }
    
    pos.x += vel.x * frameTime;
    pos.y += vel.y * frameTime;
    
    posInCam.x = pos.x - camCoords.x;
    posInCam.y = pos.y - camCoords.y;
    if (posInCam.x < inCamLimit * width) {
      camCoords.x -= inCamLimit * width - posInCam.x;
    }
    if (posInCam.x > (1 - inCamLimit) * width) {
      camCoords.x += posInCam.x - (1 - inCamLimit) * width;
    }
    if (posInCam.y < inCamLimit * height) {
      camCoords.y -= inCamLimit * height - posInCam.y;
    }
    if (posInCam.y > (1 - inCamLimit) * height) {
      camCoords.y += posInCam.y - (1 - inCamLimit) * height;
    }
    
    dir.n = atan((mouseY - posInCam.y) / (mouseX - posInCam.x)) + (mouseX < posInCam.x ? PI : 0);
    dir.n = (dir.n + 2 * PI * ceil(abs(dir.n) / 2 * PI)) % (2 * PI);
  }
  
  void damage(float damage) {
    shieldRegenClock = 0;
    fullHealthClock = 1;
    shields -= damage;
    if (shields < 0) {
      health += shields;
      shields = 0;
    }
    if (health <= 0) {
      health = 0;
      // Death
      println("Dead");
    }
  }
  
  void showAbilities() {
    noStroke();
    fill(30, 30, 40, 200);
    rectMode(CORNER);
    rect(0, height, 10 + abilities.length * (abilityIconWidth + 10), -(abilityIconWidth + 20));
    
    pushMatrix();
    translate(10, height - 10 - abilityIconWidth);
    
    for (int i = 0; i < abilities.length; i++) {
      abilities[i].show();
      translate(70, 0);
    }
    
    popMatrix();
  }
  
  void showShip() {
    pushMatrix();
    translate(posInCam.x, posInCam.y);
    rotate(dir.n);
    
    noFill();
    strokeWeight(2);
    stroke(c);
    triangle(12, 0, -6, 4, -6, -4);
    
    popMatrix();
    
    pgHealthBar.beginDraw();
    pgHealthBar.clear();
    pgHealthBar.pushMatrix();
    pgHealthBar.translate(posInCam.x - 25, posInCam.y - 15);
    
    pgHealthBar.noFill();
    pgHealthBar.strokeWeight(1);
    pgHealthBar.stroke(255, 120, 120);
    pgHealthBar.rect(0, 0, 50, 3);
    pgHealthBar.fill(255, 120, 120);
    pgHealthBar.noStroke();
    pgHealthBar.rect(0, 0, 50 * health / maxHealth, 4);
    if (shields > 0) {
      pgHealthBar.stroke(160, 200, 255);
      pgHealthBar.line(0, -3, 50 * shields / maxShields, -3);
    }
    
    pgHealthBar.popMatrix();
    pgHealthBar.endDraw();
    
    if (debugMenu && debugState == 2) {
      stroke(0, 255, 0);
      for (int i = 0; i < colliders.size(); i++) {
        colliders.get(i).show();
      }
    }
  }
}
Player player;