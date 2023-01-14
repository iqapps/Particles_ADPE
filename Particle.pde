// Particle class
class Particle {
  PVector loc; // location
  PVector vel; // velocity
  PVector acc; // acceleration
  PVector rej; // reject
  int twin = -1;
  boolean twinned;
  
  Particle(float x, float y) {
    // Initialize everything to 
    // default values
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    rej = new PVector(0,0);
    twinned = false;
  }
  
  void update(Particle[] particles, int me, int twindist)
  {
    // Re-calculate acceleration
    acc.x = 0;
    acc.y = 0;
    
    PVector pull = new PVector((width / 2) - loc.x, (height / 2) - loc.y);
    pull.mult(0.005);

    PVector rej = new PVector(0,0);
    
    for (int i = 0; i < particles.length; i ++)
    {
      if(i != me && twin < 0)
      {
        Particle p = particles[i];
        PVector drag = new PVector(p.loc.x - loc.x, p.loc.y - loc.y);

        if(i < me && drag.mag() < twindist && p.twinned == false)
        {
          print("[" + me + "].twin=" + i + ", ");
          twin = i;
          p.twinned = true;
        }

        drag.mult(pow(100 / drag.mag(), 2));
        rej.add(drag);
      }
    }
    
    rej.mult(1.0 / particles.length);
  
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
        acc.x = mx - loc.x;
        acc.y = my - loc.y;
        
        // Normalize the vector
        acc.normalize();
        acc.mult(-10);
      }
    }
    
    // Add acceleration to velocity
    acc.add(rej);
    acc.add(pull);
    vel.add(acc);
  }
  
  void display(Particle[] particles, float minv, float maxv) {
    // Don't display if we're off-screen
    if (loc.x > 0 && loc.x < width &&
        loc.y > 0 && loc.y < height)
    {
      // Color based on position on
      // the screen and time
      float h = 36 + (((vel.mag() - minv) / (maxv - minv)) * (360 - 36));
      stroke(h, 100, 100, 100);
      
      // Draw the point
      if(twin >= 0)
      {
        int tw = 20;
        //while(particles[twin].twin >= 0)
        //{
         // tw += 5;
        //}
        
        strokeWeight(2);
        fill(0);
        ellipse(loc.x, loc.y, tw, tw);
      }
      else
      {
        strokeWeight(12);
        point(loc.x, loc.y);
      }
    }
  }
}
