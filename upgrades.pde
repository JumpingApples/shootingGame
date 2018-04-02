float upgMenuWidth = 300;
float upgMenuHeight = 200;
float upgMenuOutline = 4;
PFont upgHovTextFont;
PFont upgMenSmallTextFont;
PFont upgMenLargeTextFont;
class Upgrade {
  boolean bought;
  String name;
  String type;
  String desc;
  int price;
  ArrayList<Upgrade> prereqs = new ArrayList<Upgrade>();
  PVector center;
  PImage upgradeIcon;
  
  color menuFill = color(60, 60, 80, 200);
  color menuStroke = color(30, 30, 40, 200);
  Upgrade(String name, String type, String desc, int price, PVector center, PImage upgradeIcon) {
    this.name = name;
    this.type = type;
    this.desc = desc;
    this.price = price;
    this.center = center;
    this.upgradeIcon = upgradeIcon;
    bought = false;
  }
  
  boolean buyable() {
    for (int i = 0; i < prereqs.size(); i++) {
      if (prereqs.get(i).bought) {
        return true;
      }
    }
    return false;
  }
  
  boolean hovered() {
    float tranMouseX = (mouseX - canvasCenter.x) / upgScale;
    float tranMouseY = (mouseY - canvasCenter.y) / upgScale;
    if (tranMouseX >= center.x - ugIconBig / 2 && tranMouseX <= center.x + ugIconBig / 2 && tranMouseY >= center.y - ugIconBig / 2 && tranMouseY <= center.y + ugIconBig / 2) {
      return true;
    }
    return false;
  }
  
  void showHoverText() {
    pushMatrix();
    translate(mouseX, mouseY);
    
    textFont(upgHovTextFont);
    int lineCount = 2;
    float lineHeight = textAscent() + textDescent();
    float textHeight = lineCount * lineHeight;
    float textWidth = textWidth(name) + textWidth(str(price) + "C") + 20;
    
    fill(menuFill);
    strokeWeight(1);
    stroke(menuStroke);
    rectMode(CORNER);
    rect(0, 0, textWidth + 10, textHeight + 8);
    
    textAlign(LEFT, TOP);
    fill(100, 200, 255);
    text(name, 5, 3);
    fill(200, 255, 100);
    text(type, 5, 3 + lineHeight);
    textAlign(RIGHT, TOP);
    fill(255, 230, 100);
    text(str(price) + "C", textWidth + 5, 3);
    
    popMatrix();
  }
  
  void showConnections() {
    strokeWeight(5);
    for (int i = 0; i < prereqs.size(); i++) {
      if (prereqs.get(i).bought) {
        stroke(100, 150, 190);
      }
      else {
        stroke(50, 75, 85);
      }
      line(center.x, center.y, prereqs.get(i).center.x, prereqs.get(i).center.y);
    }
  }
  
  void showIcons() {
    rectMode(CENTER);
    fill(0);
    strokeWeight(10);
    if (bought) {
      stroke(100, 150, 190);
    }
    else {
      stroke(50, 75, 85);
    }
    imageMode(CENTER);
    rect(center.x, center.y, upgradeIcon.width, upgradeIcon.height);
    
    image(upgradeIcon, center.x, center.y);
  }
  
  boolean buyButtonHovered() {
    float newMouseX = mouseX - (width - upgMenuOutline / 2);
    float newMouseY = mouseY - upgMenuOutline / 2;
    if (newMouseX > buyButtonCenter.x - buyButtonDimens.x / 2 && newMouseX < buyButtonCenter.x + buyButtonDimens.x / 2 && newMouseY > buyButtonCenter.y - buyButtonDimens.y / 2 && newMouseY < buyButtonCenter.y + buyButtonDimens.y / 2) {
      return true;
    }
    return false;
  }
  
  PVector buyButtonCenter;
  PVector buyButtonDimens;
  void showMenu() {
    pushMatrix();
    translate(width - upgMenuOutline / 2, upgMenuOutline / 2);
    
    fill(menuFill);
    strokeWeight(upgMenuOutline);
    stroke(menuStroke);
    rect(0, 0, -upgMenuWidth, upgMenuHeight);
    
    textFont(upgMenLargeTextFont);
    textAlign(CENTER, TOP);
    fill(100, 200, 255);
    text(name, -upgMenuWidth / 2, 5);
    
    textAlign(CENTER, CENTER);
    fill(255, 230, 100);
    text(str(price) + "C", -0.75 * upgMenuWidth, upgMenuHeight - 22);
    
    buyButtonCenter = new PVector(-0.25 * upgMenuWidth, upgMenuHeight - 22);
    buyButtonDimens = new PVector(90, 30);
    color buttonDisabledC = color(225, 20, 20);
    color buttonDisabledDownC = color(215, 20, 20);
    color buttonUpC = color(15, 255, 55);
    color buttonDownC = color(15, 205, 45);
    color buttonClickedC = color(12, 180, 40);
    rectMode(CENTER);
    strokeWeight(2);
    stroke(40, 10, 5);
    if (bought) {
      fill(buttonUpC);
      rect(buyButtonCenter.x, buyButtonCenter.y, buyButtonDimens.x, buyButtonDimens.y);
      fill(20);
      text("Owned", -0.25 * upgMenuWidth, upgMenuHeight - 22);
    }
    else {
      if (player.currency < price || !buyable()) {
        if (buyButtonHovered()) {
          fill(buttonDisabledDownC);
        }
        else {
          fill(buttonDisabledC);
        }
        rect(-0.25 * upgMenuWidth, upgMenuHeight - 22, 90, 30);
        fill(20);
        text("Buy", -0.25 * upgMenuWidth, upgMenuHeight - 22);
      }
      else {
        if (buyButtonClicked) {
          fill(buttonClickedC);
        }
        else if (buyButtonHovered()) {
          fill(buttonDownC);
        }
        else {
          fill(buttonUpC);
        }
        rect(-0.25 * upgMenuWidth, upgMenuHeight - 22, 90, 30);
        fill(20);
        text("Buy", -0.25 * upgMenuWidth, upgMenuHeight - 22);
      }
    }
    
    textAlign(CENTER, CENTER);
    textFont(upgMenSmallTextFont);
    fill(25, 105, 255);
    text(desc, -upgMenuWidth / 2, upgMenuHeight / 2);
    
    popMatrix();
  }
}

