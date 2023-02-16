/*
  A ui slider to set or show a value by
 touch, hold, slide, release movement.
 */
class Slider extends Control<ValueControlSettings<Float>>
{
  float sliderWidth = 10;
  boolean active = false;
  String stored;

  Slider(ValueControlSettings<Float> settings)
  {
    super(settings);
    stored = s.title;
    s.textSize = s.textSize * 0.6;
  }

  // update and draw slider, return tue if slider change value
  boolean draw()
  {
    super.draw(false);
    
    pushStyle();

    float tox = s.x + s.w;
    float toy = s.y + s.h;

    float sw = (s.w - sliderWidth) / (s.vMax - s.vMin);
    float fromx = s.x + (sliderWidth / 2) + ((s.value.get() - s.vMin) * sw);
    float sh = (s.h - sliderWidth) / (s.vMax - s.vMin);
    float fromy = s.y + (sliderWidth / 2) + ((s.value.get() - s.vMin) * sh);

    if (s.dimmAlpha.get() > 0)
    {
      s.title = stored;
      fill(s.foreHue, 1.0, 1.0, s.dimmAlpha.get());
      String n = nf(s.vFactor * s.value.get(), 1, 1);
      float posx = 0;
      float posy = 0;

      if (s.w > s.h)
      {
        posx = fromx - (textWidth(n) / 2);
        posy = s.y + s.textSize + ((s.h - s.textSize) / 2) + (active ? (s.y > (height / 2) ? -200 : 200) : 0);
      } 
      else
      {
        posx = s.x + (active ? (s.x > (width / 2) ? - 200 : 200 ) : ((s.w - textWidth(n)) / 2));
        posy = fromy + (s.textSize / 2);
      }

      text(n, posx, posy);
    }
    else
    {
      s.title = "";
      stroke(s.foreHue, 1.0, 1.0, 0.5 + (s.dimmAlpha.get() * 0.5));
      strokeWeight(sliderWidth);
      if (s.w > s.h)
      {
        line(fromx, s.y, fromx, toy);
      } 
      else
      {
        line(s.x, fromy, tox, fromy);
      }
    }
    
    popStyle();
    
    return isMoved();
  }
  
  boolean isMoved()
  {
    if (mousePressed)
    {
      if (touches[0].x >= s.x       && 
          touches[0].x <= s.x + s.w &&
          touches[0].y >= s.y       &&
          touches[0].y <= s.y + s.h)
      {
        active = true;
        
        if (s.w > s.h)
        {
          float t = (s.vMax - s.vMin) / s.w;
          s.value.set(s.vMin + (touches[0].x - s.x) * t);
        } else
        {
          float t = (s.vMax - s.vMin) / s.h;
          s.value.set(s.vMin + (touches[0].y - s.y) * t);
        }
      }
    } 
    else
    {
      active = false;
    }
    
    return active;
  }
}
