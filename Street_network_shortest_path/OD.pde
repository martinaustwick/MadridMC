class OD
{
    PVector p, nearestIntersection;
    String nearestIntersectionID;
    
    
    
//    void findNearestIntersection(HashMap<String, StreetSegment> streets)
//    {
//        /*
//            Confusingly, this actually derives the *start* of the nearest *segment*
//        */
//        float minDistance = 500;
//        for(String s: streets.keySet())
//        {
//            float dist = PVector.dist(p, streets.get(s).screenPoints.get(0));
//            if(dist<minDistance)
//            {
//                nearestIntersectionID = s;
//                minDistance = dist;
//                nearestIntersection = streets.get(s).screenPoints.get(0);
//            }
//        }
//    }
    
    void findNearestIntersection(HashMap<String, Intersection> intz)
    {
        /*
            Derives intersection from intersections
            These two methods aren't really compatible
        */
        float minDistance = 50000;
        for(String s: intz.keySet())
        {
            float dist = PVector.dist(p, intz.get(s).p);
            if(dist<minDistance)
            {
                nearestIntersectionID = s;
                minDistance = dist;
                nearestIntersection = intz.get(s).p;
                
            }
        }
    }
    
    void display()
    {
        //fill(0,255,200);
        noFill();
        ellipse(p.x, p.y, 20, 20);
        line(p.x, p.y, nearestIntersection.x, nearestIntersection.y);
        if(frameCount<2) intersections.get(nearestIntersectionID).isOD = true;
        //text(nearestIntersectionID, nearestIntersection.x, nearestIntersection.y);
        
        //ellipse(nearestIntersection.x, nearestIntersection.y, 10, 10);
    }
    
}
