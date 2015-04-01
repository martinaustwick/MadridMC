import java.util.*;

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

int h = 700;

String startString = "1";
String pathString = "500";

//backwards pathfinding
boolean DIJforwardComplete = false;
ArrayList<String> path;
Iterator<String> it1,it2;
int countpaths;

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
    



    /*
         Iterate through OD subset of intersections
     */
    
    it1 = posns.keySet().iterator();
    startString = posns.get(it1.next()).nearestIntersectionID;
    //println
    
    println(startString + " " + pathString);
    setupDIJ(startString);
    countpaths = 0;
    
}

void setupDIJ(String originID)
{
    for(Intersection i: intersections.values())
      {
            i.seen = false;
            i.d = 99999999;
      }

    wList = new ArrayList<String>();
    wList.add(originID);
    //doneList = new ArrayList<String>();
    intersections.get(originID).d = 0;
    
    path =  new ArrayList<String>();
    it2 = posns.keySet().iterator();
    pathString = posns.get(it2.next()).nearestIntersectionID;
    DIJforwardComplete = false;
    //pathString = posns.get(it2.next()).nearestIntersectionID;
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
        //HashMap<String, ArrayList<String>> tracks  
      
        float startPath = millis();
        while(!pathString.equals(startString))
        {
            path.add(pathString);
            pathString =  reverseDIJstep(pathString);
        }
        //println(millis()-startPath);
        
        if(pathString.equals(startString))
        {
            for(int i = 1; i<path.size(); i++)
            {
                String s1 = path.get(i-1);
                String s2 = path.get(i);
                Intersection bp1 = intersections.get(s1);
                Intersection bp2 = intersections.get(s2);
                
                stroke(0);
                strokeWeight(5);
                line(bp1.p.x, bp1.p.y, bp2.p.x, bp2.p.y);
            }
              strokeWeight(1);
            
            if(it2.hasNext())
            {
                pathString = posns.get(it2.next()).nearestIntersectionID;
                path = new ArrayList<String>();
                println("completed " +(countpaths+1) + " of " + posns.size());
                countpaths++;
            }
            else
            {
                startString = posns.get(it1.next()).nearestIntersectionID;
                setupDIJ(startString);
            }
        }
    }
}

void drawWeights()
{
    for(String s:weight.keySet())
    {
        for(String t: weight.get(s).keySet())
        {
          
            float w = weight.get(s).get(t);
            if(abs(w)>0)
            {
                
                strokeWeight(maxThickness*weight.get(s).get(t)/maxWeight);
                stroke(0, maxStroke*weight.get(s).get(t)/maxWeight);
                
                
                PVector o = posns.get(s).p;
                PVector d = posns.get(t).p;
                if(o!=null && d!=null) {
                  //line(o.x, o.y, d.x, d.y);
                   if(s.equals(t))
                   {
                       ellipse(o.x, o.y, 10,10);
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




