//class DualNode extends Node
//{
//    //node representing street segment
//    
//
//    void show()
//    {
//        noFill();
//        //astroke(0);
//        ellipse(p.x, p.y, 5,5);
//    }
//}
//
//class DualEdge extends Edge
//{
//    //dual edge - representing traversal between street segments
//    void display()
//    {
//        stroke(0);
//        
//    }
//}

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
        dNode.ID = seg.ID;
        dualNodes.put(dNode.ID, dNode);
        //dualNodeID++;
        
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
                de.weight = 0.5*(seg.costs.x + seg2.costs.x);
                de.startID = seg.ID;
                de.endID = seg2.ID;
                                
                if(dualEdges.get(seg.ID)==null) dualEdges.put(seg.ID, new HashMap<String, Edge>());
                dualEdges.get(seg.ID).put(seg2.ID, de);
                
                //back cost
                de = new Edge();
                de.weight = 0.5*(seg.costs.y + seg2.costs.y);
                de.startID = seg2.ID;
                de.endID = seg.ID;
                                
                if(dualEdges.get(seg2.ID)==null) dualEdges.put(seg2.ID, new HashMap<String, Edge>());
                dualEdges.get(seg2.ID).put(seg.ID, de);
                
                dNode.destinations.add(seg2.ID);
                //dualNodes.get(seg2.ID).destinations.add(seg.ID);
            }
//            
//            if(start.equals(e2))
//            {
//                //forward cost
//                Edge de = new Edge();
//                de.weight = 0.5*(seg.costs.x + seg2.costs.x);
//                de.startID = seg2.ID;
//                de.endID = seg.ID;
//                                
//                if(dualEdges.get(seg2.ID)==null) dualEdges.put(seg2.ID, new HashMap<String, Edge>());
//                dualEdges.get(seg2.ID).put(seg.ID, de);
//                
//                //back cost
//                de = new Edge();
//                de.weight = 0.5*(seg.costs.y + seg2.costs.y);
//                de.startID = seg.ID;
//                de.endID = seg2.ID;
//                                
//                if(dualEdges.get(seg.ID)==null) dualEdges.put(seg.ID, new HashMap<String, Edge>());
//                dualEdges.get(seg.ID).put(seg2.ID, de);
//                
//                dualNodes.get(seg2.ID).destinations.add(seg.ID);
//                //dualNodes.get(seg2.ID).destinations.add(seg.ID);
//            }
            
            
            
        }
        
    }
    
    println("created dual");

}


