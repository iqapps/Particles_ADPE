class Reference<T>
{
  private T value;
  public T get() { return value; }
  void set(T vArg) { value = vArg; }
  Reference(T vArg) { value = vArg; }
}

class ControlSettings
{
  private String title = "";
  private int id = 0;
  
  private int x = 0;
  private int y = 0;
  private int w = 100;
  private int h = 100;

  private color backColor = color(0);
  private color foreColor = color(0, 0, maxBgt, maxAlp);;
  private float textSize = 20;
  
  Reference<Float> dimmAlpha = new Reference<Float>((float)maxAlp);
  
  ControlSettings(String txtArg, int idArg, int xArg, int yArg, int wArg, int hArg, color bcolArg, color tcolArg, int tsArg, Reference<Float> dimArg)
  {
    title = txtArg;
    backColor = bcolArg;
    id = idArg;
    x = xArg;
    y = yArg;
    w = wArg;
    h = hArg;
    textSize = tsArg;
    foreColor = tcolArg;
    dimmAlpha = dimArg;
  } 
  
  ControlSettings(int idArg, int xArg, int yArg, int wArg, int hArg)
  {
    id = idArg;
    x = xArg;
    y = yArg;
    w = wArg;
    h = hArg;
  }
  
  ControlSettings(int idArg, int xArg, int yArg, int wArg, int hArg, Reference<Float> dimArg)
  {
    id = idArg;
    x = xArg;
    y = yArg;
    w = wArg;
    h = hArg;
    dimmAlpha = dimArg;
  } 
}

class ValueControlSettings<T> extends ControlSettings
{
  Reference<T> value;
  
  ValueControlSettings(String txtArg, int idArg, int xArg, int yArg, int wArg, int hArg, color bcolArg, color tcolArg, int tsArg, Reference<Float> dimArg, Reference<T> vArg)
  {
    super(txtArg, idArg, xArg, yArg, wArg, hArg, bcolArg, tcolArg, tsArg, dimArg);
    value = vArg;
  }
}

class Control
{
  ControlSettings s;
  float textX = 0;
  float textY = 0;
  
  boolean handled = false;

  Control(ControlSettings settings)
  {
    s = settings;

    pushStyle();

    textSize(s.textSize);
    float tw = textWidth(s.title);

    popStyle();
  }

  public boolean draw()
  {
    pushStyle();

    textSize(s.textSize);
    
    if (s.dimmAlpha.get() > 0)
    {
      float hsw = 1;
      stroke(s.foreColor, s.dimmAlpha.get() * 100);
      strokeWeight(2 * hsw);
      fill(s.backColor);
      rect(s.x + hsw, s.y + hsw, s.w - hsw - hsw, s.h - hsw - hsw);
    }

    fill(s.foreColor, s.dimmAlpha.get() == 0 ? maxAlp / 2 : maxAlp);
    float tw = textWidth(s.title);

    if (s.w > s.h)
    {
      textX = s.x;
      textY = s.y + (s.y < (height / 2) ? s.h + s.textSize : -(s.textSize / 5));
    } 
    else
    {
      textX = s.x + ((s.w - tw) / 2);
      textY = s.y + s.textSize;
    }
    
    text(s.title, textX, textY);

    popStyle();

    return isClicked();
  }

  private boolean isClicked()
  {
    boolean result = false;

    if (mousePressed)
    {
      if (handled == false)
      {
        if (
          touches[0].x >= s.x && 
          touches[0].x <= s.x + s.w &&
          touches[0].y >= s.y &&
          touches[0].y <= s.y + s.h)
        {
          handled = true;
        }
      }
    } 
    else
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
