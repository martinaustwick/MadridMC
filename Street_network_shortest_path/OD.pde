class OD
{
    PVector p, nearestIntersection;
    String nearestIntersectionID;
    
    
    
    void findNearestIntersection(HashMap<String, StreetSegment> streets)
    {
        float minDistance = 500;
        for(String s: streets.keySet())
        {
            float dist = PVector.dist(p, streets.get(s).screenPoints.get(0));
            if(dist<minDistance)
            {
                nearestIntersectionID = s;
                minDistance = dist;
                nearestIntersection = streets.get(s).screenPoints.get(0);
            }
        }
    }
    
    void display()
    {
        //fill(0);
        ellipse(p.x, p.y, 5, 5);
        line(p.x, p.y, nearestIntersection.x, nearestIntersection.y);
        //text(nearestIntersectionID, nearestIntersection.x, nearestIntersection.y);
        noFill();
        //ellipse(nearestIntersection.x, nearestIntersection.y, 10, 10);
    }
    
}
