
class StreetSegment
{
    ArrayList<PVector> points;
    ArrayList<PVector> screenPoints;
    PVector costs;
    
    StreetSegment(ArrayList<PVector> pointsIn)
    {
        points = new ArrayList<PVector>();
        screenPoints = new ArrayList<PVector>();
        for(PVector p: pointsIn)
        {
            points.add(p.get());
            float x = map(p.x, lonmin, lonmax, 0, width);
            float y = map(p.y, latmin, latmax, height, 0);
            screenPoints.add(new PVector(x,y));
        }
    }
    
    void display()
    {
        colorMode(HSB);
        float fdiff = 2*(costs.x)/(costs.x+costs.y);
        stroke(100*fdiff, 255, 100, streetAlpha);
        for(int i = 1; i<screenPoints.size(); i++)
        {
            PVector p1 = screenPoints.get(i-1);
            PVector p2 = screenPoints.get(i); 
            bline(p1, p2);
            bline(p2, p1);
        }
        
        fdiff = 2*(costs.y)/(costs.x+costs.y);
        stroke(100*fdiff, 255, 100, streetAlpha);
        for(int i = 1; i<screenPoints.size(); i++)
        {
            PVector p1 = screenPoints.get(i-1);
            PVector p2 = screenPoints.get(i); 
            bline(p2, p1);
        }
    }
}
