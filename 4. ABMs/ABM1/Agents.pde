ArrayList<Agent> agents;

class Agent
{
    PVector p;
    String startOD, endOD, prevIntersection, nextIntersection;
    float startTime, segmentStartTime, segmentDuration, proportion;
    int segmentInt;
    boolean reachedDestination, isNew;
    color c;
    
    Agent(String sod, String eod)
    {
        startTime = clock;
        segmentStartTime = clock;
        segmentInt = 0;
        
        startOD = sod;
        endOD = eod;
        
        Route r = routes.get(startOD).get(endOD);
        prevIntersection = routes.get(startOD).get(endOD).intersectionIDs.get(segmentInt);
        nextIntersection = routes.get(startOD).get(endOD).intersectionIDs.get(segmentInt+1);
        segmentDuration = edges.get(prevIntersection).get(nextIntersection).weight;
        p = intersections.get(prevIntersection).p;
        
        reachedDestination=false;
        //float f =random(255);
        //c =  color(100, 255, 150);
        
        c =  color(100, 255, 150, 10);
        isNew = true;
        
        /*
            Check start and end
        */
        
//        
//        strokeWeight(1);
//        stroke(0);
//        noFill();
//        ellipse(p.x, p.y, 5,5);
//        //println("INtersection " + ods.get(eod).nearestIntersection);
//        PVector q = ods.get(eod).nearestIntersection;
//        ellipse(q.x, q.y, 5,5);
    }
    
    void display()
    {
        
        stroke(hue(c), saturation(c), brightness(c), 10);
        strokeWeight(5);
        point(p.x, p.y);
        
        
        
        noStroke();
        fill(hue(c), saturation(c), brightness(c), 1);
        ellipse(p.x,p.y,10,10);
 
    }
    
    void move()
    {
        strokeWeight(1);
        //println("clock " +  (clock-segmentStartTime) + " " + segmentDuration);
        proportion = (clock-segmentStartTime)/segmentDuration;
        //println(proportion);
        stroke(hue(c), saturation(c), brightness(c), 1);
        PVector p1 = intersections.get(prevIntersection).p;
        while(proportion>=1)
        {
            /*
              drawing in lines for skipped segments more weakly
            */
            
            p1 = intersections.get(prevIntersection).p;
            PVector p2 = intersections.get(nextIntersection).p;
            line(p1.x, p1.y, p2.x, p2.y);  
          
            getNewSegment();
            proportion = (clock-segmentStartTime)/segmentDuration;
            
            
            
        }
        p = PVector.lerp(intersections.get(prevIntersection).p,intersections.get(nextIntersection).p, proportion);
        strokeWeight(5);
        line(p1.x, p1.y, p.x, p.y);  
        
    }
    
    void getNewSegment()
    {
        segmentStartTime+=segmentDuration;
        segmentInt++;
        
        if((segmentInt+1)<routes.get(startOD).get(endOD).intersectionIDs.size())
        {
            prevIntersection = routes.get(startOD).get(endOD).intersectionIDs.get(segmentInt);
            nextIntersection = routes.get(startOD).get(endOD).intersectionIDs.get(segmentInt+1);
            segmentDuration = edges.get(prevIntersection).get(nextIntersection).weight;
            //p = intersections.get(prevIntersection).p; 
        }
        else
        {
              //println(segmentInt + " " + routes.get(startOD).get(endOD).intersectionIDs.size());
              reachedDestination = true;
        }
        
        
    }
  
}

void testAgent()
{
    String sod = "35";
    String eod = "169";
    
    agents =  new ArrayList<Agent>();
    agents.add(new Agent(sod, eod));
}


void gaussProb()
{
    
    float xbar = (clock-mean)/sd;
    float currentProb = prob*exp(-0.5*xbar*xbar);
    /*
        normalising for sigma
    */
    currentProb/=sd;
    //currentProb = prob;
   
    for(String ods1: flows.keySet())
    {
        for(String ods2: flows.get(ods1).keySet())
        {
              /*
                  Some points with different ODs have the same start intersection
                  So we have watch out for those guyz
              */
              float ptij = currentProb*flows.get(ods1).get(ods2).weight;
              //println(chanco);
              if((random(1)<ptij) && !ods1.equals(ods2) && routes.get(ods1).get(ods2).intersectionIDs.size()>1) 
              {
                  //println("adding agents");
                  //println(chanco + " " + flows.get(ods1).get(ods2).weight);
                  Agent a =  new Agent(ods1, ods2);
                  //println("Reached Destination " + a.reachedDestination);
                  agents.add(a);

                
              }
        }
    }
    
    //println("Added agents " +  addedAgents);
}


void evenProb()
{
    float prob = 1000000;
    int addedAgents = 0;
    //println("*************************" + frameCount + "********************");
    for(String ods1: flows.keySet())
    {
        for(String ods2: flows.get(ods1).keySet())
        {
              /*
                  Some points with different ODs have the same start intersection
                  So we have watch out for those guyz
              */
              float chanco = random(prob);
              
              if(chanco<flows.get(ods1).get(ods2).weight && !ods1.equals(ods2) && routes.get(ods1).get(ods2).intersectionIDs.size()>1) 
              {
                  //println("adding agents");
                  //println(chanco + " " + flows.get(ods1).get(ods2).weight);
                  Agent a =  new Agent(ods1, ods2);
                  //println("Reached Destination " + a.reachedDestination);
                  agents.add(a);
                  addedAgents++;
                
              }
        }
    }
    
    //println("Added agents " +  addedAgents);
}


void displayAgents(ArrayList<Agent> asd)
{
    //println("showing agents");
    for(Agent a:asd)
    {
        a.move();
        a.display();
    }
    tidyAgents(asd);
    
    if(frameCount%120==0)
    {
      println("time " + clock +  " frameRate " +  frameRate + " agentsno " + agents.size());
    }
}

void tidyAgents(ArrayList<Agent> as)
{
    //int removedAgents = 0;
    agents = new ArrayList<Agent>();
    
    for(int i = 0; i<as.size(); i++)
    {
        
        if(!as.get(i).reachedDestination){
          agents.add(as.get(i));
        }
        else 
        {
            //removedAgents++;
            //println("Removed agents " + i +"/" + as.size());
            if(as.get(i).isNew)
            {
                //println(frameCount + ": Added and removed agents " + i +"/" + as.size() + " " + as.get(i).reachedDestination);
                as.get(i).isNew = false;
            }
        }
    }
    
//    println("removedAgents " + removedAgents);
//    println("frameRate " +  frameRate + " agentsno " + agents.size());
}
