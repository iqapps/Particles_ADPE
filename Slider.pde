/*
  A ui slider to set or show a value by
 touch, hold, slide, release movement.
 */
class Slider
{
  String title = "Slider";
  float textsize = 50;
  int id;

  float value = 0;
  float vMin = 0;
  float vMax = 100;
  float factor = 1;

  float x = 0;
  float y = 0;
  float w = 30;
  float h = 300;

  float sliderWidth = 10;
  float alpha = 1.0;

  boolean active = false;

  Slider(String titleArg, int idArg, float minV, float maxV, float initV, float factorArg, float xArg, float yArg, float wArg, float hArg)
  {
    title = titleArg;
    id = idArg;
    vMin = minV;
    vMax = maxV;
    value = initV;
    factor = factorArg;

    x = xArg;
    y = yArg;
    w = wArg;
    h = hArg;

    textSize(textsize);
    float tw = textWidth(title);

    if (tw > (w * 0.8))
    {
      textsize = textsize * (w * 0.8) / tw;
      textSize(textsize);
    }
  }

  // update and draw slider, return tue if slider change value
  boolean draw()
  {
    if (mousePressed)
    {
      if (touches[0].x >= x     && 
          touches[0].x <= x + w &&
          touches[0].y >= y     &&
          touches[0].y <= y + h)
      {
        active = true;
        
        if (w > h)
        {
          float t = (vMax - vMin) / w;
          value = vMin + (touches[0].x - x) * t;
        } else
        {
          float t = (vMax - vMin) / h;
          value = vMin + (touches[0].y - y) * t;
        }

        value = min(vMax, max(vMin, value));
      }
    } 
    else
    {
      active = false;
    }

    pushStyle();

    float tox = x + w;
    float toy = y + h;

    float sw = (w - sliderWidth) / (vMax - vMin);
    float fromx = x + (sliderWidth / 2) + ((value - vMin) * sw);
    float sh = (h - sliderWidth) / (vMax - vMin);
    float fromy = y + (sliderWidth / 2) + ((value - vMin) * sh);

    stroke(100, 100, 100, 50.0 + (alpha * 50.0));
    strokeWeight(sliderWidth);

    if (w  > h)
    {
      line(fromx, y, fromx, toy);
    } 
    else
    {
      line(x, fromy, tox, fromy);
    }

    if (alpha > 0)
    {
      textSize(textsize);
      fill(0);
      stroke(100, 100, 100, alpha * 100);
      strokeWeight(2.0);
      rect(x, y, w, h);

      float tw = textWidth(title);
      fill(100, 100, 100, alpha * 100);

      if (w > h)
      {
        text(title, x, y + (y < (height / 2) ? h + textsize : -(textsize / 5)));
      } 
      else
      {
        text(title, x + ((w - tw) / 2), y + textsize);
      }
    }

    if (active)
    {
      fill(100, 100, 100, 100);
      String n = nf(value * factor, 1, 1);
      float posx = 0;
      float posy = 0;

      if (w > h)
      {
        posx = fromx - (textWidth(n) / 2);
        posy = y + textsize + ((h - textsize) / 2) + (active ? (y > (height / 2) ? -200 : 200) : 0);
      } else
      {
        posx = x + (active ? (x > (width / 2) ? - 200 : 200 ) : ((w - textWidth(n)) / 2));
        posy = fromy + (textsize / 2);
      }

      text(n, posx, posy);
    }
    
    popStyle();
    
    return active;
  }
}
