ArrayList<Agent> agents;

class Agent
{
    PVector p;
    String startOD, endOD;
    float startTime;
    
    
    void display()
    {
        ellipse(p.x, p.y, 5, 5);
    }
  
}
