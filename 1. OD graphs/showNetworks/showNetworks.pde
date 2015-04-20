import java.util.*;
import java.io.*;

/*
    High-level graph: OD/flows
*/
HashMap<String, OD> ods = new HashMap<String, OD> ();
HashMap<String, HashMap<String, Float>> flows;



//OD graph
String network = "MatrixOD_Flow.csv";
String positions = "nodes.csv";

//intersection graph
String intersectionFile = "intersections.csv";
String intersectionEdgeFile = "edges.csv";
HashMap<String, Intersection> intersections;
HashMap<String, HashMap<String, Edge>> edges;

//dual graph

HashMap<String, DualNode> dualNodes;
HashMap<String, HashMap<String, DualEdge>> dualEdges;

//street graph
String streetFile = "Street Network with pseudotimes.csv";
HashMap<String, StreetSegment> streetNetwork;


/*
    Output files
*/

String intersectionsOut = "intersections.csv";
String edgesOut = "edges.csv";
String routesOutString = "routes.csv";

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
//Table dataOut;
int routeCounter = 0;

void setup()
{
    routesOutString = int(random(10000)) + routesOutString;
    PrintWriter output = createWriter("dataOut/" + routesOutString); 
    output.println("start_OD,end_OD,start_intersection,end_intersection,route_intersections");
    output.flush();
    output.close();
    
    float dlat = (latmax-latmin);
    float dlon =  (lonmax-lonmin);
    
    size(int((h*dlon)/dlat), h);
    println(width + " " + height);
    
    loadods();
    
    loadStreets();
    
    //intersections = createIntersections(streetNetwork);
    createGraph(streetNetwork);
    //createDualFromSegments();
    
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
    background(255);
 
}

float clock = 0;
void setupDIJ(String originID)
{
    clock = millis();
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
    
    background(255);
}



void draw()
{
    //background fade
    noStroke();  
    fill(255,50);
    rect(width/2, height/2, width, height);
  
    stroke(0,50);
    //println("framerate " + frameRate);
   
    //drawWeights();
    if(!DIJforwardComplete)
    {
        showgraphs();
           
    }
    
    float startTime = millis(); 
     
    
    if(!DIJforwardComplete)
    {
        //println(millis() - startTime);
        //DIJforwardComplete = handij();
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
          
            /*
                We know that the backwards pathfinding is complete
                when we get to the first (origin) intersection
            */
            
            Intersection bp1;
            Intersection bp2 = new Intersection();
            
            /*
                ForwardPath is the object that will be saved into the HashMap, and thence the table
            */
            ArrayList<String> forwardPath = new ArrayList<String>();
            
            stroke(0);
            strokeWeight(2);
            //forwardPath.add(startString);
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
            forwardPath.add(endString);
            //forwardPath.add(startString);
            
            /*
                KEY BY OD
            */
            
            if(routes.get(startOD)==null) routes.put(startOD, new HashMap<String, Route>());            
            routes.get(startOD).put(endOD, new Route(forwardPath));
            strokeWeight(1);
            
            if(it2.hasNext())
            {
                //pathString = ods.get(it2.next()).nearestIntersectionID;
                endOD = it2.next();
                endString = ods.get(endOD).nearestIntersectionID;
                //println(endOD + " " + endString);
                pathString = endString;
                path = new ArrayList<String>();
                
            }
            else
            {
                updateRoutes();
                //updateRouteOut();
                println("framerate " + frameRate);
                background(255);
                showDIJ(); 
                
                if(it1.hasNext())
                {
                    startOD = it1.next();
                    startString = ods.get(startOD).nearestIntersectionID;
                    setupDIJ(startString);
                    println("completed " +(countpaths+1) + " of " + ods.size() + " time taken: " + (millis()-clock) + "ms; estimated time remaining " + ((millis()-clock)*(ods.size() - countpaths + 1)/1000.0) + "s" );
                    countpaths++;
                }
                else
                {
                    noLoop();
                    //saveRoutes();
                }
            }
        }
    }
    
    if(capture) saveFrame("images/######.jpg");
}

void exit()
{
    //saveRoutes();
}
