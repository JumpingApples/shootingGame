// This project was started on March 14, 2018
// The goal is to make a bullet-hell style shooter
// This sketch was created by Richard Wen

/* CONTROLS
WASD to move
LMB to shoot
E to open upgrade menu
L to toggle debug mode
1 and 2 to spawn enemies
*/

boolean debugMenu = true;
int debugState = 0;
void debug() {
  fill(255);
  textFont(debugFont);
  textAlign(LEFT, BOTTOM);
  
  switch (debugState) {
  case 0:
    break;
  case 1:
    text("Game Data", 50, 40);
    text("Frame Rate: " + frameRate, 50, 60);
    text("Game State: " + gameState, 50, 80);
    text("Cam Coords: " + camCoords.x, 50, 100);
    text(camCoords.y, 250, 100);
    break;
  case 2:
    text("Colliders", 50, 40);
    break;
  case 3:
    text("Player", 50, 40);
    text("Health: " + str(player.health) + " / " + str(player.maxHealth), 50, 60);
    text("Shields: " + str(player.shields) + " / " + str(player.maxShields), 50, 80);
    break;
  default:
    debugState = 0;
    break;
  }
}

PVector vectorMove(PVector direction, float distance) {
  float x = distance / pow(pow(direction.x / direction.y, 2) + 1, 0.5);
  float y = distance / pow(pow(direction.y / direction.x, 2) + 1, 0.5);
  return new PVector(x, y);
}

float sqr(float n) {
  return n * n;
}
int sign(float n) {
  if (n > 0) {
    return 1;
  }
  if (n < 0) {
    return -1;
  }
  return 0;
}
float u(PVector coord, float angle) {
  return coord.x * cos(angle) + coord.y * sin(angle);
}
float v(PVector coord, float angle) {
  return coord.y * cos(angle) - coord.x * sin(angle);
}

boolean lineCollision(PVector p11, PVector p12, PVector p21, PVector p22) {
  float angle1 = atan((p12.y - p11.y) / (p12.x - p11.x));
  float angle2 = atan((p22.y - p21.y) / (p22.x - p21.x));
  if (sign(v(p21, angle1)) * sign(v(p22, angle1)) == -1 && sign(v(p11, angle2)) * sign(v(p12, angle2)) == -1) {
    return true;
  }
  return false;
}

PVector inCam(PVector pos) {
  return new PVector(pos.x - camCoords.x, pos.y - camCoords.y);
}

class PFloat {
  float n;
  PFloat(float n) {
    this.n = n;
  }
}

void checkCanvasLimits() {
  if (canvasCenter.x + 0.5 * canvasWidth * upgScale < width) {
    canvasCenter.x = width - 0.5 * canvasWidth * upgScale;
  }
  if (canvasCenter.x - 0.5 * canvasWidth * upgScale > 0) {
    canvasCenter.x = 0.5 * canvasWidth * upgScale;
  }
  if (canvasCenter.y + 0.5 * canvasHeight * upgScale < height) {
    canvasCenter.y = height - 0.5 * canvasHeight * upgScale;
  }
  if (canvasCenter.y - 0.5 * canvasHeight * upgScale > 0) {
    canvasCenter.y = 0.5 * canvasHeight * upgScale;
  }
}

PFont debugFont;
PFont moneyFont;

String gameState = "play";
float playTime;
float time = 0;
void setup() {
  size(1000, 750);
  frameRate(60);
  cursor(CROSS);
  playTime = 0;
  
  debugFont = createFont("Lucida Sans", 12);
  upgHovTextFont = createFont("Georgia", 16);
  moneyFont = createFont("Georgia", 32);
  upgMenSmallTextFont = createFont("Georgia", 16);
  upgMenLargeTextFont = createFont("Georgia", 24);
  pgOverlay = createGraphics(width, height);
  
  camCoords = new PVector(0, 0);
  
  canvasWidth = 4800;
  canvasHeight = canvasWidth * height / width;
  canvasCenter = new PVector(width / 2, height / 2);
  scrollScale = 2.8;
  upgScale = float(width) / float(canvasWidth) * scrollScale;
  
  defAbilities();
  drawUpgradeIcons();
  defUpgrades();
  selectedUpgrade = allUpgrades.get(0);
  
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (random(6400) < 1) {
        stars.add(new Star(new PVector(i, j)));
      }
    }
  }
  player = new Player();
}

