class Route
{
    ArrayList<String> intersectionIDs;
    float totalCost, totalTime;
    
    Route()
    {
        intersectionIDs= new ArrayList<String>();
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
}
