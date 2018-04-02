void spawnMoney(PVector pos, int n) {
  int[] values = {3, 14, 40, 115};
  int value;
  for (int i = 0; n > 0;) {
    i = 1;
    for (int j = 1; j < values.length; j++) {
      if (n >= values[j]) {
        i++;
      }
    }
    
    value = values[int(random(i))];
    switch (value) {
    case 3:
      allLoot.add(new LootScrap(new PVector(pos.x, pos.y), new PVector(random(-1, 1), random(-1, 1)).setMag(random(2.5))));
      break;
    case 14:
      allLoot.add(new LootCopper(new PVector(pos.x, pos.y), new PVector(random(-1, 1), random(-1, 1)).setMag(random(2.5))));
      break;
    case 40:
      allLoot.add(new LootSilver(new PVector(pos.x, pos.y), new PVector(random(-1, 1), random(-1, 1)).setMag(random(2.5))));
      break;
    case 115:
      allLoot.add(new LootGold(new PVector(pos.x, pos.y), new PVector(random(-1, 1), random(-1, 1)).setMag(random(2.5))));
      break;
    default:
      break;
    }
    
    n -= value;
  }
}

class Loot {
  PVector pos;
  PVector vel;
  float velDecay;
  float turnSpeed;
  float turnDecay;
  float dir;
  
  int lowValue;
  int highValue;
  boolean collected;
  float collectClock;
  float collectTime;
  PVector startPos;
  Loot(PVector pos, PVector vel, int lowValue, int highValue) {
    this.pos = pos;
    this.vel = vel;
    turnSpeed = random(-PI, PI);
    dir = random(2 * PI);
    
    velDecay = pow(0.3, float(1) / 60);
    turnDecay = pow(0.5, float(1) / 60);
    
    this.lowValue = lowValue;
    this.highValue = highValue;
    collected = false;
    collectClock = 0;
    collectTime = 0.15;
  }
  
  void tick() {
    if (!collected) {
      vel.x *= velDecay;
      vel.y *= velDecay;
      pos.add(vel);
      
      turnSpeed *= turnDecay;
      dir += turnSpeed;
      
      float xToPlayer = player.pos.x - pos.x;
      float yToPlayer = player.pos.y - pos.y;
      if (sqr(xToPlayer) + sqr(yToPlayer) < sqr(player.collectionRange)) {
        collected = true;
        collectClock = 0;
        startPos = new PVector(pos.x, pos.y);
      }
    }
    else {
      collectClock += frameTime;
      
      pos.x = startPos.x + (player.pos.x - startPos.x) * sqr(collectClock / collectTime);
      pos.y = startPos.y + (player.pos.y - startPos.y) * sqr(collectClock / collectTime);
      
      if (collectClock > collectTime) {
        collect();
        allLoot.remove(allLoot.indexOf(this));
      }
    }
  }
  
  void collect() {
    player.currency += int(random(lowValue, highValue));
  }
  
  void appearance() {
  }
  
  void show() {
    PVector posInCam = inCam(pos);
    
    pushMatrix();
    translate(posInCam.x, posInCam.y);
    rotate(dir);
    
    appearance();
    
    popMatrix();
  }
}
ArrayList<Loot> allLoot = new ArrayList<Loot>();

class LootScrap extends Loot {
  LootScrap(PVector pos, PVector vel) {
    super(pos, vel, 1, 6);
    
    corner1 = new PVector(random(3, 5), random(-3.5, 3.5));
    corner2 = new PVector(random(-4, -2.5), random(2.5, 4));
    corner3 = new PVector(random(-4, -2.5), random(-4, -2.5));
  }
  PVector corner1;
  PVector corner2;
  PVector corner3;
  
  void appearance() {
    fill(180, 190, 190);
    noStroke();
    triangle(corner1.x, corner1.y, corner2.x, corner2.y, corner3.x, corner3.y);
  }
}

class LootCopper extends Loot {
  LootCopper(PVector pos, PVector vel) {
    super(pos, vel, 8, 20);
  }
  
  void appearance() {
    fill(160, 110, 20);
    strokeWeight(2);
    stroke(145, 100, 25);
    ellipse(0, 0, 6, 6);
  }
}

class LootSilver extends Loot {
  LootSilver(PVector pos, PVector vel) {
    super(pos, vel, 30, 50);
  }
  
  void appearance() {
    fill(210, 220, 235);
    strokeWeight(2);
    stroke(200, 210, 225);
    ellipse(0, 0, 6, 6);
  }
}

class LootGold extends Loot {
  LootGold(PVector pos, PVector vel) {
    super(pos, vel, 80, 150);
  }
  
  void appearance() {
    fill(240, 190, 30);
    strokeWeight(2);
    stroke(225, 160, 30);
    ellipse(0, 0, 6, 6);
  }
}