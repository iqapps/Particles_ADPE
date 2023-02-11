// Particle class
class Particle {
  PVector loc; // location
  PVector vel; // velocity
  PVector att;
  float heat = 0;
  float mass = 1;
  float size;
  boolean display;
  float newMass = 1;
  int ani = 0;
  int time = 0;
  int gAni = 10;
  int gTime = 2;
  float sFactor = 1.0;
  
  Particle(float x, float y) {
    // Initialize everything to 
    // default values
    sFactor = min(width, height) * 1.0 / 1440.0;
    loc = new PVector(x, y);
    vel = new PVector(x, y);
    vel.normalize();
    vel.mult(500);
    //vel.mult(r(1000 * sFactor));
    vel.rotate(HALF_PI);
    display = true;
    mass = sFactor;
    newMass = sFactor;
  }
  
  float r(float s)
  {
    return random(s) - (s / 2.0);
  }
  
  void setAni(int a)
  {
    ani = a;
    time = 0;
  }
  
  float radius(float mass)
  {
    return pow(3 * mass / (4 * PI), 1.0/3.0);
  }
  
  float newSize()
  {
    return 2 * radius(newMass);
  }
  
  void updateMass()
  {
    mass = newMass;
    size = 2 * radius(mass);
  }
  
  void update(int millis, Particle[] particles, int me, int density, float factor, float centerG)
  {
    // Re-calculate acceleration
    PVector pull = new PVector(-loc.x, -loc.y);
    pull.mult(centerG);
    att = new PVector(0,0);
    float hAdd = 0;
    
    for (int i = 0; i < particles.length; i ++)
    {
      Particle p = particles[i];
      
      if(p.display && i != me)
      {
        PVector drag = new PVector(p.loc.x - loc.x, p.loc.y - loc.y);
        float m = newMass + p.mass;

        if(i < me && drag.mag() < size && density > 0)
        {
          // println("join " + me + " and " + i);
          newMass = m;
          p.display = false;
          setAni(gAni);
          heat += 0.1F * p.vel.mag() * p.mass / m;
        }
 
        float dist = drag.mag();
        drag.normalize();
        drag.mult(density * p.mass / pow(dist, factor));
        hAdd = max(drag.mag(), hAdd);      
        att.add(drag);
      }
    }
 
    // Add changes to velocity
    vel.add(att);
    vel.add(pull);
    vel.limit(1000 * sFactor);
    
    float sf = 100.0 * mass * sFactor;
    heat *= (sf - 1) / sf;
    heat += 10F * hAdd / (mass * sFactor);
    heat = min(500, max(0, heat));
  }
  
  void display(int millis, Particle[] particles, int me, float minv, float maxv, int cmode) {
    // Don't display if invalid values or we're off-screen
    if(abs(loc.x) < ((width / 2) + size) &&
       abs(loc.y) < ((height / 2) + size))
    {
      float c = 180;
      
      // Color based on coloring arg using minv and maxv for ranges
      switch(cmode)
      {
        case 0: // color by size
        {
          c = colorMap(size - minv, maxv - minv);          
        }
        break;
        
        case 1: // color by speed
        {
          c = colorMap(vel.mag() - minv, maxv - minv);
        }
        break;
        
        case 2: // color by direction
        {
          PVector ref = new PVector(0, 0);
          ref.sub(loc);
          float rh = abs((ref.heading() - vel.heading() + TAU) % TAU);
          rh = rh > PI ? TAU - rh : rh;
          c = colorMap(rh, PI);
        }
        break;
        
        case 3: // color by heat
        {
          c = colorMap(heat, 500);
        }
        break;
      }
 
      stroke(c, maxSat, maxBgt, maxAlp);
      
      // Draw the point
      float s = (10 * sFactor) + (8 * size);
      
      pushMatrix();
      translate(sCenter.x, sCenter.y);
      
      strokeWeight(s);
      point(loc.x, loc.y);
      
      // Draw the vector
      strokeWeight(1.0);
      line(loc.x, loc.y, loc.x + (vel.x / 10.0), loc.y + (vel.y / 10.0));
      
      // add join action
      if(ani > 0)
      {
        stroke(180, maxSat, maxBgt, maxAlp);
        strokeWeight(2.0);
        fill(0);
        ellipse(loc.x, loc.y, sFactor * 10 * (size + (gAni - ani)), sFactor * 10 * (size + (gAni - ani)));
        time--;
        if(time <= 0)
        {
          ani--;
          time = (int)size;
        }
      }
      
      popMatrix();
    }
  }
  
  float colorMap(float v, float maxV)
  {
    return (60 + map(v, 0, maxV, 180, 360)) % 360;
  }
}
