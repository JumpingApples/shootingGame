ArrayList<Upgrade> allUpgrades = new ArrayList<Upgrade>();
ArrayList<Upgrade> shipUpgrades = new ArrayList<Upgrade>();
ArrayList<Upgrade> ecUpgrades = new ArrayList<Upgrade>();

Upgrade findUpgrade(ArrayList<Upgrade> upgrades, String name) {
  for (int i = 0; i < upgrades.size(); i++) {
    if (upgrades.get(i).name == name) {
      return upgrades.get(i);
    }
  }
  return new Upgrade("Error", "", "", 0, new PVector(0, 0), shipUgIcons.get(0));
}

void defUpgrades() {
  allUpgrades = new ArrayList<Upgrade>();
  shipUpgrades = new ArrayList<Upgrade>();
  ecUpgrades = new ArrayList<Upgrade>();
  
  shipUpgrades.add(new Upgrade("Ship", "Chassis", "A ship capable of advanced movement\nthat can be equipped with\nspecial weapons", 0, new PVector(0, 0), shipUgIcons.get(0)));
  shipUpgrades.get(0).bought = true;
  shipUpgrades.add(new Upgrade("Shield Battery I", "Upgrade", "Increase maximum shield\nand shield regen by 20%", 150, new PVector(-75, -150), shipUgIcons.get(1)));
  shipUpgrades.get(shipUpgrades.size() - 1).prereqs.add(shipUpgrades.get(0));
  shipUpgrades.add(new Upgrade("Fortified Shell I", "Upgrade", "Increase maximum health\nby 25%", 120, new PVector(75, -150), shipUgIcons.get(2)));
  shipUpgrades.get(shipUpgrades.size() - 1).prereqs.add(shipUpgrades.get(0));
  shipUpgrades.add(new Upgrade("Thin Chassis I", "Upgrade", "Increase ship's maximum\nmovement speed by 20%", 200, new PVector(-75, 150), shipUgIcons.get(3)));
  shipUpgrades.get(shipUpgrades.size() - 1).prereqs.add(shipUpgrades.get(0));
  shipUpgrades.add(new Upgrade("Magnetic Field I", "Upgrade", "Increase loot collection\nrange by 50%", 120, new PVector(75, 150), shipUgIcons.get(4)));
  shipUpgrades.get(shipUpgrades.size() - 1).prereqs.add(shipUpgrades.get(0));
  
  ecUpgrades.add(new Upgrade("Energy Cannon", "Weapon", "Fires slow, piercing energy pellets", 0, new PVector(1000, 0), ecUgIcons.get(0)));
  ecUpgrades.get(0).bought = true;
  ecUpgrades.add(new Upgrade("Reactor Coolant I", "Upgrade", "Increase energy cannon\nattack speed by 20%", 120, new PVector(775, -150), ecUgIcons.get(1)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(ecUpgrades.get(0));
  ecUpgrades.add(new Upgrade("Reactor Coolant II", "Upgrade", "Increase energy cannon\nattack speed by 20%", 400, new PVector(775, -300), ecUgIcons.get(1)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(findUpgrade(ecUpgrades, "Reactor Coolant I"));
  ecUpgrades.add(new Upgrade("Reactor Coolant III", "Upgrade", "Increase energy cannon\nattack speed by 20%", 1000, new PVector(775, -450), ecUgIcons.get(1)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(findUpgrade(ecUpgrades, "Reactor Coolant II"));
  ecUpgrades.add(new Upgrade("Mass Generators I", "Upgrade", "Increase energy pellet\nsize and damage by 30%", 150, new PVector(925, -150), ecUgIcons.get(2)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(ecUpgrades.get(0));
  ecUpgrades.add(new Upgrade("Mass Generators II", "Upgrade", "Increase energy pellet\nsize and damage by 30%", 500, new PVector(925, -300), ecUgIcons.get(2)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(findUpgrade(ecUpgrades, "Mass Generators I"));
  ecUpgrades.add(new Upgrade("Mass Generators III", "Upgrade", "Increase energy pellet\nsize and damage by 30%", 1200, new PVector(925, -450), ecUgIcons.get(2)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(findUpgrade(ecUpgrades, "Mass Generators II"));
  ecUpgrades.add(new Upgrade("Pressurized Chamber I", "Upgrade", "Increase energy pellet\nmovement speed by 25%", 100, new PVector(1075, -150), ecUgIcons.get(3)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(ecUpgrades.get(0));
  ecUpgrades.add(new Upgrade("Pressurized Chamber II", "Upgrade", "Increase energy pellet\nmovement speed by 25%", 250, new PVector(1075, -300), ecUgIcons.get(3)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(findUpgrade(ecUpgrades, "Pressurized Chamber I"));
  ecUpgrades.add(new Upgrade("Pressurized Chamber III", "Upgrade", "Increase energy pellet\nmovement speed by 25%", 650, new PVector(1075, -450), ecUgIcons.get(3)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(findUpgrade(ecUpgrades, "Pressurized Chamber II"));
  ecUpgrades.add(new Upgrade("Superfluid Plasma I", "Function", "Energy pellets will now pierce\nthrough an enemy ship", 300, new PVector(1225, -150), ecUgIcons.get(4)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(ecUpgrades.get(0));
  ecUpgrades.add(new Upgrade("Superfluid Plasma II", "Function", "Energy pellets will now pierce\nthrough more enemy ships", 800, new PVector(1225, -300), ecUgIcons.get(4)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(findUpgrade(ecUpgrades, "Superfluid Plasma I"));
  ecUpgrades.add(new Upgrade("Superfluid Plasma III", "Function", "Energy pellets will now pierce\nthrough all enemy ships", 2000, new PVector(1225, -450), ecUgIcons.get(4)));
  ecUpgrades.get(ecUpgrades.size() - 1).prereqs.add(findUpgrade(ecUpgrades, "Superfluid Plasma II"));
  
  for (int i = 0; i < shipUpgrades.size(); i++) {
    allUpgrades.add(shipUpgrades.get(i));
  }
  for (int i = 0; i < ecUpgrades.size(); i++) {
    allUpgrades.add(ecUpgrades.get(i));
  }
}

final int ugIconBig = 100;
final int ugIconSmall = 80;
ArrayList<PImage> shipUgIcons = new ArrayList<PImage>();
ArrayList<PImage> ecUgIcons = new ArrayList<PImage>();
void drawUpgradeIcons() {
  shipUgIcons = new ArrayList<PImage>();
  ecUgIcons = new ArrayList<PImage>();
  
  // Ship 0
  background(30, 30, 50);
  noFill();
  strokeWeight(6);
  stroke(100, 200, 255);
  triangle(20, 35, 20, 65, 75, 50);
  shipUgIcons.add(get(0, 0, ugIconBig, ugIconBig));
  
  // S Shield 1
  background(30, 30, 50);
  noFill();
  strokeWeight(4);
  stroke(100, 200, 255);
  triangle(27, 33, 27, 47, 52, 40);
  stroke(160, 200, 255, 40);
  for (int i = 1; i < 5; i++) {
    strokeWeight(i);
    ellipse(40, 40, 55, 55);
  }
  shipUgIcons.add(get(0, 0, ugIconSmall, ugIconSmall));
  
  // S Health 2
  background(30, 30, 50);
  noFill();
  strokeWeight(6);
  stroke(100, 200, 255);
  triangle(20, 30, 20, 50, 55, 40);
  strokeWeight(4);
  stroke(120, 130, 140);
  triangle(17, 25, 17, 55, 60, 40);
  shipUgIcons.add(get(0, 0, ugIconSmall, ugIconSmall));
  
  // S Movement Speed 3
  background(30, 30, 50);
  fill(30, 30, 50);
  strokeWeight(4);
  stroke(100, 200, 255, 100);
  triangle(41, 39, 14, 54, 26, 66);
  stroke(100, 200, 255, 200);
  triangle(53, 27, 26, 42, 38, 54);
  stroke(100, 200, 255);
  triangle(65, 15, 38, 30, 50, 42);
  shipUgIcons.add(get(0, 0, ugIconSmall, ugIconSmall));
  
  // S Collection Range 4
  background(30, 30, 50);
  noFill();
  strokeWeight(4);
  stroke(100, 200, 255);
  triangle(13, 53, 27, 53, 20, 27);
  arc(20, 40, 36, 36, -PI / 8, PI / 8, OPEN);
  arc(20, 40, 50, 50, -PI / 8, PI / 8, OPEN);
  arc(20, 40, 66, 66, -PI / 8, PI / 8, OPEN);
  fill(240, 190, 30);
  strokeWeight(2);
  stroke(225, 160, 30);
  ellipse(65, 40, 8, 8);
  shipUgIcons.add(get(0, 0, ugIconSmall, ugIconSmall));
  
  // Energy Cannon 0
  background(30, 30, 50);
  noFill();
  strokeWeight(6);
  stroke(180, 220, 255);
  ellipse(50, 50, 60, 60);
  ecUgIcons.add(get(0, 0, ugIconBig, ugIconBig));
  
  // EC Attack Speed 1
  background(30, 30, 50);
  noFill();
  strokeWeight(4);
  stroke(180, 220, 255);
  ellipse(20, 60, 15, 15);
  ellipse(40, 40, 15, 15);
  ellipse(60, 20, 15, 15);
  ecUgIcons.add(get(0, 0, ugIconSmall, ugIconSmall));
  
  // EC Attack Damage 2
  background(30, 30, 50);
  noFill();
  strokeWeight(4);
  stroke(180, 220, 255, 150);
  ellipse(40, 40, 20, 20);
  stroke(180, 220, 255);
  ellipse(40, 40, 40, 40);
  ecUgIcons.add(get(0, 0, ugIconSmall, ugIconSmall));
  
  // EC Bullet Speed 3
  background(30, 30, 50);
  noFill();
  strokeWeight(4);
  stroke(180, 220, 255);
  ellipse(50, 30, 20, 20);
  stroke(180, 220, 255, 200);
  arc(40, 40, 20, 20, 0, PI + HALF_PI, OPEN);
  stroke(180, 220, 255, 100);
  arc(30, 50, 20, 20, 0, PI + HALF_PI, OPEN);
  ecUgIcons.add(get(0, 0, ugIconSmall, ugIconSmall));
  
  // EC Pierce 4
  background(30, 30, 50);
  noFill();
  strokeWeight(4);
  stroke(180, 220, 255, 100);
  triangle(65, 55, 65, 40, 53, 52);
  triangle(16, 40, 40, 32, 28, 43);
  stroke(180, 220, 255);
  ellipse(60, 28, 10, 10);
  stroke(180, 220, 255, 200);
  line(52, 36, 22, 66);
  ecUgIcons.add(get(0, 0, ugIconSmall, ugIconSmall));
  
}
