class Control
{
  String title = "";
  
  int id;
  float x = 0;
  float y = 0;
  float w = 200;
  float h = 100;
  boolean handled = false;
  float alpha = 1.0;
  float textsize = 50;
  color backColor = color(0, 0, 0);
  color textColor = color(100, 100, 100);
  
  Control(String titleArg, int idArg, float xArg, float yArg, float wArg, float hArg)
  {
    x = xArg;
    y = yArg;
    w = wArg;
    h = hArg;
    title = titleArg;
    id = idArg;

    pushStyle();
    
    if(textsize > h * 0.5)
    {
      textsize = h * 0.5;
    }

    textSize(textsize);
    float tw = textWidth(title);

    if (tw > (w * 0.8))
    {
      textsize = textsize * (w * 0.8) / tw;
      textSize(textsize);
    }

    popStyle();
  }

  public boolean draw()
  {
    if (alpha > 0)
    {
      pushStyle();

      float hsw = 1;
      stroke(textColor, alpha * 100);
      strokeWeight(2 * hsw);
      fill(backColor);
      rect(x + hsw, y + hsw, w - hsw - hsw, h - hsw - hsw);

      textSize(textsize);
      strokeWeight(2.0);
      rect(x, y, w, h);

      fill(100, 100, 100, alpha * 100);
      strokeWeight(sliderWidth);
      float tw = textWidth(title);

      if (w > h)
      {
        text(title, x, y + (y < (height / 2) ? h + textsize : -(textsize / 5)));
        line(fromx, y, fromx, toy);
      } 
      else
      {
        text(title, x + ((w - tw) / 2), y + textsize);
        line(x, fromy, tox, fromy);
      }

      popStyle();
    }
    
    return isClicked();
  }
  
  private boolean isClicked()
  {
    boolean result = false;

    if (mousePressed)
    {
      if (handled == false)
      {
        if (touches[0].x >= x     && 
          touches[0].x <= x + w &&
          touches[0].y >= y     &&
          touches[0].y <= y + h)
        {
          handled = true;
        }
      }
    } else
    {
      if (handled)
      {
        result = true;
        handled = false;
      }
    }
    
    return result;
  }
}
