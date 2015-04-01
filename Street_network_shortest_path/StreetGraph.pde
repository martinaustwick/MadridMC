class Intersection
{
    String ID;
    ArrayList<String> destinations;
    PVector p;    
    
    Intersection()
    {
        destinations = new ArrayList<String>();
    }
    
    void display()
    {
        stroke(0);
        
        rect(p.x, p.y, 5,5);
//        fill(0);
//        text(ID, p.x, p.y);
//        noFill();
          if(showIntersectionJoins)
          {
              println(destinations.size());
              for(String d: destinations)
              {
                  PVector q = intersections.get(d).p;
                  line(p.x, p.y, q.x, q.y);
              }
          }
    }
}

HashMap<String, Intersection> createIntersections(HashMap<String, StreetSegment> streetSegz)
{
    int intersectionCount = 0;
    
    HashMap<String, Intersection> ints =  new HashMap<String, Intersection> ();
    
    for(String edgeName:streetSegz.keySet())
    {
        StreetSegment edge = streetSegz.get(edgeName);
        
        /*
            Create intersection
        */
        
        PVector start = edge.screenPoints.get(0);
        PVector end = edge.screenPoints.get(edge.points.size()-1);
        
        String startIntersectionName = "";
        String endIntersectionName = "";
        
        
        
            for(String intName:ints.keySet())
            {
                Intersection i = ints.get(intName);
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
            ints.put(newint.ID, newint);
            
            intersectionCount++;
            
        }
        
        if(endIntersectionName.equals("")) 
        {
            endIntersectionName = Integer.toString(intersectionCount);
            Intersection newint = new Intersection();
            newint.ID = endIntersectionName;
            newint.p = end;
            ints.put(newint.ID, newint);
            
            intersectionCount++;
            
        }
        
        ints.get(startIntersectionName).destinations.add(endIntersectionName);
        ints.get(endIntersectionName).destinations.add(startIntersectionName);
    }
    println(ints.size());
    return ints;
    
}




