/*
    Display Options
*/

boolean showInterSections = false;
boolean showStreets = false;
boolean showIntersectionJoins = false;
boolean capture = false;
boolean dual = false;
boolean showPathfinding = true;
boolean showOD = true;
boolean showFlows = true;

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
    
    //if(key=='f') saveFrame("images/+" + millis() + ".jpg");
    
    if(key=='i') showInterSections = !showInterSections;
    if(key=='s') showStreets = !showStreets;
    if(key=='j') {
      showIntersectionJoins = !showIntersectionJoins;
      println(showIntersectionJoins);
    }
    if(key=='o')showOD = !showOD;
    if(key=='d')dual=!dual;
    if(key=='f')showFlows=!showFlows;
}
