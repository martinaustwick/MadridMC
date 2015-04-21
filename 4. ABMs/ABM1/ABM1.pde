import java.util.*;
/*
    Time-release profile
*/
float sd = 10;
float increment = 5;
float bgOpacity = 200;
float pointOpacity = 20;
float areaOpacity = 1;

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

//int h = 930;
int h = 500;

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



void setup()
{   
    float dlat = (latmax-latmin);
    float dlon =  (lonmax-lonmin);
    
    size(int(h*dlon/dlat), h+yheight);
    smooth();
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
    agents =  new ArrayList<Agent>();
    //testAgent();
    
    //drawLoadedSegments();
    
    background(255);
    frameRate(120);
}

void draw()
{
    noStroke();
    fill(255, bgOpacity);
    rect(width/2,height/2,width, height);
    
    stroke(0);
    if(loadRoutes)
    {
        //background(255);
        //drawEdges();
        //if(frameCount==1)drawLoadedSegments();
        
        //drawBadUns();
        //noLoop();
        //evenProb();
        gaussProb();
    }
    else
    {
        DIJloop();
    }
    
    displayAgents(agents);
    
    drawGraph();
    pushMatrix();
      translate(50, 15);
      drawClock();
    popMatrix();
    //drawInfo();
    //if(capture) saveFrame("images/#######.jpg");
    if(capture) saveFrame("images/#######.jpg");
    clock+=increment;
    if(clock>maxTime)exit();
}

void drawInfo()
{
    fill(255);
    noStroke();
    rect(100, 100, 200, 200);
    fill(0);
    text("SD :" + int(sd/1000) + "k", 10, 30);
}

//void drawClock()
//{  
////    fill(255);
////    rect(50, height-20, 100, 40);
//    fill(0);
//    text(int(clock/1000), 30, height - 20);
//}

float prob = 1.0;
float mean = 3*sd;

float [] gauss;
int [] agentNum;
    
int yheight = 150;
float maxTime = 6*sd + 3600;
//float maxTime = 8*sd;

void drawGraph()
{
    int thick = 1;
    
    
    
    
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
    
    
   
    noStroke();
    fill(255);
    rect(width/2, height-0.5*yheight, width, yheight+20);
    
    strokeWeight(1);
    stroke(0,255,100);
    for(int i = 1; i<gauss.length; i++)
    {
      line((i-1)*thick, height-gauss[i-1], i*thick, height-gauss[i]);   
    }
    
    
    int sampleRate = int(sd/10);
    if(agentNum==null) agentNum = new int [int(maxTime/sampleRate)];
    if(clock%sampleRate==0 && int(clock/sampleRate)<agentNum.length) agentNum[int(clock/sampleRate)] = agents.size();
    stroke(150, 255, 100, 100);
    for(int i = 0; i<agentNum.length; i++)
    {
        float x = map(i, 0, agentNum.length, 0, width);
        float y = map(agentNum[i], 0, max(agentNum), height, height-yheight);
        line(x, height, x,y);
      //line((i-1)*thick, height-gauss[i-1], i*thick, height-gauss[i]);   
    }
    fill(150, 255, 100);
  
    text(max(agentNum), map(clock, 0, maxTime, 0, width)+13, height-yheight);
    line(map(clock, 0, maxTime, 0, width)-10, height-yheight, map(clock, 0, maxTime, 0, width)+10,height-yheight);
    
    float labelHeight = map(agents.size(), 0, max(agentNum), height, height-yheight);
    if(labelHeight>(height-yheight+22))
    {
        text(agents.size(), map(clock, 0, maxTime, 0, width)+12, labelHeight);
        line(map(clock, 0, maxTime, 0, width)-10,  labelHeight, map(clock, 0, maxTime, 0, width)+10, labelHeight);
    }
    
    stroke(0);
    float x = map(clock, 0, maxTime, 0, width);
    line(x, height, x, height-yheight);  
    
    fill(0);
    text(int(clock/1000), width-50, height + 10 -0.5*yheight);
}

void drawClock()
{
    fill(255);
    rect(0,0,90,20);
    fill(0);
    int hours = int((clock-mean)/3600);
    int mins = int((clock-mean)/60)%60;
    int seconds = int(clock-mean+36000)%60;
    text(nf(hours,2,0) +":" + nf(mins,2,0) +":"+nf(seconds,2,0), -30, 7);
    
}

