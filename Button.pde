class Button
{
  boolean handled = false;
  String title = "";
  int id;
  float x = 0;
  float y = 0;
  float w = 200;
  float h = 100;

  Button(String titleArg, int idArg, float xArg, float yArg, float wArg, float hArg)
  {
    x = xArg;
    y = yArg;
    w = wArg;
    h = hArg;
    title = titleArg;
    id = idArg;
  }

  boolean draw()
  {
    float alpha = dimmAlpha;
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

    if (alpha > 0)
    {
      pushStyle();
      float hsw = 1;
      stroke(100, 100, 100, alpha * 100);
      strokeWeight(2 * hsw);
      fill(0);
      rect(x + hsw, y + hsw, w - hsw - hsw, h - hsw - hsw);
      popStyle();
    }

    return result;
  }
}
