void routePrep()
{
    if(loadRoutes)
    {
        routes = loadRoutes(routeFile);
    }
    else
    {
  
         /*
             Iterate through OD subset of intersections
         */
        
        it1 = ods.keySet().iterator();
        startOD = it1.next();
        startString = ods.get(startOD).nearestIntersectionID;
        //println
        
        //println(startString + " " + pathString);
        setupDIJ(startString);
        countpaths = 0;
        
        /*
            Readying for data outputs
        */
        
        dataOut = new Table();
        dataOut.addColumn("start_OD");
        dataOut.addColumn("end_OD");
        dataOut.addColumn("start_intersection");
        dataOut.addColumn("end_intersection");
        dataOut.addColumn("route_intersections");
    }
}

void setupDIJ(String originID)
{
    for(Intersection i: intersections.values())
      {
            i.seen = false;
            i.d = 99999999;
      }
    saveIntersections();
    saveEdges();
    
    wList = new ArrayList<String>();
    wList.add(originID);
    //doneList = new ArrayList<String>();
    intersections.get(originID).d = 0;
    
    path =  new ArrayList<String>();
    it2 = ods.keySet().iterator();
    
    endOD = it2.next();
    endString = ods.get(endOD).nearestIntersectionID;
    pathString = endString;
    DIJforwardComplete = false;
    //pathString = ods.get(it2.next()).nearestIntersectionID;
    frameRate(4000);
}

ArrayList<String> wList, newwList;

void DIJloop()
{
      if(!DIJforwardComplete)
    {
        if(showPathfinding)
        {
            background(255);
            if(showStreets)
            {
              for(StreetSegment sso: streetNetwork.values())
              {
                  sso.display();
              }
            }
            
            stroke(0);
            showDIJ(); 
        }
    }
    
    if(!DIJforwardComplete)
    {
        //println(millis() - startTime);
        DIJforwardComplete = handij();
    }
    else   
    {
        //HashMap<String, ArrayList<String>> tracks = n
      
        float startPath = millis();
        while(!pathString.equals(startString))
        {
            path.add(pathString);
            pathString =  reverseDIJstep(pathString);
        }
        //println(millis()-startPath);
        path.add(startString);
        if(pathString.equals(startString))
        {
            Intersection bp1;
            Intersection bp2 = new Intersection();
            ArrayList<String> forwardPath = new ArrayList<String>();
            
            stroke(0);
            strokeWeight(2);
            for(int i = path.size()-1; i>0; i--)
            {
                String s1 = path.get(i-1);
                String s2 = path.get(i);
                
                
                if(showPathfinding)
                {
                    
                    
                    bp1 = intersections.get(s1);
                    bp2 = intersections.get(s2);
                    line(bp1.p.x, bp1.p.y, bp2.p.x, bp2.p.y);
                }
                
                forwardPath.add(s2);
            }
            forwardPath.add(startString);
            if(routes.get(startString)==null) routes.put(startString, new HashMap<String, Route>());            
            routes.get(startString).put(endString, new Route(forwardPath));
            strokeWeight(1);
            
            if(it2.hasNext())
            {
                //pathString = ods.get(it2.next()).nearestIntersectionID;
                endOD = it2.next();
                endString = ods.get(endOD).nearestIntersectionID;
                pathString = endString;
                path = new ArrayList<String>();
                
            }
            else
            {
                saveRoutes();
                
                println("framerate " + frameRate);
                background(255);
                showDIJ(); 
                
                if(it1.hasNext())
                {
                    startOD = it1.next();
                    startString = ods.get(startOD).nearestIntersectionID;
                    setupDIJ(startString);
                    println("completed " +(countpaths+1) + " of " + ods.size());
                    countpaths++;
                }
                else
                {
                    noLoop();
                }
            }
        }
    }
}

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
                }
            }
}
