/*
    Max weight on an edge between intersections
*/
float maxEdgeWeight = 0;

void weightEdges()
{
  
    for(String sod: routes.keySet())
    {
        for(String eod: routes.get(sod).keySet())
        {
            Route r = routes.get(sod).get(eod);
            println(sod + " " + eod);
            for(int i = 1; i<r.intersectionIDs.size(); i++)
            {
                String starti = r.intersectionIDs.get(i-1);
                String endi = r.intersectionIDs.get(i);
                
                if(starti!=null && endi!=null)
                {
                    println(starti + " " + endi);
                    /*
                          how to deal with nullpointers?
                    */
                    if(edges.get(starti).get(endi)!=null)
                    {
                        edges.get(starti).get(endi).weight += 1;
                        if(edges.get(starti).get(endi).weight>maxEdgeWeight) maxEdgeWeight = edges.get(starti).get(endi).weight;
                    }
                }
            }
        }
    }
    
    
}

void drawEdges()
{
    for(String i1: edges.keySet())
    {
        for(String i2: edges.get(i1).keySet())
        {
          
            //println(i1 + " " + i2);
            PVector p1 = intersections.get(i1).p;
            PVector p2 = intersections.get(i2).p;
            
            float liner = edges.get(i1).get(i2).weight/maxEdgeWeight;
            //println(liner);
            strokeWeight(10*liner);
            stroke(0);
            line(p1.x, p1.y, p2.x, p2.y);
            
        }
    }
}
