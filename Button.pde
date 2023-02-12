class Button extends Control
{
  String subtext = null;
  
  Button(ControlSettings settings) 
  {
    super(settings);
  }
  
  boolean draw(String subtextArg)
  {
    subtext = subtextArg;
    return draw();
  }
  
  boolean draw()
  {
    boolean result = super.draw();
    
    pushStyle();
    
    if(subtext != null)
    {
      fill(s.foreHue * 2, 1.0, 1.0, s.dimmAlpha.get() == 0 ? 0.5 : 1.0);
      // subtext = nf(s.dimmAlpha.get(), 1,3);
      textSize(s.textSize * 0.6);
      float tw = textWidth(subtext);
      textX = s.x + ((s.w - tw) / 2);
      textY += s.y < height / 2 ? s.textSize * 0.8 : - (s.textSize * 1.1);
      text(subtext, textX, textY);
    }
    
    popStyle();
    
    return result;
  }
}
