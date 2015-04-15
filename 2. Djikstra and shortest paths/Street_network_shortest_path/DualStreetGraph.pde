class DualNode extends Intersection
{
    //node representing street segment
    

    void show()
    {
        noFill();
        stroke(0);
        ellipse(p.x, p.y, 5,5);
    }
}

class DualEdge extends Edge
{
    //edge representing traversal between street segments
}

void createDualFromSegments()
{
    dualNodes = new HashMap<String, DualNode>();
    dualEdges = new HashMap<String, HashMap<String, DualEdge>>();
    
    int dualNodeID = 0;
    int dualEdgeID = 0;
    
    for(String streetSegName:streetNetwork.keySet())
    {
        StreetSegment seg = streetNetwork.get(streetSegName);
        PVector start = seg.screenPoints.get(0);
        PVector end = seg.screenPoints.get(seg.points.size()-1);
        
        DualNode dNode = new DualNode();
        dNode.p = PVector.add(start,end);
        dNode.p.mult(0.5);
        dNode.ID = Integer.toString(dualNodeID);
        dualNodes.put(dNode.ID, dNode);
        dualNodeID++;
        
    }
}

void createDualGraph()
{
    dualNodes = new HashMap<String, DualNode>();
    dualEdges = new HashMap<String, HashMap<String, DualEdge>>();
    
    int dualNodeID = 0;
    int dualEdgeID = 0;
    
    String startIntersectionName = "";
    String endIntersectionName = "";
        
    
    
    for(String streetSegName:streetNetwork.keySet())
    {
        StreetSegment seg = streetNetwork.get(streetSegName);
        PVector start = seg.screenPoints.get(0);
        PVector end = seg.screenPoints.get(seg.points.size()-1);
        PVector midPoint =  PVector.add(start,end);
        midPoint.mult(0.5);
        
        String startDualNodeName = "";
        String endDualNodeName = "";
        
        for(String dnName:dualNodes.keySet())
        {
            DualNode dn = dualNodes.get(dnName);
//            if(start.equals(i.p))
//            {
//                startIntersectionName = intName;
//            }
//            
//            if(end.equals(i.p))
//            {
//                endIntersectionName = intName;
//            }
        }
        
        
        DualNode dNode = new DualNode();
        dNode.p = PVector.add(start,end);
        dNode.p.mult(0.5);
        dNode.ID = Integer.toString(dualNodeID);
        dualNodes.put(dNode.ID, dNode);
        dualNodeID++;
        
    }
}
