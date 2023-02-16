class Reference<T>
{
  private T value;

  Reference(T vArg) { value = vArg; }

  public T get() { return value; }
  public void set(T vArg) { value = vArg; }
}

class ControlSettings
{
  public String title = "";
  public int id = 0;

  public int x = 0;
  public int y = 0;
  public int w = 100;
  public int h = 100;

  public float backHue = 0.3;
  public float foreHue = 0.3;
  public float textSize = 20;

  Reference<Float> dimmAlpha = new Reference<Float>(maxAlp);

  ControlSettings(String txtArg, int idArg, int xArg, int yArg, int wArg, int hArg, float bhueArg, float fhueArg, float tsArg, Reference<Float> dimArg)
  {
    this(idArg, xArg, yArg, wArg, hArg, bhueArg, fhueArg, tsArg, dimArg);
    title = txtArg;
  } 

  ControlSettings(int idArg, int xArg, int yArg, int wArg, int hArg, float bhueArg, float fhueArg, float tsArg, Reference<Float> dimArg)
  {
    this(idArg, xArg, yArg, wArg, hArg, dimArg);
    backHue = bhueArg;
    foreHue = fhueArg;
    textSize = tsArg;
  } 

  ControlSettings(int idArg, int xArg, int yArg, int wArg, int hArg, Reference<Float> dimArg)
  {
    this(idArg, xArg, yArg, wArg, hArg);
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
}

class ValueControlSettings<T> extends ControlSettings
{
  Reference<T> value;
  T vMin;
  T vMax;
  T vFactor;

  ValueControlSettings(String txtArg, int idArg, int xArg, int yArg, int wArg, int hArg, float bhueArg, float fhueArg, float tsArg, Reference<Float> dimArg, Reference<T> vArg, T maxV, T minV, T factor)
  {
    super(txtArg, idArg, xArg, yArg, wArg, hArg, bhueArg, fhueArg, tsArg, dimArg);
    value = vArg;
    vMin = minV;
    vMax = maxV;
    vFactor = factor;
  }
}

class Control<S extends ControlSettings>
{
  S s;
  float textX = 0;
  float textY = 0;

  boolean handled = false;

  Control(S settings)
  {
    s = settings;
  }

  public boolean draw(boolean checkClicked)
  {
    pushStyle();

    textSize(s.textSize);

    if (s.dimmAlpha.get() > 0)
    {
      float hsw = 1;
      strokeWeight(2 * hsw);
      fill(s.backHue);

      stroke(s.foreHue, 1.0, 1.0, s.dimmAlpha.get());
      rect(s.x + hsw, s.y + hsw, s.w - hsw - hsw, s.h - hsw - hsw);
    }

    fill(s.foreHue, 1.0, 1.0, s.dimmAlpha.get() == 0 ? 0.5 : 1.0);
    //s.title = nf(s.dimmAlpha.get(),1,3);
    float tw = textWidth(s.title);
    textX = s.x + ((s.w - tw) / 2);
    textY = s.y + (s.y > height / 2 ? s.h - (s.textSize * 0.3) : s.textSize);

    text(s.title, textX, textY);

    popStyle();

    return checkClicked ? isClicked() : false;
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
