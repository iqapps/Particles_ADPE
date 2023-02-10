/**
 * Drift
 * by CalsignLabs
 * 
 * Touch the screen to manipulate the 
 * particles. Multi-touch is supported.
 */

// Array of particles
Particle[] particles;

int cmode = 3;
String[] cmodes = {"SIZE", "SPEED", "HEADING", "HEAT"};

int rmode = 0;
String[] rmodes = {"BIG BANG", "KABOOM"};

int smode = 0;
String smodes[] = {"Running time", "Frames per sec.", "Width,Height"};

ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Slider> sliders = new ArrayList<Slider>();

int initObjects = 361;
int dispcnt = 1;
int display = dispcnt;
int startSecs;
int about = 0;
AboutText at;
boolean touch = false;
float centerG = 0.005;

int weight = 25;
float factor;

float maxSs = 0;
float fRate = 0;

int millis = 0;
PVector sCenter;

void setup() 
{
  maxSs = 0;
  rmode = 0;
  factor = 1.9;

  // Use this size and use OpenGL
  fullScreen(OPENGL);

  // Set up random noise
  noiseDetail(16, 0.6);

  // Use HSB
  colorMode(HSB, 360, 100, 100, 100);
  background(0);
  strokeWeight(12);

  initParticles();  
  startSecs = getTime();
  at = new AboutText();

  frameRate(2000.0);
  
  sCenter = new PVector(width / 2f, height / 2f);

  float qw = width / 3;
  float qh = height / 8;

  if (buttons.size() == 0)
  {
    buttons.add(new Button("", 0, 0, 0, qw, qh));
    buttons.add(new Button("", 1, 0., height - qh, qw, qh));
    buttons.add(new Button("", 2, width - qw, 0, qw, qh));
    buttons.add(new Button("", 3, width - qw, height - qh, qw, qh));
  }

  if (sliders.size() == 0)
  {
    sliders.add(new Slider("Density",   0,     1,  100,     25,    1,                0, qh, qw / 4, height - qh - qh));
    sliders.add(new Slider("Pull",      1, 0.001, 0.01,  0.005, 1000, width - (qw / 4), qh, qw / 4, height - qh - qh));
    //sliders.add(new Slider("Pull",    2, 0, 0.01, 0.005, qw, 0, width - qw - qw, qh / 2));
    //sliders.add(new Slider("Density", 3, 1, 50, 25, qw, height - ( qh / 2), width - qw - qw, qh / 2));
  }
}

void initParticles()
{
  // Reset to a grid of particles

  // Number of particles that will fit
  int d = (int)round(sqrt(initObjects));

  // Initialize particle array
  particles = new Particle[d * d];

  // Populate particle array in a 
  // grid of reguarly-spaced particles
  int cur = 0;
  for (int x = 0; x < d; x ++) {
    for (int y = 0; y < d; y ++) {
      float r = random(min(width, height) / 2);
      float a = random(TWO_PI) - PI;
      float dx = cos(a) * r;
      float dy = sin(a) * r;
      
      particles[cur] = new Particle(dx, dy);
      //particles[cur].vel.rotate(HALF_PI / 2);
      cur ++;
    }
  }
}

void draw()
{
  millis = millis() - millis;
  if(millis < 0) millis += 1000;
  
  if (about > 1)
  {
    drawAbout(millis);
  } else
  {
    drawSpheres(millis);
    handleTouch(millis);
  }
}

void handleTouch(int millis)
{
  if (touch == false)
  {
    about *= 2;

    for (Button b : buttons)
    {
      b.alpha *= 0.995;
    }
    for (Slider s : sliders)
    {
      s.alpha *= 0.995;
    }
  } else
  {
    for (Button b : buttons)
    {
      b.alpha = 1;
    }
    for (Slider s : sliders)
    {
      s.alpha = 1;
    }
  }
}

void drawAbout(int millis)
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

void handleUI(int millis)
{
  touch = false;
  
  for (Button b : buttons)
  {
    if (b.draw())
    {
      touch = true;

      switch(b.id)
      {
      case 0:
        about = 1;
        break;
      case 1:
        cmode = (cmode + 1) % cmodes.length;
        break;
      case 2:
        smode = (smode + 1) % smodes.length;
        break;
      case 3:
        if (rmode == 0)
        {
          rmode = 100;
        } else
        {
          setup();
        }
        break;
      }
    }
  }

  for (Slider s : sliders)
  {
    if (s.draw())
    {
      touch = true;

      switch(s.id)
      {
      case 0:
        weight = (int)s.value;
        break;
      case 2:
        //weight = (int)s.value;
        break;
      case 1:
        centerG = s.value;
        break;
      case 3:
        //weight = (int)s.value;
        break;
      }
    }
    else
    {
      switch(s.id)
      {
      case 0:
        s.value = weight;
        break;
      case 2:
        //weight = (int)s.value;
        break;
      case 1:
        s.value = centerG;
        break;
      case 3:
        //weight = (int)s.value;
        break;
      }
    }
  }
}

void drawSpheres(int millis) 
{
  try
  {
    float minv = 3000.0;
    float maxv = 0.0;
    PVector center = new PVector();

    // Cycle through the particles
    for (int i = 0; i < particles.length; i ++) 
    {
      Particle pi = particles[i];

      if (pi.display)
      {
        particles[i].update(millis, particles, i, weight, factor, centerG);
        center.add(particles[i].loc);
      }
    }
    
    center.mult(0.0003);

    // Cycle through the particles
    for (int i = 0; i < particles.length; i ++) 
    {
      Particle pi = particles[i];

      if (pi.display)
      {
        particles[i].size = particles[i].newSize;
        particles[i].loc.sub(center);
      }
    }

    for (int i = 0; i < particles.length; i ++)
    {
      Particle pi = particles[i];

      if (pi.display)
      {
        switch(cmode)
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

      handleUI(millis);

      int objects = 0;

      for (int i = 0; i < particles.length; i ++)
      {
        Particle pi = particles[i];

        if (pi.display)
        {
          pi.display(millis, particles, i, minv, maxv, cmode);
          objects++;
        }
      }

      String sm = smode == 0 ? getRunTime() : (smode == 1 ? nf(int(fRate), 0) : nf(width, 0)+","+nf(height, 0));

      fill(100, 100, 100);
      String[] lt = {str(objects), sm, cmodes[cmode], rmodes[rmode > 0 ? 1 : 0]};
      float lth = largeText(lt);

      fill(180, 100, 100);
      String st[] = {"Spheres", smodes[smode], "Color Mode", "touch twice to reset"};
      smallText(st, lth);
    }

    display--;
    rmode -= rmode > 0 ? 1 : 0;
    fRate = (fRate * 49 + frameRate) / 50;
  }
  catch(Exception ex)
  {
    println("Ex:"+ex);
  }
}

void smallText(String[] text, float lth)
{
  float th = max(15.0, width * 28 / 1484.0);
  textSize(th);
  int yo = (int)(lth * 1.1);
  int xo = (int)(lth / 5.0);

  for (int ii = 0; ii < 4; ii++)
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

  for (int ii = 0; ii < 4; ii++)
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
  if (secs < startSecs)
  {
    startSecs -= 86400;
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

  while (result.length() < length)
  {
    result = "0" + result;
  }

  return result;
}

int getTime()
{
  return second() + (minute()*60) + (hour()*3600);
}
