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
      textSize(s.textSize * 0.6);
      textY += s.textSize * 0.8;
      text(subtext +"x", textX, textY);
    }
    
    popStyle();
    
    return result;
  }
}
