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
    PVector mou = new PVector(0,0);
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
  
    if (mousePressed) {
      // Calculate average of all 
      // touch locations
      
      float mx = 0;
      float my = 0;
      
      // Add the positions
      for (int i = 0; i < touches.length; i ++) {
        mx += touches[i].x;
        my += touches[i].y;
      }
      
      // Compute average
      mx = mx / touches.length;
      my = my / touches.length;
      
      if (!(mx != mx || my != my)) {
        // Calculate acceleration based
        // on relative location to the
        // average of the touch points
        mou.x = mx - loc.x;
        mou.y = my - loc.y;
        
        // Normalize the vector
        mou.normalize();
        mou.mult(1);
      }
    }
    
    // Add changes to velocity
    vel.add(att);
    vel.add(pull);
    vel.add(mou);
    vel.limit(1000);
  }
  
  void display(Particle[] particles, float minv, float maxv) {
    // Don't display if invalid values or we're off-screen
    if(loc.x > 0 && loc.x < width &&
        loc.y > 0 && loc.y < height)
    {
      // Color based on position on
      // the screen and time
      float h = 36 + (((vel.mag() - minv) / (maxv - minv)) * (360 - 36));
      stroke(h, 100, 100, 100);
      
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
