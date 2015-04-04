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
              println(s1 + " " +s2 + " " + i);
              baduns.add(s1 + " " + s2);
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
    }
}
