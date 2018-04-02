final int abilityIconWidth = 60;
class Ability {
  String name;
  float cooldown = 0;
  float cdClock = 0;
  PGraphics pgIcon;
  Ability(String name) {
    this.name = name;
    pgIcon = createGraphics(abilityIconWidth, abilityIconWidth);
  }
  
  void activate() {
  }
  
  void tick() {
    cdClock -= frameTime;
    if (cdClock <= 0) {
      if (player.controls.lmbPressed) {
        activate();
        cdClock += cooldown;
      }
      else {
        cdClock = 0;
      }
    }
  }
  
  void appearance() {
    pgIcon.strokeWeight(8);
    pgIcon.stroke(255, 0, 0);
    pgIcon.line(0, 0, pgIcon.width, pgIcon.height);
    pgIcon.line(pgIcon.width, 0, 0, pgIcon.height);
  }
  
  void show() {
    fill(0);
    strokeWeight(3);
    stroke(0);
    rectMode(CORNER);
    rect(0, 0, abilityIconWidth, abilityIconWidth);
    
    pgIcon.beginDraw();
    pgIcon.clear();
    pgIcon.fill(40, 40, 60);
    pgIcon.noStroke();
    pgIcon.rect(0, 0, pgIcon.width, pgIcon.height);
    appearance();
    pgIcon.endDraw();
    image(pgIcon, 0, 0);
    
    fill(0, 150);
    noStroke();
    rect(0, 0, abilityIconWidth, abilityIconWidth * cdClock / cooldown);
  }
}

class AbilityShoot extends Ability {
  AbilityShoot() {
    super("shoot");
    
    cooldown = 1.2;
    
    bulletDamage = 3;
    bulletDiam = 6;
    bulletSpeed = 300;
    bulletMaxCollisions = 1;
  }
  
  float bulletDamage;
  float bulletDiam;
  float bulletSpeed;
  float bulletMaxCollisions;
  void activate() {
    playerBullets.add(new PBShoot(player.pos.copy(), player.dir));
  }
  
  void appearance() {
    pgIcon.noFill();
    pgIcon.strokeWeight(1);
    pgIcon.stroke(180, 220, 255);
    pgIcon.ellipse(15, pgIcon.height / 2, 4, 4);
    pgIcon.ellipse(30, pgIcon.height / 2, 4, 4);
    pgIcon.ellipse(45, pgIcon.height / 2, 4, 4);
  }
}
AbilityShoot abilityShoot;

void defAbilities() {
  abilityShoot = new AbilityShoot();
}