void drawUpgradeSelector(Upgrade upgrade) {
  float selHalfWid = (upgrade.upgradeIcon.width + 32) / 2;
  float rectLen = 30;
  float rectWid = 8;
  
  rectMode(CORNER);
  fill(255, 128 - 128 * cos(4 * (time - selectorStartTime)));
  noStroke();
  rect(upgrade.center.x - selHalfWid + rectWid, upgrade.center.y - selHalfWid, rectLen - rectWid, rectWid);
  rect(upgrade.center.x - selHalfWid, upgrade.center.y - selHalfWid, rectWid, rectLen);
  rect(upgrade.center.x + selHalfWid - rectWid, upgrade.center.y - selHalfWid, -rectLen + rectWid, rectWid);
  rect(upgrade.center.x + selHalfWid, upgrade.center.y - selHalfWid, -rectWid, rectLen);
  rect(upgrade.center.x - selHalfWid + rectWid, upgrade.center.y + selHalfWid, rectLen - rectWid, -rectWid);
  rect(upgrade.center.x - selHalfWid, upgrade.center.y + selHalfWid, rectWid, -rectLen);
  rect(upgrade.center.x + selHalfWid - rectWid, upgrade.center.y + selHalfWid, -rectLen + rectWid, -rectWid);
  rect(upgrade.center.x + selHalfWid, upgrade.center.y + selHalfWid, -rectWid, -rectLen);
}

void getUpgrade(Upgrade upgrade) {
  if (upgrade == findUpgrade(shipUpgrades, "Shield Battery I") || upgrade == findUpgrade(shipUpgrades, "Shield Battery II") || upgrade == findUpgrade(shipUpgrades, "Shield Battery III")) {
    float pMaxShields = player.maxShields;
    float fMaxShields = pMaxShields * 1.2;
    player.maxShields = fMaxShields;
    player.shields += fMaxShields - pMaxShields;
    player.shieldRegen *= 1.2;
  }
  if (upgrade == findUpgrade(shipUpgrades, "Fortified Shell I") || upgrade == findUpgrade(shipUpgrades, "Fortified Shell II") || upgrade == findUpgrade(shipUpgrades, "Fortified Shell III")) {
    float pMaxHealth = player.maxHealth;
    float fMaxHealth = pMaxHealth * 1.25;
    player.maxHealth = fMaxHealth;
    player.health += fMaxHealth - pMaxHealth;
  }
  if (upgrade == findUpgrade(shipUpgrades, "Thin Chassis I") || upgrade == findUpgrade(shipUpgrades, "Thin Chassis II") || upgrade == findUpgrade(shipUpgrades, "Thin Chassis III")) {
    player.maxVel *= 1.2;
  }
  if (upgrade == findUpgrade(shipUpgrades, "Magnetic Field I") || upgrade == findUpgrade(shipUpgrades, "Magnetic Field II") || upgrade == findUpgrade(shipUpgrades, "Magnetic Field III")) {
    player.collectionRange *= 1.5;
  }
  
  if (upgrade == findUpgrade(ecUpgrades, "Reactor Coolant I") || upgrade == findUpgrade(ecUpgrades, "Reactor Coolant II") || upgrade == findUpgrade(ecUpgrades, "Reactor Coolant III")) {
    abilityShoot.cooldown /= 1.2;
  }
  if (upgrade == findUpgrade(ecUpgrades, "Mass Generators I") || upgrade == findUpgrade(ecUpgrades, "Mass Generators II") || upgrade == findUpgrade(ecUpgrades, "Mass Generators III")) {
    abilityShoot.bulletDamage *= 1.3;
    abilityShoot.bulletDiam *= 1.3;
  }
  if (upgrade == findUpgrade(ecUpgrades, "Pressurized Chamber I") || upgrade == findUpgrade(ecUpgrades, "Pressurized Chamber II") || upgrade == findUpgrade(ecUpgrades, "Pressurized Chamber III")) {
    abilityShoot.bulletSpeed *= 1.25;
  }
  if (upgrade == findUpgrade(ecUpgrades, "Superfluid Plasma I")) {
    abilityShoot.bulletMaxCollisions = 2;
  }
  if (upgrade == findUpgrade(ecUpgrades, "Superfluid Plasma II")) {
    abilityShoot.bulletMaxCollisions = 4;
  }
  if (upgrade == findUpgrade(ecUpgrades, "Superfluid Plasma III")) {
    abilityShoot.bulletMaxCollisions = 100;
  }
}