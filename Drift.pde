/**
 * Drift
 * by CalsignLabs
 * 
 * Touch the screen to manipulate the 
 * particles. Multi-touch is supported.
 */

// Array of particles
Particle[] particles;
int partdist = 80;
int dispcnt = 1;
int display = dispcnt;

void setup() {
  // Use OpenGL
  fullScreen(OPENGL);

  // Set up random noise
  noiseDetail(16, 0.6);

  // Use HSB
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  strokeWeight(12);

  initGrid();
  //pg = createGraphics(width, height);
  //pg.colorMode(HSB, 360, 100, 100, 100);
}

void initGrid() {
  // Reset to a grid of particles

  // Space between particles
  int inc = partdist;
  // Number of particles that will fit
  int px = (int) width / inc;
  int py = (int) height / inc;

  // Initialize particle array
  particles = new Particle[px * py];

  // Populate particle array in a 
  // grid of reguarly-spaced particles
  int cur = 0;
  for (int x = 0; x < px; x ++) {
    for (int y = 0; y < py; y ++) {
      float dx = 2.0 * inc * (random(1.0) - 0.5);
      float dy = 2.0 * inc * (random(1.0) - 0.5);
      particles[cur] = new Particle(
        (inc / 2 + x * inc) + dx, 
        (inc / 2 + y * inc) + dy);
      cur ++;
    }
  }
}

void draw() {
  try
  {

    float minv = 3000.0;
    float maxv = 0.0;

    // Cycle through the particles
    for (int i = 0; i < particles.length; i ++) 
    {
      Particle pi = particles[i];

      if (pi.display)
      {
        particles[i].update(particles, i);
      }
    }

    // Cycle through the particles
    for (int i = 0; i < particles.length; i ++) 
    {
      Particle pi = particles[i];

      if (pi.display)
      {
        particles[i].size = particles[i].newSize;
      }
    }

    for (int i = 0; i < particles.length; i ++)
    {
      Particle pi = particles[i];
      
      if (pi.display)
      {
        minv = min(minv, pi.vel.mag());
        maxv = max(maxv, pi.vel.mag());
      }
    }

    for (int i = 0; i < particles.length; i++)
    { 
      Particle pi = particles[i];

      if (pi.display)
      {
        pi.loc.x += pi.vel.x / particles.length;
        pi.loc.y += pi.vel.y / particles.length;
      }
    }

    if (display <= 0)
    {
      display = dispcnt;
      background(0);
      int left = 0;

      for (int i = 0; i < particles.length; i ++)
      {
        Particle pi = particles[i];

        if (pi.display)
        {
          pi.display(particles, minv, maxv);
          left++;
        }
      }
      
      fill(100, 100,100);
      textSize(100);
      text("" + left, 10, 120);
    }

    display--;
  }
  catch(Exception ex)
  {
    println("Ex:"+ex);
  }
}
