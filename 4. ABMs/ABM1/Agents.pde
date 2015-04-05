ArrayList<Agent> agents;

class Agent
{
    PVector p;
    String startOD, endOD, prevIntersection, nextIntersection;
    float startTime, segmentStartTime, segmentDuration;
    int segmentInt;
    boolean reachedDestination;
    
    Agent(String sod, String eod)
    {
        startTime = clock;
        segmentStartTime = 0;
        segmentInt = 0;
        
        startOD = sod;
        endOD = eod;
        
        Route r = routes.get(startOD).get(endOD);
        prevIntersection = routes.get(startOD).get(endOD).intersectionIDs.get(segmentInt);
        nextIntersection = routes.get(startOD).get(endOD).intersectionIDs.get(segmentInt+1);
        segmentDuration = edges.get(prevIntersection).get(nextIntersection).weight;
        p = intersections.get(prevIntersection).p;
        
        reachedDestination=false;
    }
    
    void display()
    {
        noStroke();
        fill(0,255,255);
        ellipse(p.x, p.y, 5, 5);
    }
    
    void move()
    {
        //println("clock " +  (clock-segmentStartTime) + " " + segmentDuration);
        float proportion = (clock-segmentStartTime)/segmentDuration;
        //println(proportion);
        if(!(proportion<1))
        {
            getNewSegment();
            proportion = (clock-segmentStartTime)/segmentDuration;
        }
        p = PVector.lerp(intersections.get(prevIntersection).p,intersections.get(nextIntersection).p, proportion);
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
            p = intersections.get(prevIntersection).p; 

        }
        else
        {
              println(segmentInt + " " + routes.get(startOD).get(endOD).intersectionIDs.size());
              reachedDestination = true;
        }
        
        //if(reachedDestination) this=null;
        
    }
  
}

void testAgent()
{
    String sod = "35";
    String eod = "169";
    
    agents =  new ArrayList<Agent>();
    agents.add(new Agent(sod, eod));
}

void evenProb()
{
    float prob = 100000000;
    for(String ods1: flows.keySet())
    {
        for(String ods2: flows.get(ods1).keySet())
        {
              /*
                  Some points with different ODs have the same start intersection
                  So we have watch out for those guyz
              */
              if(random(prob)<flows.get(ods1).get(ods2).weight && !ods1.equals(ods2) && routes.get(ods1).get(ods2).intersectionIDs.size()>1) agents.add(new Agent(ods1, ods2));
        }
    }
}

void displayAgents(ArrayList<Agent> as)
{
    //println("showing agents");
    for(Agent a:as)
    {
        a.move();
        a.display();
    }
    tidyAgents(as);
}

void tidyAgents(ArrayList<Agent> as)
{
    for(int i = 0; i<as.size(); i++)
    {
        if(as.get(i).reachedDestination){
          as.remove(i);
          i--;
        }
    }
    println(as.size());
}
