/*
    Max weight on an edge between intersections
*/
float maxEdgeWeight = 0;
String testOD = "239";

void weightEdges()
{
    
    for(String sod: flows.keySet())
    {
        for(String eod: flows.get(sod).keySet())
        {
            Flow flow = flows.get(sod).get(eod);
            if(flow.weight>0)
            {
                Route r = routes.get(sod).get(eod);
                if(r!=null)
                {
                    for(int i = 1; i<r.intersectionIDs.size(); i++)
                    {
                        String is1 = r.intersectionIDs.get(i-1);
                        String is2 = r.intersectionIDs.get(i);
                        edges.get(is1).get(is2).weight+=flow.weight;
                        
                    }
                }
            }
        }
    }
    
    /*
        Test 
    */
    // println("testrun");
    // for(Route r:routes.get(testOD).values())
    // {
    //     println(r.startOD + " " + r.endOD);
    // }
    
}

void drawEdges()
{
    println("drawedges");
    for(String i1: edges.keySet())
    {
        for(String i2: edges.get(i1).keySet())
        {
          
            //println(i1 + " " + i2);
            PVector p1 = intersections.get(i1).p;
            PVector p2 = intersections.get(i2).p;
            
            //if(edges.get(i1).get(i2).weight>1)println(edges.get(i1).get(i2).weight);
            float liner = edges.get(i1).get(i2).weight/maxEdgeWeight;
            //if(liner>0.99) println(liner);
            strokeWeight(10*liner);
            stroke(0);
            line(p1.x, p1.y, p2.x, p2.y);
        }
    }
    
    println("maxEdge" + maxEdgeWeight);
}
