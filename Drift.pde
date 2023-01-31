/**
 * Drift
 * by CalsignLabs
 * 
 * Touch the screen to manipulate the 
 * particles. Multi-touch is supported.
 */

// Array of particles
Particle[] particles;

String[] cmodes = {"SIZE", "SPEED", "HEADING", "HEAT"};;
String[] rmodes = {"BIG BANG", "KABOOM"};
String smodes[] = {"Running time", "Frames per sec.", "Width,Height"};

int initObjects = 361;
int dispcnt = 1;
int display = dispcnt;
int startSecs;
int coloring = 3;
//float coloringX = width;
boolean mHandled = false;
int about = 0;
AboutText at; // = new AboutText();

int weight = -25;
float factor = 1.9;
int reset = 0;
float maxSs = 0;
int smode = 0;
float fRate = 0;

void setup() 
{
  maxSs = 0;
  reset = 0;
  weight = -25;
  factor = 1.9;
  mHandled = false;

  // Use this size and use OpenGL
  fullScreen(OPENGL);
  //size(12, OPENGL);

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
  at = new AboutText();
  
  frameRate(2000.0);
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
  if(about > 1)
  {
    drawAbout();
  }
  else
  {
    drawSpheres();
  }
}


void drawAbout()
{
  try
  {
    about = at.draw() ? 0 : 2;
  }
    catch(Exception ex)
  {
    println("Ex:"+ex);
  }
}

void drawSpheres() 
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
        else if(my < height / 4)
        {
          if(mx > (3 * width / 4))
          {
            smode = (smode + 1) % smodes.length;
          }
          else
          if(mx < (width / 4))
          {
            about = 1;
          }
        }
      }
    }
    else
    {
      mHandled = false;
      about = about * 2;
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
      
      String sm = smode == 0 ? getRunTime() : (smode == 1 ? nf(int(fRate),0) : nf(width,0)+","+nf(height,0));

      fill(100, 100,100);
      String[] lt = {str(objects), sm, cmodes[coloring], rmodes[reset > 0 ? 1 : 0]};
      float lth = largeText(lt);
      
      fill(180, 100, 100);
      String st[] = {"Spheres", smodes[smode], "Coloring Mode", "touch twice to reset"};
      smallText(st, lth);
    }

    display--;
    reset -= reset > 0 ? 1 : 0;
    fRate = (fRate * 49 + frameRate) / 50;
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

void smallText(String[] text, float lth)
{
  float th = max(15.0, width * 28 / 1484.0);
  textSize(th);
  int yo = (int)(lth * 1.1);
  int xo = (int)(lth / 5.0);
  
  for(int ii = 0; ii < 4; ii++)
  {
    float tw = textWidth(text[ii]);
    float x = ii % 2 == 0 ? xo : width - tw - xo;
    float y = ii / 2 <  1 ? yo + th : height - yo;
    text(text[ii], x, y);
  }
}

float largeText(String[] text)
{
  float th = max(40.0, width * 100 / 1484.0);
  textSize(th);
  int yo = (int)(th / 10.0);
  int xo = (int)(th / 10.0);
  
  for(int ii = 0; ii < 4; ii++)
  {
    float tw = textWidth(text[ii]);
    float x = ii % 2 == 0 ? xo : width - tw - xo;
    float y = ii / 2 <  1 ? th : height - yo;
    text(text[ii], x, y);
    
  }
  
  return th;
}

String getRunTime()
{
  int secs = getTime();
  if(secs < startSecs)
  {
    startSecs += 86400;
  }
  
  secs = secs - startSecs;
    
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
  return second() + (minute()*60) + (hour()*3600);
}
