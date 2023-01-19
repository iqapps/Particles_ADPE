/**
 * Drift
 * by CalsignLabs
 * 
 * Touch the screen to manipulate the 
 * particles. Multi-touch is supported.
 */

// Array of particles
Particle[] particles;
int initObjects = 361;
int dispcnt = 1;
int display = dispcnt;
int startSecs;
int coloring = 3;
//float coloringX = width;
boolean mHandled = false;
String[] cmodes = {"SIZE", "SPEED", "HEADING", "HEAT"};;
String[] rmodes = {"BIG BANG", "KABOOM"};
int weight = -25;
float factor = 1.9;
int reset = 0;
float maxSs = 0;

void setup() 
{
  maxSs = 0;
  reset = 0;
  weight = -25;
  factor = 1.9;
  mHandled = false;
  coloring = 3;
  
  
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
  
  startSecs = getTime();
}

void initGrid() 
{
  // Reset to a grid of particles

  // Space between particles
  
  // Number of particles that will fit
  int d = (int)round(sqrt(initObjects));
  int dxy = 0; //(int)(wh / d);
  int xo = (width - (dxy * d)) / 2;
  int yo = (height - (dxy * d)) / 2;

  // Initialize particle array
  particles = new Particle[d * d];

  // Populate particle array in a 
  // grid of reguarly-spaced particles
  int cur = 0;
  for (int x = 0; x < d; x ++) {
    for (int y = 0; y < d; y ++) {
     
      float dx = 50 * (random(1.0) - 0.5);
      float dy = 50 * (random(1.0) - 0.5);
      
      // particles[cur] = new Particle(xo + dx + (x * dxy), yo + dy + (y * dxy));
      particles[cur] = new Particle(xo + dx, yo + dy);
      cur ++;
    }
  }
}

void draw() 
{
  try
  {
    float minv = 3000.0;
    float maxv = 0.0;
    
    if (mousePressed)
    {
      if(mHandled == false)
      {
        mHandled = true;
        // Calculate average of all 
        // touch locations
      
        float mx = 0;
        float my = 0;
      
        // Add the positions
        if(touches.length == 1)
        {
          mx += touches[0].x;
          my += touches[0].y;
        }
      
        if(my > (3 * height / 4))
        {
          if(mx < (width / 4))
          {
            coloring = (coloring + 1) % cmodes.length;
          }
          else
          if(mx > (3 * width / 4))
          {
            if(reset == 0)
            {
              reset();
            }
            else
            {
              setup();
            }
          }
        }
      }
    }
    else
    {
      mHandled = false;
    }
    
    float speedSum = 0;

    // Cycle through the particles
    for (int i = 0; i < particles.length; i ++) 
    {
      Particle pi = particles[i];

      if (pi.display)
      {
        particles[i].update(particles, i, weight, factor);
        speedSum += particles[i].vel.mag();
      }
    }
    
    maxSs = max(maxSs, speedSum);
    
    if((speedSum * 3) < maxSs)
    {
      weight = abs(weight);
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
        switch(coloring)
        {
          case 0:
          {
             minv = min(minv, pi.size);
             maxv = max(maxv, pi.size);        
          }
          break;
          
          case 1:
          {
            minv = min(minv, pi.vel.mag());
            maxv = max(maxv, pi.vel.mag());
          }
          break;
          
          case 3:
          {
            minv = 0;
            maxv = max(maxv, pi.heat);
          }
          break;
        }
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
      int objects = 0;

      for (int i = 0; i < particles.length; i ++)
      {
        Particle pi = particles[i];

        if (pi.display)
        {
          pi.display(particles, i, minv, maxv, coloring);
          objects++;
        }
      }
      
      // Set color of text
      fill(100, 100,100);
      
      largeText("" + objects, 0);
      largeText("" + getRunTime(), 1);
      largeText(cmodes[coloring], 2);
      largeText(rmodes[reset > 0 ? 1 : 0], 3);
      
      littleText("Spheres", 0);
      littleText("Running Time", 1);
      littleText("Coloring Mode", 2);
      littleText("touch twice to reset", 3);
    }

    display--;
    reset -= reset > 0 ? 1 : 0;
  }
  catch(Exception ex)
  {
    println("Ex:"+ex);
  }
}

void reset()
{
  reset = 100;
}

void littleText(String text, int pos)
{
  textSize(28);
  float tw = textWidth(text);
  float th = 28;
  int yo = 130;
  
  switch(pos)
  {
    case 0: // top left
    {
      text(text, 20, yo + 10 + th);
    }
    break;
    
    case 1: // top right
    {
      text(text, width - tw - 20, yo + 10 + th);
    }
    break;
    
    case 2: // bottom left
    {
      text(text, 20, height - yo);
    }
    break;
    
    case 3: // bottom right
    {
      text(text, width - tw - 20, height - yo);
    }
    break;
  }
}

void largeText(String text, int pos)
{
  textSize(100);
  float tw = textWidth(text);
  float th = 100;
  int yo = 10;
  
  switch(pos)
  {
    case 0: // top left
    {
      text(text, 10, yo + th);
    }
    break;
    
    case 1: // top right
    {
      text(text, width - tw - 10, yo + th);
    }
    break;
    
    case 2: // bottom left
    {
      text(text, 10, height - 10);
    }
    break;
    
    case 3: // bottom right
    {
      text(text, width - tw - 10, height - 10);
    }
    break;
  }
}

String getRunTime()
{
  int secs = getTime() - startSecs;
  int hours = floor(secs / 3600);
  secs = secs % 3600;
  int mins = floor(secs / 60);
  secs = secs % 60;
  
  return getN(hours, 2) + ":" + 
         getN(mins, 2) + ":" + 
         getN(secs, 2);
}

String getN(int n, int length)
{
  String result = "" + n;
  
  while(result.length() < length)
  {
    result = "0" + result;
  }
  
  return result;
}

int getTime()
{
  return second() + (minute()*60) + (hour()*3600) + (day()*86400);
}
