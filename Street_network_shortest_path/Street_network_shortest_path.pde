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
String endString = "500";
String startOD, endOD;

//backwards pathfinding
boolean DIJforwardComplete = false;
ArrayList<String> path;
Iterator<String> it1,it2;
int countpaths;

//keyed by OD, not intersection
HashMap<String, HashMap<String, ArrayList<String>>> routes = new HashMap<String, HashMap<String, ArrayList<String>>>();
Table dataOut;

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
    startOD = it1.next();
    startString = posns.get(startOD).nearestIntersectionID;
    //println
    
    println(startString + " " + pathString);
    setupDIJ(startString);
    countpaths = 0;
    
    /*
        Readying for data outputs
    */
    
    dataOut = new Table();
    dataOut.addColumn("start_OD");
    dataOut.addColumn("end_OD");
    dataOut.addColumn("start_intersection");
    dataOut.addColumn("end_intersection");
    dataOut.addColumn("route_intersections");
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
    
    endOD = it2.next();
    endString = posns.get(endOD).nearestIntersectionID;
    pathString = endString;
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
    
    stroke(0);
    //noFill();
    
   
    //drawWeights();
    if(!DIJforwardComplete)
    {
        background(255);
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
    }
    
    float startTime = millis(); 
     
    
    if(!DIJforwardComplete)
    {
        //println(millis() - startTime);
        DIJforwardComplete = handij();
    }
    else   
    {
        //HashMap<String, ArrayList<String>> tracks = n
      
        float startPath = millis();
        while(!pathString.equals(startString))
        {
            path.add(pathString);
            pathString =  reverseDIJstep(pathString);
        }
        //println(millis()-startPath);
        path.add(startString);
        if(pathString.equals(startString))
        {
            Intersection bp1;
            Intersection bp2 = new Intersection();
            ArrayList<String> forwardPath = new ArrayList<String>();
            for(int i = path.size()-1; i>0; i--)
            {
                String s1 = path.get(i-1);
                String s2 = path.get(i);
                bp1 = intersections.get(s1);
                bp2 = intersections.get(s2);
                
                stroke(0);
                strokeWeight(2);
                line(bp1.p.x, bp1.p.y, bp2.p.x, bp2.p.y);
                
                forwardPath.add(s2);
            }
            forwardPath.add(startString);
            if(routes.get(startString)==null)routes.put(startString, new HashMap<String, ArrayList<String>>());
            routes.get(startString).put(endString, forwardPath);
            
            //bp1 = intersections.get(startString);
            //line(bp1.p.x, bp1.p.y, bp2.p.x, bp2.p.y);
              strokeWeight(1);
            
            if(it2.hasNext())
            {
                //pathString = posns.get(it2.next()).nearestIntersectionID;
                endOD = it2.next();
                endString = posns.get(endOD).nearestIntersectionID;
                pathString = endString;
                path = new ArrayList<String>();
                
            }
            else
            {
                dataDump();
                
                if(it1.hasNext())
                {
                    startOD = it1.next();
                    startString = posns.get(startOD).nearestIntersectionID;
                    setupDIJ(startString);
                    println("completed " +(countpaths+1) + " of " + posns.size());
                    countpaths++;
                }
                else
                {
                    noLoop();
                }
            }
        }
    }
    
    if(capture) saveFrame("images/######.jpg");
}


void dataDump()
{
      for(String s1: routes.keySet())
      {
          for(String s2: routes.get(s1).keySet())
          {
              String routing = "";
              for(String routep:routes.get(s1).get(s2))
              {
                  routing += routep;
                  routing += "|";
              }
              
              TableRow newRow = dataOut.addRow();
              //newRow.setString(
              newRow.setString("start_OD", startOD);
              newRow.setString("end_OD", endOD);
              newRow.setString("start_intersection", s1);
              newRow.setString("end_intersection", s2);
              newRow.setString("route_intersections", routing);
          }
      }
    
      saveTable(dataOut, "dataOut/routing.csv");
}

//void intersectionData()
//{
//    Table interTable = new Table();
//    interTable.addColumn("ID");
//    interTable.addColumn("x");
//    interTable.addColumn("y");
//    interTable.addColumn("destinations");
//    for(String s: intersections.keySet())
//    {
//        
//    }
//
//}

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




