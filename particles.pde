class Star {
  PVector pos;
  PVector ppos;
  PVector pppos;
  Star(PVector pos) {
    this.pos = pos;
    this.ppos = pos;
    this.pppos = pos;
  }
  
  void show() {
    stroke(50);
    point(pppos.x, pppos.y);
    stroke(120);
    point(ppos.x, ppos.y);
    
    stroke(255);
    PVector posInCam = inCam(pos);
    PVector posDrawn = new PVector(posInCam.x - width * floor(posInCam.x / width), posInCam.y - height * floor(posInCam.y / height));
    point(posDrawn.x, posDrawn.y);
    
    pppos = ppos;
    ppos = posDrawn;
  }
}
ArrayList<Star> stars = new ArrayList<Star>();

class Explosion {
  PVector pos;
  float time;
  float duration;
  float maxDiameter;
  Explosion(PVector pos, float duration, float maxDiameter) {
    this.pos = pos;
    this.duration = duration;
    this.maxDiameter = maxDiameter;
    time = 0;
  }
  
  void tick() {
    time += frameTime;
    if (time > duration) {
      explosions.remove(explosions.indexOf(this));
    }
  }
  
  void show() {
    float progress = time / duration;
    float diameter = maxDiameter * progress;
    PVector posInCam = inCam(pos);
    
    pushMatrix();
    translate(posInCam.x, posInCam.y);
    
    noFill();
    stroke(255, 120 + 135 * progress, 255 * progress, 30 * (1 - progress));
    for (int i = 1; i < 12; i++) {
      strokeWeight(i);
      ellipse(0, 0, diameter, diameter);
    }
    
    popMatrix();
  }
}
ArrayList<Explosion> explosions = new ArrayList<Explosion>();