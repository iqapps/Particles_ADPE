class AboutText {
  // # => Header text
  // & => bold
  String[] text = new String[] {
    "#About Mezmerize.",
    
    "&Touch the screen to return to the Big Bang.",
    
    "This program is a very simple simulation of "+
    "a big bang creating a number of objects being "+
    "spread initially in a random pattern, and "+
    "then shifting to the gravity phase, where "+
    "body gravity rules exist.",
    
    "The simulation is shown in 2D only, but "+
    "is using 3D body mass gravity rules.",
    
    "The gravity rules have been adjusted to make the "+
    "simulation more interresting and to ensure a "+
    "resonable run time per bang.",
    
    "The objects should be considered spheres of "+
    "equal desity. When spheres collide they join "+
    "into a single sphere with a mass equal to the "+
    "sum of the colliding spheres. The resulting "+
    "velocity vector after a collision, is random "+
    "as the collision is never a direct hit.",
    
    "When a collision occur, the sphere is getting "+
    "hotter due to collision, and when bodies pull "+
    "each other, they also becomes hotter.",
    
    "The simulation is centered and held together "+
    "by a virtual invisible black hole at the center "+
    "of the screen. The black hole is very small and therefore "+
   "will not be able to consume objects.",

   "&Touch the screen to return to the Big Bang."
  };
  
  PGraphics pg;
  //PImage pi;
  int spheres = 0;
  int ms = -1;
  float tSize0 = 64.0;
  float tSize1 = 128.0;
  float tSize2 = 48.0;
  float z = height;
  int hue0 = 100;
  int hue1 = 200;
  int hue2 = 50;
  color black;
  
  AboutText()
  {
    pg = createGraphics(width, height, P2D);
  }
  
  boolean draw()
  {
    boolean result = false;
    if(ms < 0) { ms = millis(); }
    
    loadPixels();
    pg.colorMode(HSB, 360, 100, 100, 100);
    
    pg.beginDraw();
    pg.background(0);

    int mils = millis() - ms;
    float top = height - (tSize0 * mils / 2000);
    int li = 0;
    
    for(int ii = 0; ii < text.length; ii++)
    {
      pg.fill(hue0, 100, 100);
      pg.textSize(tSize0);
      String t = text[ii];
      
      if(t.charAt(0) == '#')
      {
        pg.textSize(tSize1);
        pg.fill((int)(hue1), 100, 100);
        t = t.substring(1);
      }
      
      if(t.charAt(0) == '&')
      {
        pg.textSize(tSize2);
        pg.fill((int)(hue2), 100, 100);
        t = t.substring(1);
      }
      
      while(t.length() > 0)
      {
        while(t.charAt(0) == ' ')
        {
          t = t.substring(1);
        }
        
        String o = t;
        
        while(o.length() > 0)
        {
          float ow = pg.textWidth(o);
          
          if(ow >= (0.9 * width))
          {
            int lsp = o.lastIndexOf(" ");
            
            if(lsp > 0)
            {
              o = o.substring(0, lsp);
            }
            else
            {
              break;
            }
          }
          else
          {
            break;
          }
        }
        
        if(o.length() > 0)
        {
          float ow = pg.textWidth(o);
          int x = (int)((width - ow) / 2);
          int y = (int)(top + (li++ * tSize0));
          if(y < (height + tSize0))
          {
            pg.text(o, x, y);
          }
          else
          {
            break;
          }
        }
        
        t = t.substring(o.length());
      }
      
      li++;
    }

    pg.endDraw();
    pg.loadPixels();
    
    for(int sx = 0; sx < width; sx++)
    {
      for(int sy = 0; sy < height; sy++)
      {
        int dy = sy;
        int dx = sx;
        
        dy = min(height, max(0, dy));
        dx = min(width, max(0, dx));
        int six = sx + (sy * width);
        int dix = dx + (dy * width);
        
        dix = max(0, min(dix, (width * height) - 1));
        six = max(0, min(six, (width * height) - 1));
        
        pixels[dix] = pg.pixels[six];
      }
    }
    
    updatePixels();
    
    if(mousePressed)
    {
      spheres = 1;
    }
    else
    {
      if(spheres != 0)
      {
        result = true;
        spheres = 0;
        ms = -1;
        frameRate(10000);
      }
    }
    
    return result;
  }
}