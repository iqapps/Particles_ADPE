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

  float x = 0;
  float y = 0;
  float w = 30;
  float h = 300;

  float sliderWidth = 10;
  float alpha = 1.0;

  boolean active = false;

  Slider(String titleArg, int idArg, float minV, float maxV, float initV, float xArg, float yArg, float wArg, float hArg)
  {
    title = titleArg;
    id = idArg;
    vMin = minV;
    vMax = maxV;
    value = initV;

    x = xArg;
    y = yArg;
    w = wArg;
    h = hArg;

    pushStyle();
    textSize(textsize);
    float tw = textWidth(title);

    if (tw > (w * 0.8))
    {
      textsize = textsize * (w * 0.8) / tw;
      textSize(textsize);
    }

    popStyle();
  }

  // update and draw slider, return tue if slider change value
  boolean draw()
  {
    boolean result = false;

    if (mousePressed)
    {
      if (touches[0].x >= x     && 
          touches[0].x <= x + w &&
          touches[0].y >= y     &&
          touches[0].y <= y + h)
      {
        active = true;
      }

      if (active)
      {
        if (w > h)
        {
          float t = (vMax - vMin) / w;
          value = vMin + (touches[0].x - x) * t;
        } 
        else
        {
          float t = (vMax - vMin) / h;
          value = vMin + (touches[0].y - y) * t;
        }

        value = min(vMax, max(vMin, value));
        result = true;
        ;
      }
    } else
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

    if (alpha > 0)
    {
      textSize(textsize);
      fill(0);
      stroke(100, 100, 100, alpha * 100);
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
    }

    fill(100, 100, 100, 100);
    String n = nf(value, 1, 2);
    float posx = 0;
    float posy = 0;

    if (w > h)
    {
      posx = fromx - (textWidth(n) / 2);
      posy = y + textsize + ((h - textsize) / 2) + (active ? (y > (height / 2) ? -200 : 200) : 0);
    } 
    else
    {
      posx = x + (active ? (x > (width / 2) ? - 200 : 200 ) : ((w - textWidth(n)) / 2));
      posy = fromy + (textsize / 2);
    }

    text(n, posx, posy);
    popStyle();
    return result;
  }
}
