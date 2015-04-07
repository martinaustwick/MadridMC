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

float streetAlpha = 30;

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
    
    //testAgent();
    agents =  new ArrayList<Agent>();
    //drawLoadedSegments();
    
    background(255);
    frameRate(120);
}

void draw()
{
    noStroke();
    fill(255,100);
    rect(width/2,height/2,width, height);
    
    stroke(0);
    if(loadRoutes)
    {
        //background(255);
        //drawEdges();
        //drawLoadedSegments();
        
        //drawBadUns();
        //noLoop();
        //evenProb();
        gaussProb();
    }
    else
    {
        DIJloop();
    }
    
    if(capture) saveFrame("images/######.jpg");
    displayAgents(agents);
    
    drawGraph();
    drawClock();
    if(capture) saveFrame("images/" + clock + ".jpg");
    clock+=increment;
}

void drawClock()
{  
//    fill(255);
//    rect(50, height-20, 100, 40);
    fill(0);
    text(int(clock/1000), 30, height - 20);
}

float prob = 1.0;
float sd =    100000;
float mean = 3*sd;

float [] gauss;
    
void drawGraph()
{
    int thick = 1;
    
    int yheight = 50;
    
    float maxTime = 5000000;
    
    if(gauss==null)
    {
        gauss = new float [width/thick];
        for(int i = 0; i<gauss.length; i++)
        {
            float x = map(i, 0, gauss.length, 0, maxTime);
            float xbar = (x-mean)/sd; 
            gauss[i] = yheight*exp(-0.5*xbar*xbar);
        }
    }
    
    fill(255);
    rect(width/2, height-0.5*yheight, width, yheight);
    
    stroke(0);
    strokeWeight(1);
    for(int i = 1; i<gauss.length; i++)
    {
      line((i-1)*thick, height-gauss[i-1], i*thick, height-gauss[i]);   
    }
    
    float x = map(clock, 0, maxTime, 0, width);
    line(x, height, x, height-yheight);  
}


