	// Particle class
class Particle {
  PVector loc; // location
  PVector vel; // velocity
  float size = 1;
  boolean display;
  float newSize = 1;
  int ani = 0;
  int time = 0;
  int gAni = 10;
  int gTime = 2;
  
  Particle(float x, float y) {
    // Initialize everything to 
    // default values
    loc = new PVector(x, y);
    vel = new PVector(r(200), r(200));
    display = true;
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
  
  float weight()
  {
    return 4 * PI * size * size * size / 3;
  }
  
  float newWeight()
  {
    return 4 * PI * newSize * newSize * newSize / 3;
  }
  
  void update(Particle[] particles, int me)
  {
    // Re-calculate acceleration
    PVector pull = new PVector((width / 2) - loc.x, (height / 2) - loc.y);
    pull.mult(0.005);
    PVector att = new PVector(0,0);
    
    for (int i = 0; i < particles.length; i ++)
    {
      Particle p = particles[i];
      
      if(p.display && i != me)
      {
        PVector drag = new PVector(p.loc.x - loc.x, p.loc.y - loc.y);
        float w = newWeight() + p.weight();
        float s = (size + p.size) / 2.0;

        if(i < me && drag.mag() < s)
        {
          println("join " + me + " and " + i);
          newSize = (float)Math.cbrt(3 * w / (4 * PI));
          p.display = false;
          setAni(gAni);
        }
 
        float dist = drag.mag();
        drag.normalize();
        drag.mult(5 * p.weight() / pow(dist, 2));
        att.add(drag);
      }
    }
  
    
    // Add changes to velocity
    vel.add(att);
    vel.add(pull);
    vel.limit(1000);
  }
  
  void display(Particle[] particles, float minv, float maxv, int coloring) {
    // Don't display if invalid values or we're off-screen
    if(loc.x > 0 && loc.x < width &&
        loc.y > 0 && loc.y < height)
    {
      float c = 180;
      
      // Color based on coloring arg using minv and maxv for ranges
      switch(coloring)
      {
        case 0: // color by size
        {
          c = 36 + (((size - minv) / (maxv - minv)) * (360 - 36));          
        }
        break;
        
        case 1: // color by speed
        {
          c = 36 + (((vel.mag() - minv) / (maxv - minv)) * (360 - 36));
        }
        break;
        
        case 2: // color by direction
        {
          c = 0 + (vel.heading() / TAU) * (360 - 0);
        }
        break;      }
      
      stroke(c, 100, 100, 100);
      
      // Draw the point
      strokeWeight(10 + (8 * size));
      point(loc.x, loc.y);
      strokeWeight(1.0);
      line(loc.x, loc.y, loc.x + (vel.x / 10), loc.y + (vel.y / 10));
      
      // add join action
      if(ani > 0)
      {
        stroke(180, 100, 100, 100);
        strokeWeight(2.0);
        fill(0);
        ellipse(loc.x, loc.y, 10 * (gAni - ani), 10 * (gAni - ani));
        time--;
        if(time <= 0)
        {
          ani--;
          time = (int)size;
        }
      }
    }
  }
}
