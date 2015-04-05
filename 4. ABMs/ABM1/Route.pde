class Route
{
    ArrayList<String> intersectionIDs;
    String startOD, endOD;
    float totalCost, totalTime;
    
    Route()
    {
        intersectionIDs= new ArrayList<String>();
    }
    
    Route(ArrayList<String> fpath)
    {
        intersectionIDs= fpath;
    }
    
    void display(HashMap<String, Intersection> intz)
    {
        for(int i = 1; i<intersectionIDs.size(); i++)
        {
            String s1 =  intersectionIDs.get(i-1);
            String s2 =  intersectionIDs.get(i);
            line(intz.get(s1).p.x, intz.get(s1).p.y, intz.get(s2).p.x, intz.get(s2).p.y);
        }
    }
    
    void findTotalCost()
    {
        totalCost = 0;
        int nullCounter = 0;
        
        baduns = new ArrayList<String>();
        for(int i = 1; i<intersectionIDs.size(); i++)
        {
            String s1 = intersectionIDs.get(i-1);
            String s2 = intersectionIDs.get(i);
            
            if(edges.get(s1).get(s2)==null) 
            {
              //println(s1 + " " +s2 + " " + i);
              baduns.add(startOD + " " + endOD + " " + s1 + " " + s2);
              nullCounter++;
            }
            else totalCost += edges.get(s1).get(s2).cost;
            
            
        }
        
        //println(startOD + " " + endOD + " " + nullCounter + "/" + intersectionIDs.size());
    }
}

ArrayList<String> baduns;

void drawBadUns()
{
    println("baduns " + baduns.size());
    for(String s: baduns)
    {
        println("/" + s + "/");
        String [] sline = split(s, " ");
        String s1 = sline[2];
        String s2 = sline[3];
//        println(s1);
//        println(s2);

        if(!s1.equals("") && !s2.equals(""))
        {
            println("should draw");
            PVector p1 = intersections.get(s1).p;
            PVector p2 = intersections.get(s2).p;
            
            strokeWeight(5);
            stroke(0,255,200);
            //line(p1.x, p1.y, p2.x, p2.y);
            println(sline);
            Route r = routes.get(sline[0]).get(sline[1]);
            for(int i =1; i<r.intersectionIDs.size(); i++)
            {

                 String ss1 = r.intersectionIDs.get(i-1);
                 String ss2 = r.intersectionIDs.get(i);
                 
//                 println("ss1 " + ss1);
//                 println("ss2 " + ss2);
//                 if(intersections.get(ss1)!=null && intersections.get(ss2)!=null)
//                 {
//                     PVector pp1 = intersections.get(ss1).p;
//                     PVector pp2 = intersections.get(ss2).p;
//                     line(pp1.x, pp1.y, pp2.x, pp2.y);
//                     println(ss1 + " " + i);
//                 }
//                   if(edges.get(ss1).get(ss2)==null)
//                  {
//                      PVector pp1 = intersections.get(ss1).p;
//                      PVector pp2 = intersections.get(ss2).p;
//                       line(pp1.x, pp1.y, pp2.x, pp2.y);
//                       println(ss1 + " " + ss2);
//                  } 

                 
            }
            
        }
        
    }
}
