

void createDualFromSegments()
{
    dualNodes = new HashMap<String, Node>();
    dualEdges = new HashMap<String, HashMap<String, Edge>>();
    
    //int dualNodeID = 0;
    int dualEdgeID = 0;
    
    println("creating dual");
    
    for(String streetSegName:streetNetwork.keySet())
    {
        StreetSegment seg = streetNetwork.get(streetSegName);
        PVector start = seg.screenPoints.get(0);
        PVector end = seg.screenPoints.get(seg.points.size()-1);
        
        Node dNode = new Node();
        //find segment centroid
        dNode.p = PVector.add(start,end);
        dNode.p.mult(0.5);
        //dualNode is IDed by segment ID
        dNode.ID = streetSegName;
        dualNodes.put(streetSegName, dNode);
        
        if(streetSegName.equals("11679")) println("*********************** " + streetSegName);
    }
//    println(streetNetwork.get("11679"));
//    println(dualNodes.get("11679"));
    
//    
//    Iterator<String> itn = dualNodes.keySet().iterator();
//    Iterator<String> its = streetNetwork.keySet().iterator();
    
//    while(its.hasNext())
//    {
//        String sn = itn.next();
//        String ss = its.next();
//        
//        //if(!sn.equals(ss)) println("String matching: segment:  " + ss + " /node: " + sn);
//        println(ss + " " + dualNodes.get(ss).ID);
//    }
    
    for(String streetSegName:streetNetwork.keySet())
    { 
      
        StreetSegment seg = streetNetwork.get(streetSegName);
        PVector start = seg.screenPoints.get(0);
        PVector end = seg.screenPoints.get(seg.points.size()-1);
        
        Node dNode = dualNodes.get(streetSegName);
        
        
            /*
              For turning-based costs
            */
            PVector forward1 = PVector.sub(end,start);
            PVector back1 = PVector.sub(start,end);
            
            for(String streetSegName2:streetNetwork.keySet())
            {
                StreetSegment seg2 = streetNetwork.get(streetSegName2);
                PVector s2 = seg2.screenPoints.get(0);
                PVector e2 = seg2.screenPoints.get(seg2.points.size()-1);
                
                
                /*
                    If the start of seg2 is the end of this segment
                    We only really need to do this one direction
                */
                if(end.equals(s2))
                {
                    //forward cost
                    Edge de = new Edge();
                    de.cost = 0.5*(seg.costs.x + seg2.costs.x);
                    de.startID = seg.ID;
                    de.endID = seg2.ID;
                                    
                    if(dualEdges.get(seg.ID)==null) dualEdges.put(seg.ID, new HashMap<String, Edge>());
                    dualEdges.get(seg.ID).put(seg2.ID, de);
                    
                    //back cost
                    Edge de2 = new Edge();
                    de2.cost = 0.5*(seg.costs.y + seg2.costs.y);
                    de2.startID = seg2.ID;
                    de2.endID = seg.ID;
                                    
                    if(dualEdges.get(seg2.ID)==null) dualEdges.put(seg2.ID, new HashMap<String, Edge>());
                    dualEdges.get(seg2.ID).put(seg.ID, de2);
//                    println(dNode);
//                    println("IDS " + dNode.ID);
//                    println("seg2 " + seg2.ID);
//                    println(dNode.destinations);
                    String s = seg2.ID;
                    dNode.destinations.add(seg2.ID);
                    //if(dualNodes.get(seg2.ID)==null) println(s + " " + streetSegName2);
                    //dualNodes.get(seg2.ID).destinations.add(seg.ID);
                }

          
            
            
        }
//        else
//        {
//            println("null Node");
//        }
        
    }
    
    println("created dual");

}


