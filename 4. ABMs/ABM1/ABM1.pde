import java.util.*;

/*
    High-level graph: OD/flows[weight]
*/
String ODnetwork = "MatrixOD_Flow.csv";
String ODpositions = "nodes.csv";
HashMap<String, OD> ods = new HashMap<String, OD> ();
HashMap<String, HashMap<String, Flow>> flows;

//route graph: IDed by intersection?
String routeFile = "MadridRouting.csv";
HashMap<String, HashMap<String, Route>> routes = new HashMap<String, HashMap<String, Route>>();

/*
  Mid-level: intersections/edges[costs]
*/
String intersectionFile = "intersections.csv";
String intersectionEdgeFile = "edges.csv";
HashMap<String, Intersection> intersections;
HashMap<String, HashMap<String, Edge>> edges;

/*
    Low-level: segments
*/
String streetFile = "Street Network with pseudotimes.csv";
HashMap<String, StreetSegment> streetNetwork;

/*
    Output files
*/

String intersectionsOut = "intersections.csv";
String edgesOut = "edges.csv";

float maxFlow = 0;
float maxStroke = 30;
float curviness = 0.0;
float maxThickness = 10;

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

/*
      BASICALLY the flag as to whether you
      generate shortest paths from Djikstra's
      or load data from a file
*/
boolean loadRoutes = true;

ArrayList<String> path;
Iterator<String> it1,it2;
int countpaths;

Table dataOut;

/*
      Timing and clocking
*/

float clock;
float increment = 1000;

void setup()
{   
    float dlat = (latmax-latmin);
    float dlon =  (lonmax-lonmin);
    
    size(int((h*dlon)/dlat), h);
    println(width + " " + height);
    
    loadods();    
    loadStreets();    
    createGraph(streetNetwork);
    for(OD od:ods.values())
    {
        od.findNearestIntersection(intersections);
    }
    
    
    
    flows = new HashMap<String, HashMap<String, Flow>>();
    //makeUpflowss();
    loadFlows();
    
    
    rectMode(CENTER);
    colorMode(HSB);
    //load or find
    routePrep();
    if(loadRoutes) weightEdges();
    println("edge laoding dun");
    
    clock = 0;
    
    testAgent();
    drawLoadedSegments();
}

void draw()
{
    
    stroke(0);
    if(loadRoutes)
    {
        //background(255);
        //drawEdges();
        //drawLoadedSegments();
        
        //drawBadUns();
        //noLoop();
    }
    else
    {
        DIJloop();
    }
    
    if(capture) saveFrame("images/######.jpg");
    displayAgents(agents);
    
    clock+=increment;
}
