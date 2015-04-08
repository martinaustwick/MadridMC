float totalCostScale = 255/3000.0;

class Intersection
{
    String ID;
    ArrayList<String> destinations;
    PVector p;    
    Boolean isOD, seen;
    
    Boolean selecting = false;
    
    float d;
    
    Intersection()
    {
        destinations = new ArrayList<String>();
        isOD =  false;
    }
    
    void display()
    {
        stroke(0);
        
        if(isOD) fill(0,255,200);
        else noFill();
        
        if(selecting) {
          noStroke();
          fill((d*totalCostScale)%255, 255, 200, 100);
          //fill(0, 255-d*totalCostScale, 150, 100);
          //stroke(120, 255, 0, 100);
          if(d>9999999) fill(0, 0, 100, 100);
          //text(d, p.x, p.y);
        }
//        else
//        {
          rect(p.x, p.y, 5,5);
        //}
        

          if(showIntersectionJoins)
          {
              for(String d: destinations)
              {
                  PVector q = intersections.get(d).p;
                  line(p.x, p.y, q.x, q.y);
              }
          }
    }
}

class Edge
{
    float weight, cost, time;
    String startID, endID, segmentID;
    
    Edge()
    {
        weight = 0.0;
    }
}



void createGraph(HashMap<String, StreetSegment> streetSegz)
{
    int intersectionCount = 0;
    
    intersections =  new HashMap<String, Intersection>();
    edges = new HashMap<String, HashMap<String, Edge>>();
    
    for(String edgeName:streetSegz.keySet())
    {
        StreetSegment segment = streetSegz.get(edgeName);
        
        /*
            Create intersection
        */
        
        PVector start = segment.screenPoints.get(0);
        PVector end = segment.screenPoints.get(segment.points.size()-1);
        
        String startIntersectionName = "";
        String endIntersectionName = "";
        
        
        
            for(String intName:intersections.keySet())
            {
                Intersection i = intersections.get(intName);
                if(start.equals(i.p))
                {
                    startIntersectionName = intName;
                }
                
                if(end.equals(i.p))
                {
                    endIntersectionName = intName;
                }
            }
        
        
        if(startIntersectionName.equals("")) 
        {
            startIntersectionName = Integer.toString(intersectionCount);
            Intersection newint = new Intersection();
            newint.ID = startIntersectionName;
            newint.p = start;
            intersections.put(newint.ID, newint);
            
            intersectionCount++;
            
        }
        
        if(endIntersectionName.equals("")) 
        {
            endIntersectionName = Integer.toString(intersectionCount);
            Intersection newint = new Intersection();
            newint.ID = endIntersectionName;
            newint.p = end;
            intersections.put(newint.ID, newint);
            
            intersectionCount++;
            
        }
        
        /*
            assuming that street segments are one-way...
        */
        
        intersections.get(startIntersectionName).destinations.add(endIntersectionName);
        intersections.get(endIntersectionName).destinations.add(startIntersectionName);
        
        /*
              Assign start and end intersections to segments
        */
        
        segment.startIntersection = startIntersectionName;
        segment.endIntersection = endIntersectionName;
        
        /*
            create edges
        */
        
        Edge eforward = new Edge();
        eforward.startID = startIntersectionName;
        eforward.endID = endIntersectionName;
        eforward.cost = segment.costs.x;
        eforward.segmentID = segment.ID;
        
        if(edges.get(startIntersectionName)==null) edges.put(startIntersectionName, new HashMap<String, Edge>());
        edges.get(startIntersectionName).put(endIntersectionName, eforward);
        
        
        Edge eback = new Edge();
        eback.startID = endIntersectionName;
        eback.endID = startIntersectionName;
        eback.cost = segment.costs.y;
        eback.segmentID = segment.ID;
        
        if(edges.get(endIntersectionName)==null) edges.put(endIntersectionName, new HashMap<String, Edge>());
        edges.get(endIntersectionName).put(startIntersectionName, eback);
    }

    
}