PVector camCoords;
float inCamLimit = 0.3;

int canvasWidth = 4800;
int canvasHeight = 3600;
float scrollScale;
float scaleChange = 0.8;
float upgScale;
boolean panning = false;
PVector panStart;
float panStartTime;
PVector panCenter;
PVector canvasCenter;
boolean upgradeClicked = false;
Upgrade clickedUpgrade;
boolean upgradeSelected = false;
Upgrade selectedUpgrade;
float selectorStartTime;
boolean buyButtonClicked = false;

float frameTime;
void draw() {
  frameTime = 1.0 / frameRate;
  time += frameTime;
  switch (gameState) {
  case "play":
    playTime += frameTime;
    background(0);
    strokeWeight(1);
    stroke(255);
    for (int i = 0; i < stars.size(); i++) {
      stars.get(i).show();
    }
    
    player.tick();
    player.move();
    for (int i = 0; i < player.abilities.length; i++) {
      player.abilities[i].tick();
    }
    for (int i = explosions.size() - 1; i >= 0; i--) {
      explosions.get(i).tick();
    }
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      playerBullets.get(i).move();
    }
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      playerBullets.get(i).checkCollision();
    }
    for (int i = bullets.size() - 1; i >= 0; i--) {
      bullets.get(i).move();
    }
    for (int i = allLoot.size() - 1; i >= 0; i--) {
      allLoot.get(i).tick();
    }
    
    for (int i = allShips.size() - 1; i >= 0; i--) {
      allShips.get(i).move();
      allShips.get(i).checkCollision();
    }
    
    for (int i = 0; i < allLoot.size(); i++) {
      allLoot.get(i).show();
    }
    player.showShip();
    for (int i = 0; i < allShips.size(); i++) {
      allShips.get(i).show();
    }
    for (int i = 0; i < explosions.size(); i++) {
      explosions.get(i).show();
    }
    for (int i = 0; i < playerBullets.size(); i++) {
      playerBullets.get(i).show();
    }
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).show();
    }
    
    tint(255, (player.fullHealthClock + 2) * 255);
    image(player.pgHealthBar, 0, 0);
    tint(255, 255);
    
    imageMode(CORNER);
    player.showAbilities();
    
    textFont(moneyFont);
    textAlign(LEFT, TOP);
    fill(255, 230, 100);
    text(str(player.currency) + "C", 0, 0);
    
    break;
    
  case "upgrade":
    if (panning) {
      canvasCenter.x = panCenter.x + (mouseX - panStart.x);
      canvasCenter.y = panCenter.y + (mouseY - panStart.y);
      checkCanvasLimits();
    }
    
    pushMatrix();
    translate(canvasCenter.x, canvasCenter.y);
    scale(upgScale);
    
    background(40, 35, 35);
    
    for (int i = 0; i < allUpgrades.size(); i++) {
      allUpgrades.get(i).showConnections();
    }
    for (int i = 0; i < allUpgrades.size(); i++) {
      allUpgrades.get(i).showIcons();
    }
    
    if (upgradeSelected) {
      drawUpgradeSelector(selectedUpgrade);
    }
    
    popMatrix();
    
    if (upgradeSelected) {
      selectedUpgrade.showMenu();
    }
    for (int i = 0; i < allUpgrades.size(); i++) {
      if (allUpgrades.get(i).hovered()) {
        allUpgrades.get(i).showHoverText();
      }
    }
    
    textFont(moneyFont);
    textAlign(LEFT, TOP);
    fill(255, 230, 100);
    text(str(player.currency) + "C", 0, 0);
    
    break;
    
  default:
    println("Error: entered unknown gameState \"" + gameState + "\"");
    break;
  }
  
  if (debugMenu) {
    debug();
  }
}

