void setupDIJ(String originID, HashMap<String, Node> nodes)
{
    clock = millis();
    for(Node n: nodes.values())
    {
          n.seen = false;
          n.d = 99999999;
    }
    
    saveNodes(nodes);
    
    if(dual) saveEdges(dualEdges);
    else saveEdges(edges);
    
    wList = new ArrayList<String>();
    wList.add(originID);
    //doneList = new ArrayList<String>();
    nodes.get(originID).d = 0;
    
    path =  new ArrayList<String>();
    it2 = ods.keySet().iterator();
    
    endOD = it2.next();
    if(dual) endString = ods.get(endOD).nearestDualNodeID;
    else endString = ods.get(endOD).nearestIntersectionID;
    
    pathString = endString;
    DIJforwardComplete = false;
    //pathString = ods.get(it2.next()).nearestIntersectionID;
    frameRate(4000);
}


ArrayList<String> wList, newwList;

boolean handij(HashMap<String, Node> nodes, HashMap<String, HashMap<String, Edge>> edgesIn)
{
    
    /*
        create a watchlist of candidate intersection IDs
    */
    
    
        boolean exhausted = true;
    
        //println("nodes.size() " + nodes.size());
        ArrayList<String> newwList = new ArrayList<String>();
        for(String w: wList)
        {
            /*
                The first time around, watchlist is one element
            */
            Node i = nodes.get(w);
            i.selecting = true;
            //ellipse(i.p.x, i.p.y, 10, 10);
            //println(wList.size());
            if(!i.seen)
            {
                for(String w2: i.destinations)
                {
                    float cost = i.d + edgesIn.get(w).get(w2).cost;
                    
                    Node i2 = nodes.get(w2);
                    if(i2.d>cost) {
                      i2.d = cost;
                      i2.seen = false;
                    }
                    newwList.add(w2);
                }
            }
            i.seen = true;
            //println(doneList.size() + " " + intersections.size());
        }
        
       
        wList = new ArrayList<String>();
        for(String ezz: newwList)
        {
            wList.add(ezz);
        }
        
        for(Node i:nodes.values())
        {
            if(!i.seen)
            {
                exhausted = false;
                break;
            }
        }
        
        
        return exhausted;
     
}

String reverseDIJstep(String destID, HashMap<String, Node> nodes)
{
    Node chaini = nodes.get(destID);
    //println("destID:"+destID + "/ " + intersections.size());
    int shortestInt = floor(random(chaini.destinations.size()));
    float currentD = chaini.d;
    float shortestIntersection = nodes.get(chaini.destinations.get(0)).d;
    String shortestString = "";
    
    for(String s: chaini.destinations)
    {
        //String s = chaini.destinations.get(i);
        //println(currentD + " " + intersections.get(s).d);
        if(intersections.get(s).d<currentD) 
        {
            currentD = intersections.get(s).d;
            shortestString = s;
            
        }
    }    
 
    
    return shortestString;
}

void showDIJ(HashMap<String, Node> nodes)
{
            for(OD od: ods.values())
            {    
               od.display();
            }
            
            if(showInterSections)
            {
                for(Node i: nodes.values())
                {
                    i.display();
//                    stroke(0, 100);
//                    for(String s: i.destinations)
//                    {
//                        PVector p = nodes.get(s).p;
//                        line(p.x, p.y, i.p.x, i.p.y);
//                    }
                }
                
            }
}
