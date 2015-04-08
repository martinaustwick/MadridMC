
class StreetSegment
{
    ArrayList<PVector> points;
    ArrayList<PVector> screenPoints;
    PVector costs;
    String ID;
    color c;
    String startIntersection, endIntersection;
    
    StreetSegment(ArrayList<PVector> pointsIn)
    {
        points = new ArrayList<PVector>();
        screenPoints = new ArrayList<PVector>();
        for(PVector p: pointsIn)
        {
            points.add(p.get());
            float x = map(p.x, lonmin, lonmax, 0, width);
            float y = map(p.y, latmin, latmax, h, 0);
            screenPoints.add(new PVector(x,y));
        }
        colorMode(HSB);
        c= color(random(255), 255, 200);
    }
    
    void lines()
    {
        
        for(int i = 1; i<screenPoints.size(); i++)
        {
            PVector p1 = screenPoints.get(i-1);
            PVector p2 = screenPoints.get(i); 
            line(p2.x, p2.y, p1.x, p1.y);
        }
    }
    
    void display()
    {
        
        float fdiff = (costs.x)/(costs.x+costs.y);
        stroke(c);
        //stroke(255*fdiff, 255, 100, streetAlpha);
        for(int i = 1; i<screenPoints.size(); i++)
        {
            PVector p1 = screenPoints.get(i-1);
            PVector p2 = screenPoints.get(i); 
            bline(p1, p2);
        }
        
        fdiff = (costs.y)/(costs.x+costs.y);

        
        for(int i = 1; i<screenPoints.size(); i++)
        {
            PVector p1 = screenPoints.get(i-1);
            PVector p2 = screenPoints.get(i); 
            bline(p2, p1);
        }
    }
    
    void displayForward()
    {
        
   
        for(int i = 1; i<screenPoints.size(); i++)
        {
            PVector p1 = screenPoints.get(i-1);
            PVector p2 = screenPoints.get(i); 
            bline(p1, p2);
        }
        
        
    }
    
    void displayBack()
    {
        
        for(int i = 1; i<screenPoints.size(); i++)
        {
            PVector p1 = screenPoints.get(i-1);
            PVector p2 = screenPoints.get(i); 
            bline(p2, p1);
        }
    }
}
