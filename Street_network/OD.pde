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
    
    
}
