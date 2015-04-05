ArrayList<Agent> agents;

class Agent
{
    PVector p;
    String startOD, endOD, prevIntersection, nextIntersection;
    float startTime, segmentStartTime, segmentDuration;
    int segmentInt;
    boolean reachedDestination = false;
    
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
        if(proportion<1)
        {
          p = PVector.lerp(intersections.get(prevIntersection).p,intersections.get(nextIntersection).p, proportion);
        }
        else
        {
            getNewSegment();
        }
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
        {
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

void displayAgents(ArrayList<Agent> as)
{
    //println("showing agents");
    for(Agent a:as)
    {
        a.move();
        a.display();
    }
}
