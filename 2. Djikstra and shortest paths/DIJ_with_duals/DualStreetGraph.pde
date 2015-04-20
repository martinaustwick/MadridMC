float rightCost = 19;
float leftCost = 20;
float forwardCost = 0;

void createDualFromSegments()
{
    dualNodes = new HashMap<String, Node>();
    dualEdges = new HashMap<String, HashMap<String, Edge>>();
    
    //int dualNodeID = 0;
    int dualEdgeID = 0;
    
    println("creating dual");
    
//    String tempID = "6149";
//    println("Bad node: end: " + streetNetwork.get(tempID).screenPoints.get(streetNetwork.get(tempID).screenPoints.size()-1) + " start: " + streetNetwork.get(tempID).screenPoints.get(0));
//    tempID = "5938";
//    println("Close node " + streetNetwork.get(tempID).screenPoints.get(streetNetwork.get(tempID).screenPoints.size()-1) + " " + streetNetwork.get(tempID).screenPoints.get(0));
//    tempID = "6188";
//    println("Close node " + streetNetwork.get(tempID).screenPoints.get(streetNetwork.get(tempID).screenPoints.size()-1) + " " + streetNetwork.get(tempID).screenPoints.get(0));
//    tempID = "6266";
//    println("Close node " + streetNetwork.get(tempID).screenPoints.get(streetNetwork.get(tempID).screenPoints.size()-1) + " " + streetNetwork.get(tempID).screenPoints.get(0));

    
    
    int mismatchCount = 0;
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
        
        /*
            This is fixed, retained for legacy
        */        
        if(!seg.ID.equals(streetSegName)) 
        {
          println("Streetseg  " + streetSegName + " seg ID " + seg.ID + " count " + mismatchCount + "/" + streetNetwork.size());
          mismatchCount++;
        }
        //if(streetSegName.equals("11679")) println("*********************** " + streetSegName);
    }

    
    for(String streetSegName:streetNetwork.keySet())
    { 
      
        StreetSegment seg = streetNetwork.get(streetSegName);
        PVector start = seg.screenPoints.get(0);
        PVector end = seg.screenPoints.get(seg.points.size()-1);
        
        Node dNode = dualNodes.get(streetSegName);
        
        
            /*
              For turning-based costs
            */
            PVector forward1 = PVector.sub(end, seg.screenPoints.get(seg.points.size()-1));
            PVector back1 = PVector.sub(start,seg.screenPoints.get(1));
            
            for(String streetSegName2:streetNetwork.keySet())
            {
                StreetSegment seg2 = streetNetwork.get(streetSegName2);
                PVector s2 = seg2.screenPoints.get(0);
                PVector e2 = seg2.screenPoints.get(seg2.points.size()-1);
               
                
               
                if(end.equals(s2))
                {
                    //forward edge
                    Edge de = new Edge();
                    de.cost = 0.5*(seg.costs.x + seg2.costs.x);
                    
                    //turning costs
                    PVector forward2 = PVector.sub(seg2.screenPoints.get(0), seg2.screenPoints.get(0));
                    float turn = forward2.heading() - forward1.heading();
                    
                    float turnCost = 0;
                    if(turn<PI/4 || turn>7*PI/4) turnCost = forwardCost;
                    if(turn>PI/4 && turn<3*PI/4) turnCost =rightCost;
                    if(turn>3*PI/4 && turn<7*PI/4) turnCost =leftCost;
                    de.cost+=turnCost;
                    
                    de.startID = streetSegName;
                    de.endID = streetSegName2;
                    de.ID = Integer.toString(dualEdgeID);
                    dualEdgeID++;
                                    
                    if(dualEdges.get(seg.ID)==null) dualEdges.put(seg.ID, new HashMap<String, Edge>());
                    dualEdges.get(seg.ID).put(seg2.ID, de);
                    
                    //back edge
                    Edge de2 = new Edge();
                    de2.cost = 0.5*(seg.costs.y + seg2.costs.y);
                    de2.startID = streetSegName2;
                    de2.endID = streetSegName;
                    de2.ID = Integer.toString(dualEdgeID);
                    dualEdgeID++;
                                    
                    if(dualEdges.get(seg2.ID)==null) dualEdges.put(seg2.ID, new HashMap<String, Edge>());
                    dualEdges.get(seg2.ID).put(seg.ID, de2);

                    /*
                        Populate destinations field in source and destination node
                    */
                    dNode.destinations.add(streetSegName2);
                    dualNodes.get(streetSegName2).destinations.add(streetSegName);
                }
                
                if(start.equals(s2))
                {
                    //forward edge
                    
                    Edge de = new Edge();
                    de.cost = 0.5*(seg.costs.y + seg2.costs.x);
                    de.startID = streetSegName;
                    de.endID = streetSegName2;
                    de.ID = Integer.toString(dualEdgeID);
                    dualEdgeID++;
                                    
                    if(dualEdges.get(seg.ID)==null) dualEdges.put(seg.ID, new HashMap<String, Edge>());
                    dualEdges.get(seg.ID).put(seg2.ID, de);
//                    
//                    //back edge
//                    Edge de2 = new Edge();
//                    de2.cost = 0.5*(seg.costs.x + seg2.costs.y);
//                    de2.startID = streetSegName2;
//                    de2.endID = streetSegName;
//                    de2.ID = Integer.toString(dualEdgeID);
//                    dualEdgeID++;
//                                    
//                    if(dualEdges.get(seg2.ID)==null) dualEdges.put(seg2.ID, new HashMap<String, Edge>());
//                    dualEdges.get(seg2.ID).put(seg.ID, de2);

                    /*
                        Populate destinations field in source and destination node
                    */
                    dNode.destinations.add(streetSegName2);
                    //dualNodes.get(streetSegName2).destinations.add(streetSegName);
                }
                
                if(end.equals(e2))
                {
                    //forward edge
                    Edge de = new Edge();
                    de.cost = 0.5*(seg.costs.x + seg2.costs.y);
                    de.startID = streetSegName;
                    de.endID = streetSegName2;
                    de.ID = Integer.toString(dualEdgeID);
                    dualEdgeID++;
                                    
                    if(dualEdges.get(seg.ID)==null) dualEdges.put(seg.ID, new HashMap<String, Edge>());
                    dualEdges.get(seg.ID).put(seg2.ID, de);
                    
//                    //back edge
//                    Edge de2 = new Edge();
//                    de2.cost = 0.5*(seg.costs.y + seg2.costs.x);
//                    de2.startID = streetSegName2;
//                    de2.endID = streetSegName;
//                    de2.ID = Integer.toString(dualEdgeID);
//                    dualEdgeID++;
//                                    
//                    if(dualEdges.get(seg2.ID)==null) dualEdges.put(seg2.ID, new HashMap<String, Edge>());
//                    dualEdges.get(seg2.ID).put(seg.ID, de2);

                    /*
                        Populate destinations field in source and destination node
                    */
                    dNode.destinations.add(streetSegName2);
                    //dualNodes.get(streetSegName2).destinations.add(streetSegName);
                }
        }

        
    }
    


//    
//    int noDestinations = 0;
//    for(String s:dualNodes.keySet())
//    {
//        Node n = dualNodes.get(s);
//        
//        if(n.destinations.size()==0) 
//        {
//          String whichInter = "";
//          for(String s2:intersections.keySet())
//          {
//              if(intersections.get(s2).p.equals(streetNetwork.get(s).screenPoints.get(0)))
//              {
//                  whichInter = s;
//                  println("no destinations " + n.ID + " " + s2 + " " + intersections.get(s2).destinations);
//              }
//              
//              if(intersections.get(s2).p.equals(streetNetwork.get(s).screenPoints.get(streetNetwork.get(s).screenPoints.size()-1)))
//              {
//                  whichInter = s;
//                  println("no destinations " + n.ID + " " + s2 + " " + intersections.get(s2).destinations);
//              }
//          }
//          //println("no destinations " + n.ID);
//          noDestinations++;
//        }
//    }
//    println("no destinations " + noDestinations);
    
    println("created dual");

}


