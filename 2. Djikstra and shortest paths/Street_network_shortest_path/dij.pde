void dij(String originID)
{
    /*
        use edges and intersections objects
    */
    
   
    
    /*
        Key: intersection ID
        populate these with values
    */
    
//    HashMap<String, Boolean> considered = new HashMap<String, Boolean>();
//    HashMap<String, Float> distanceFromOrigin = new HashMap<String, Float>();
//    
//    for(String ID: intersections.keySet())
//    {
//        if(ID.equals(originID))
//        {
//            considered.put(ID, true);
//            distanceFromOrigin.put(ID, 0.0);
//        }
//        else
//        {
//            considered.put(ID, true);
//            distanceFromOrigin.put(ID, 50000000.0);
//        }        
//    }

      for(Intersection i: intersections.values())
      {
            i.seen = false;
            i.d = 999999;
      }
    
    /*
        create a watchlist of candidate intersection IDs
    */
    
    ArrayList<String> doneList = new ArrayList<String>();
    ArrayList<String> watchList = new ArrayList<String>();
    watchList.add(originID);
    intersections.get(originID).d = 0;
    
    while(doneList.size()<intersections.size())
    {
        ArrayList<String> newwatchList = new ArrayList<String>();
        for(String w: watchList)
        {
          
            /*
                The first time around, watchlist is one element
            */
            Intersection i = intersections.get(w);
            if(!i.seen)
            {
                for(String w2: i.destinations)
                {
                    float cost = i.d + edges.get(w).get(w2).cost;
                    
                    Intersection i2 = intersections.get(w2);
                    if(i2.d<cost) i2.d = cost;
                    
                    newwatchList.add(w2);
                }
            }
            i.seen = true;
            doneList.add(w);
            //println(doneList.size() + " " + intersections.size());
        }
        
        watchList = new ArrayList<String>();
        for(String ezz: newwatchList)
        {
          watchList.add(ezz);
        }
        
    }
    
    
    
    
      
}

ArrayList<String> wList, newwList;

boolean handij()
{
    
    /*
        create a watchlist of candidate intersection IDs
    */
    
    
        boolean exhausted = true;
    
   
        ArrayList<String> newwList = new ArrayList<String>();
        for(String w: wList)
        {
          
            /*
                The first time around, watchlist is one element
            */
            Intersection i = intersections.get(w);
            i.selecting = true;
            //ellipse(i.p.x, i.p.y, 10, 10);
            //println(wList.size());
            if(!i.seen)
            {
                for(String w2: i.destinations)
                {
                    float cost = i.d + edges.get(w).get(w2).cost;
                    
                    Intersection i2 = intersections.get(w2);
                    if(i2.d>cost) {
                      i2.d = cost;
                      i2.seen = false;
                      //println(cost);
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
        //println(it);
        
        for(Intersection i:intersections.values())
        {
            if(!i.seen)
            {
                exhausted = false;
                break;
            }
        }
        
        if(exhausted)
        {
            //println("Boy! I'm exhausted");
        }
        
        return exhausted;
     
}

String reverseDIJstep(String destID)
{
    Intersection chaini = intersections.get(destID);
    //println("destID:"+destID + "/ " + intersections.size());
    int shortestInt = floor(random(chaini.destinations.size()));
    float currentD = chaini.d;
    float shortestIntersection = intersections.get(chaini.destinations.get(0)).d;
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

void showDIJ()
{
            for(OD od: ods.values())
            {    
               od.display();
            }
            
            if(showInterSections)
            {
                for(Intersection i: intersections.values())
                {
                    i.display();
                    stroke(0, 100);
//                    for(String s: i.destinations)
//                    {
//                        PVector p = intersections.get(s).p;
//                        line(p.x, p.y, i.p.x, i.p.y);
//                    }
                }
                
                for(DualNode d: dualNodes.values())
                {
                    d.show();
                }
                
                
            }
}