void keyPressed() {
  if (key == player.controls.upKey) {
    player.controls.upPressed = true;
  }
  if (key == player.controls.downKey) {
    player.controls.downPressed = true;
  }
  if (key == player.controls.leftKey) {
    player.controls.leftPressed = true;
  }
  if (key == player.controls.rightKey) {
    player.controls.rightPressed = true;
  }
  if (key == 'e') {
    if (gameState == "play") {
      gameState = "upgrade";
      panStart = new PVector(mouseX, mouseY);
    }
    else if (gameState == "upgrade") {
      gameState = "play";
    }
  }
  if (key == 'l') {
    debugState++;
  }
  if (debugMenu) {
    if (key == '1') {
      allShips.add(new Chaser(new PVector(random(camCoords.x, width + camCoords.x), random(camCoords.y, height + camCoords.y)), new PFloat(random(2 * PI))));
    }
    if (key == '2') {
      allShips.add(new Shooter(new PVector(random(camCoords.x, width + camCoords.x), random(camCoords.y, height + camCoords.y)), new PFloat(random(2 * PI))));
    }
  }
}

void keyReleased() {
  if (key == player.controls.upKey) {
    player.controls.upPressed = false;
  }
  if (key == player.controls.downKey) {
    player.controls.downPressed = false;
  }
  if (key == player.controls.leftKey) {
    player.controls.leftPressed = false;
  }
  if (key == player.controls.rightKey) {
    player.controls.rightPressed = false;
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    player.controls.lmbPressed = true;
  }
  if (gameState == "upgrade") {
    buyButtonClicked = false;
    upgradeClicked = false;
    if (mouseX < width - upgMenuWidth - upgMenuOutline || mouseY > upgMenuHeight + upgMenuOutline) {
      panning = true;
      panStart = new PVector(mouseX, mouseY);
      panStartTime = time;
      panCenter = new PVector(canvasCenter.x, canvasCenter.y);
      for (int i = 0; i < allUpgrades.size(); i++) {
        if (allUpgrades.get(i).hovered()) {
          upgradeClicked = true;
          clickedUpgrade = allUpgrades.get(i);
          break;
        }
      }
    }
    else if (upgradeSelected) {
      if (selectedUpgrade.buyButtonHovered() && selectedUpgrade.buyable() && !selectedUpgrade.bought && player.currency >= selectedUpgrade.price) {
        buyButtonClicked = true;
      }
    }
  }
}

void mouseReleased() {
  if (mouseButton == LEFT) {
    player.controls.lmbPressed = false;
  }
  if (gameState == "upgrade") {
    panning = false;
    if (time - panStartTime < 0.15) {
      upgradeSelected = false;
      if (upgradeClicked) {
        for (int i = 0; i < allUpgrades.size(); i++) {
          if (allUpgrades.get(i).hovered()) {
            upgradeSelected = true;
            selectedUpgrade = allUpgrades.get(i);
            selectorStartTime = time;
            break;
          }
        }
      }
    }
    else if (upgradeSelected) {
      if (selectedUpgrade.buyButtonHovered() && buyButtonClicked) {
        player.currency -= selectedUpgrade.price;
        selectedUpgrade.bought = true;
        getUpgrade(selectedUpgrade);
      }
    }
    buyButtonClicked = false;
    upgradeClicked = false;
  }
}

void mouseWheel(MouseEvent event) {
  if (gameState == "upgrade") {
    if ((mouseX < width - upgMenuWidth - upgMenuOutline || mouseY > upgMenuHeight + upgMenuOutline) && !panning && event.getCount() != 0) {
      float pscrollScale = scrollScale;
      scrollScale *= pow(scaleChange, event.getCount());
      if (scrollScale < 1) {
        scrollScale = 1;
      }
      if (scrollScale > 4) {
        scrollScale = 4;
      }
      canvasCenter.x -= (mouseX - canvasCenter.x) * (scrollScale / pscrollScale - 1);
      canvasCenter.y -= (mouseY - canvasCenter.y) * (scrollScale / pscrollScale - 1);
      upgScale = float(width) / float(canvasWidth) * scrollScale;
      checkCanvasLimits();
    }
  }
}
