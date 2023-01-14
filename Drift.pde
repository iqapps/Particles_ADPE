/**
 * Drift
 * by CalsignLabs
 * 
 * Touch the screen to manipulate the 
 * particles. Multi-touch is supported.
 */

// Array of particles
Particle[] particles;
Particle[] particlesNew;
Particle[] particlesDis;
int display = 0;
int twindist = 3;
PGraphics pg;

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
  int inc = 120;
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
      float dx = inc / 2 *(random(1) - 0.5);
      float dy = inc / 2 *(random(1) - 0.5);
      particles[cur] = new Particle(
          (inc / 2 + x * inc) + dx, 
          (inc / 2 + y * inc) + dy);
      cur ++;
    }
  }
}

void draw() {
  float minv = 30.0;
  float maxv = 0.0;
  
  particlesNew = particles;
  
  // Cycle through the particles
  for (int i = 0; i < particles.length; i ++) 
  {
    particlesNew[i].update(particles, i, twindist);
  }
  
  particles = particlesNew;
  
  for (int i = 0; i < particles.length; i ++)
  {
    Particle p = particles[i];
    p.vel.add(p.acc);
    minv = min(minv, p.vel.mag());
    maxv = max(maxv, p.vel.mag());
  }
  
  for (int i = 0; i < particles.length; i++)
  {
    Particle p = particles[i];
    
    if(p.twin >= 0 && p.twin < particles.length)
    {
      //p.loc = particles[p.twin].loc;
      p.vel = particles[p.twin].vel;
    }
    else
    {
      p.vel.mult(twindist / maxv);
      p.loc.add(p.vel);
      p.vel.mult(maxv / twindist);
    }
  }
  
  if(display <= 0)
  {
    display = 1;
    background(0);
    
    for (int i = 0; i < particles.length; i ++)
    {
      particles[i].display(particles, minv, maxv);
    }
  }
  
  display--;
}