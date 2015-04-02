import java.util.*;

/*
    High-level graph: OD/flows
*/
HashMap<String, OD> ods = new HashMap<String, OD> ();
HashMap<String, HashMap<String, Float>> flows;

HashMap<String, StreetSegment> streetNetwork;

HashMap<String, Intersection> intersections;
HashMap<String, HashMap<String, Edge>> edges;

//OD graph
String network = "MatrixOD_Flow.csv";
String positions = "nodes.csv";

//intersection graph
String intersectionFile = "intersections.csv";
String intersectionEdgeFile = "edges.csv";

//street graph
String streetFile = "Street Network with pseudotimes.csv";


/*
    Output files
*/

String intersectionsOut = "intersections.csv";
String edgesOut = "edges.csv";

float maxFlow = 0;
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

int h = 1080;

String startString = "1";
String pathString = "500";
String endString = "500";
String startOD, endOD;

//backwards pathfinding
boolean DIJforwardComplete = false;
boolean allPathsFound = false;
boolean showPathfinding = false;
ArrayList<String> path;
Iterator<String> it1,it2;
int countpaths;

//keyed by OD, not intersection
HashMap<String, HashMap<String, Route>> routes = new HashMap<String, HashMap<String, Route>>();
Table dataOut;

void setup()
{
    
    
    float dlat = (latmax-latmin);
    float dlon =  (lonmax-lonmin);
    
    size(int((h*dlon)/dlat), h);
    println(width + " " + height);
    
    loadods();
    
    loadStreets();
    
    //intersections = createIntersections(streetNetwork);
    createGraph(streetNetwork);
    for(OD od:ods.values())
    {
        od.findNearestIntersection(intersections);
    }
    
    
    
    flows = new HashMap<String, HashMap<String, Float>>();
    //makeUpflowss();
    loadWeight();
    
    rectMode(CENTER);
    colorMode(HSB);
    



    /*
         Iterate through OD subset of intersections
     */
    
    it1 = ods.keySet().iterator();
    startOD = it1.next();
    startString = ods.get(startOD).nearestIntersectionID;
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
    saveIntersections();
    saveEdges();
    
    wList = new ArrayList<String>();
    wList.add(originID);
    //doneList = new ArrayList<String>();
    intersections.get(originID).d = 0;
    
    path =  new ArrayList<String>();
    it2 = ods.keySet().iterator();
    
    endOD = it2.next();
    endString = ods.get(endOD).nearestIntersectionID;
    pathString = endString;
    DIJforwardComplete = false;
    //pathString = ods.get(it2.next()).nearestIntersectionID;
    frameRate(4000);
}



void draw()
{
    
    stroke(0);
    //println("framerate " + frameRate);
   
    //drawWeights();
    if(!DIJforwardComplete)
    {
        if(showPathfinding)
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
            showDIJ(); 
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
            
            stroke(0);
            strokeWeight(2);
            for(int i = path.size()-1; i>0; i--)
            {
                String s1 = path.get(i-1);
                String s2 = path.get(i);
                
                
                if(showPathfinding)
                {
                    
                    
                    bp1 = intersections.get(s1);
                    bp2 = intersections.get(s2);
                    line(bp1.p.x, bp1.p.y, bp2.p.x, bp2.p.y);
                }
                
                forwardPath.add(s2);
            }
            forwardPath.add(startString);
            if(routes.get(startString)==null) routes.put(startString, new HashMap<String, Route>());            
            routes.get(startString).put(endString, new Route(forwardPath));
            strokeWeight(1);
            
            if(it2.hasNext())
            {
                //pathString = ods.get(it2.next()).nearestIntersectionID;
                endOD = it2.next();
                endString = ods.get(endOD).nearestIntersectionID;
                pathString = endString;
                path = new ArrayList<String>();
                
            }
            else
            {
                saveRoutes();
                
                println("framerate " + frameRate);
                background(255);
                showDIJ(); 
                
                if(it1.hasNext())
                {
                    startOD = it1.next();
                    startString = ods.get(startOD).nearestIntersectionID;
                    setupDIJ(startString);
                    println("completed " +(countpaths+1) + " of " + ods.size());
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
