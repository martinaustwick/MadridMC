HashMap<String, OD> posns = new HashMap<String, OD> ();
HashMap<String, HashMap<String, Float>> weight;
HashMap<String, StreetSegment> streetNetwork;


String network = "MatrixOD_Flow.csv";
String positions = "nodes.csv";
String streetFile = "Street Network with pseudotimes.csv";

float maxWeight = 0;
float maxStroke = 30;
float curviness = 0.2;
float maxThickness = 1;

float streetAlpha = 70;

/*
Latlon window
*/
float latmin = 4921500;
float latmax = 4937000;
float lonmin = -418000;
float lonmax = -404000;

void setup()
{
    size(1200, 1200);
    loadPosns();
    
    loadStreets();
    
    for(OD od:posns.values())
    {
        od.findNearestIntersection(streetNetwork);
    }
    
    weight = new HashMap<String, HashMap<String, Float>>();
    //makeUpWeights();
    loadWeight();
}

void makeUpWeights()
{
    for(String s:posns.keySet())
    {
        HashMap<String, Float> temp = new HashMap<String, Float>();
        for(String t:posns.keySet())
        {
            if(random(1)<0.001) temp.put(t, random(255));
        }
        
        if(temp.size()>0) weight.put(s, temp);
    }
}

void draw()
{
    background(255);
    stroke(0);
    //noFill();
    
   
    //drawWeights();
    
    for(StreetSegment sso: streetNetwork.values())
    {
        sso.display();
    }
    
    stroke(0);
     for(OD od: posns.values())
    {    
        //point(od.p.x, od.p.y);
        fill(0);
        ellipse(od.p.x, od.p.y, 5, 5);
        line(od.p.x, od.p.y, od.nearestIntersection.x, od.nearestIntersection.y);
        noFill();
        ellipse(od.nearestIntersection.x, od.nearestIntersection.y, 10, 10);
    }
      
}

void drawWeights()
{
    for(String s:weight.keySet())
    {
        for(String t: weight.get(s).keySet())
        {
          
            float w = weight.get(s).get(t);
            //println(w);
            if(abs(w)>0)
            {
                
                strokeWeight(maxThickness*weight.get(s).get(t)/maxWeight);
                stroke(0, maxStroke*weight.get(s).get(t)/maxWeight);
                //println(weight.get(s).get(t) + " " + maxWeight);
                
                
                PVector o = posns.get(s).p;
                PVector d = posns.get(t).p;
                //println(s + " " + t);
                if(o!=null && d!=null) {
                  //line(o.x, o.y, d.x, d.y);
                   if(s.equals(t))
                   {
                       ellipse(o.x, o.y, 10,10);
                       println("ohai");
                   }
                   else
                   {
                     bline(o,d);
                   }
                }
            }
        }
    }
}

void bline(PVector oh, PVector dee)
{
    PVector diff = PVector.sub(dee, oh);
    float angle = diff.heading();
   
    
    pushMatrix();
      translate(oh.x, oh.y);
      rotate(angle);
      //line(0,0,diff.mag(),0);
      
      float d = diff.mag();
      bezier(0.0,0.0, (1-curviness)*d, curviness*d, d, curviness*d, d, 0);
    popMatrix();
}




