HashMap<String, OD> posns = new HashMap<String, OD> ();
HashMap<String, HashMap<String, Float>> weight;
HashMap<String, StreetSegment> streetNetwork;

HashMap<String, Intersection> intersections;
HashMap<String, HashMap<String, Edge>> edges;

String network = "MatrixOD_Flow.csv";
String positions = "nodes.csv";
String streetFile = "Street Network with pseudotimes.csv";

float maxWeight = 0;
float maxStroke = 30;
float curviness = 0.2;
float maxThickness = 1;

float streetAlpha = 100;

/*
Latlon window
Actually, we're using Eastings and Northings here, so projection is dead easy
*/
float latmin = 4921500;
float latmax = 4937000;
float lonmin = -418000;
float lonmax = -406000;

int h = 1700;

String startString = "5";
String pathString = "70";

boolean DIJforwardComplete = false;


void setup()
{
    
    
    float dlat = (latmax-latmin);
    float dlon =  (lonmax-lonmin);
    
    size(int((h*dlon)/dlat), h);
    println(width + " " + height);
    
    loadPosns();
    
    loadStreets();
    
    //intersections = createIntersections(streetNetwork);
    createGraph(streetNetwork);
    for(OD od:posns.values())
    {
        od.findNearestIntersection(intersections);
    }
    
    
    
    weight = new HashMap<String, HashMap<String, Float>>();
    //makeUpWeights();
    loadWeight();
    
    rectMode(CENTER);
    colorMode(HSB);
    
//    float startTime = millis();
//    dij("1");
//    println(millis()-startTime);


    /*
        bits for handij
    */
    
    
    setupDIJ(startString);
    
}

void setupDIJ(String originID)
{
    for(Intersection i: intersections.values())
      {
            i.seen = false;
            i.d = 999999;
      }

    wList = new ArrayList<String>();
    wList.add(originID);
    //doneList = new ArrayList<String>();
    intersections.get(originID).d = 0;
}

//void makeUpWeights()
//{
//    for(String s:posns.keySet())
//    {
//        HashMap<String, Float> temp = new HashMap<String, Float>();
//        for(String t:posns.keySet())
//        {
//            if(random(1)<0.001) temp.put(t, random(255));
//        }
//        
//        if(temp.size()>0) weight.put(s, temp);
//    }
//}

void draw()
{
    background(255);
    stroke(0);
    //noFill();
    
   
    //drawWeights();
    
    if(showStreets)
    {
      for(StreetSegment sso: streetNetwork.values())
      {
          sso.display();
      }
    }
    
    stroke(0);
     for(OD od: posns.values())
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
      
    float startTime = millis(); 
     
    
    if(!DIJforwardComplete)
    {
        //println(millis() - startTime);
        DIJforwardComplete = handij();
    }
    else   
    {
        pathString =  reverseDIJstep(startString, pathString);
        //println(pathString);
        noFill();
        Intersection bp = intersections.get(pathString);
        ellipse(bp.p.x, bp.p.y, 50, 50);
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
                       //println("ohai");
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




