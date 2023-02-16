class Button extends Control<ControlSettings>
{
  String subtext = null;
  
  Button(ControlSettings settings) 
  {
    super(settings);
    subtext = s.title;
  }
  
  boolean draw()
  {
    return draw(null);
  }
  
  boolean draw(String subtextArg)
  {
    s.title = subtextArg;
    boolean result = super.draw(true);

    if(subtext != null)
    {
      pushStyle();
      
      fill(s.foreHue * 2, 1.0, 1.0, s.dimmAlpha.get() == 0 ? 0.5 : 1.0);
      textSize(s.textSize * 0.6);
      float tw = textWidth(subtext);
      textX = s.x + ((s.w - tw) / 2);
      textY += s.y < height / 2 ? s.textSize * 0.8 : - (s.textSize * 1.1);
      text(subtext, textX, textY);
      
      popStyle();
    }

    return result;
  }
}
