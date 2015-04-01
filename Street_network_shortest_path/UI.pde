/*
    Display Options
*/

boolean showInterSections = true;
boolean showStreets = false;
boolean showIntersectionJoins = true;

void keyPressed()
{
    if(keyCode==UP || keyCode==DOWN)
    {
        if(keyCode==UP)   maxStroke*=1.1;
        if(keyCode==DOWN) maxStroke*=0.9;    
        maxStroke = int(maxStroke);
        println(maxStroke);
    }
    
    if(keyCode==LEFT || keyCode==RIGHT)
    {
      if(keyCode==LEFT) curviness*=0.9;
      if(keyCode==RIGHT) curviness*=1.1;
      println(curviness);
    }
    
    if(key=='f') saveFrame("images/+" + millis() + ".jpg");
    
    if(key=='i') showInterSections = !showInterSections;
    if(key=='s') showStreets = !showStreets;
    if(key=='j') {
      showIntersectionJoins = !showIntersectionJoins;
      println(showIntersectionJoins);
    }
}
