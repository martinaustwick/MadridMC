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

ArrayList<String> wList, newwList, doneList;

void handij(String originID, int it)
{
    
    /*
        create a watchlist of candidate intersection IDs
    */
    
    
    
    
   
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
                      println(cost);
                    }
                    
                    newwList.add(w2);
                }
            }
            i.seen = true;
            doneList.add(w);
            //println(doneList.size() + " " + intersections.size());
        }
        
        wList = new ArrayList<String>();
        for(String ezz: newwList)
        {
          wList.add(ezz);
        }
        //println(it);
        
        
    
    
    
    
    
      
}

