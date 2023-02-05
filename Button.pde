class Button
{
  boolean handled = false;
  String title = "";
  int identity;
  float x = 0;
  float y = 0;
  float w = 200;
  float h = 100;
  boolean visible = true;

  Button(String titleArg, int identityArg, float xArg, float yArg, float wArg, float hArg)
  {
    x = xArg;
    y = yArg;
    w = wArg;
    h = hArg;
    title = titleArg;
    identity = identityArg;
  }

  boolean draw()
  {
    boolean result = false;
    
    if (visible)
    {
      pushStyle();
      float hsw = 1;
      stroke(30, 100, 30);
      strokeWeight(2 * hsw);
      fill(0);
      rect(x + hsw, y + hsw, w - hsw - hsw, h - hsw - hsw);
      popStyle();

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
        if(handled)
        {
          result = true;
          handled = false;
        }
      }
    }
    
    return result;
  }
}
