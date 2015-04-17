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
HashMap<String, Node> intersections;
HashMap<String, HashMap<String, Edge>> edges;

//dual graph

HashMap<String, Node> dualNodes;
HashMap<String, HashMap<String, Edge>> dualEdges;

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

int h = 720;

String startString = "1";
String pathString = "500";
String endString = "500";
String startOD, endOD;

//backwards pathfinding
boolean DIJforwardComplete = false;
boolean allPathsFound = false;
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
    PrintWriter output; 
    if(dual){
      output = createWriter("dataOut/routesDual.csv"); 
      output.println("start_OD,end_OD,start_node,end_node,route_nodes");
    }
    else 
    {
      output = createWriter("dataOut/" + routesOutString); 
      output.println("start_OD,end_OD,start_node,end_node,route_nodes");
    }
    output.flush();
    output.close();
    
    float dlat = (latmax-latmin);
    float dlon =  (lonmax-lonmin);
    
    size(int((h*dlon)/dlat), h);
    println(width + " " + height);
    
    loadods();
    
    loadStreets();
    
    /*
        Create Primary and Dual Graph
    */
    createGraph(streetNetwork);
    createDualFromSegments();
    
    for(OD od:ods.values())
    {
        od.findNearestIntersection(intersections);
        od.findNearestDualNode(dualNodes);
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
    
    
    if(dual) {
      startString = ods.get(startOD).nearestDualNodeID;
      dualNodes.get(startString).isOD = true;
    }
    else 
    {
      startString = ods.get(startOD).nearestIntersectionID;
      intersections.get(startString).isOD = true;
    }
    //println
    
    println(startString + " " + pathString);
    
    if(dual) setupDIJ(startString, dualNodes);
    else setupDIJ(startString, intersections);
    
    countpaths = 0;
    
 
}

float clock = 0;




void draw()
{
    
    //stroke(0);
    //println("framerate " + frameRate);
   
    //drawWeights();
    if(!DIJforwardComplete)
    {
        if(showPathfinding)
        {
            background(255);
            if(showStreets)
            {
              stroke(0, 50);
              for(StreetSegment sso: streetNetwork.values())
              {
                  sso.display();
              }
              noStroke();
            }
            
            //stroke(0);
            if(dual) showDIJ(dualNodes); 
            else showDIJ(intersections);
        }
    }
    
    float startTime = millis(); 
     
    
    if(!DIJforwardComplete)
    {
        //println(millis() - startTime);
        if(dual) DIJforwardComplete = handij(dualNodes, dualEdges);
        else DIJforwardComplete = handij(intersections, edges);
        
//        if(DIJforwardComplete) println("completed forward");
//        else println("Not forwarded " + frameCount);
    }
    else   
    {
        
        float startPath = millis();
        while(!pathString.equals(startString))
        {
            /*
                until the path has worked back to the origin
            */
            path.add(pathString);
            if(dual) pathString =  reverseDIJstep(pathString, dualNodes);
            else pathString =  reverseDIJstep(pathString, intersections);
            println("oathing");
        }
        //println(millis()-startPath);
        path.add(startString);
        if(pathString.equals(startString))
        {
          
            /*
                We know that the backwards pathfinding is complete
                when we get to the first (origin) intersection
            */
            
            Node bp1;
            Node bp2 = new Node();
            
            /*
                ForwardPath is the object that will be saved into the HashMap, and thence to file
            */
            ArrayList<String> forwardPath = new ArrayList<String>();
            
            strokeWeight(2);
            for(int i = path.size()-1; i>0; i--)
            {
                String s1 = path.get(i-1);
                String s2 = path.get(i);
                
                
                if(showPathfinding)
                {
                    stroke(0, 150);
                    if(dual) bp1 = dualNodes.get(s1);
                    else bp1 = intersections.get(s1);
                   if(dual) bp2 = dualNodes.get(s2);
                   else bp2 = intersections.get(s2);
                    
                    
                    line(bp1.p.x, bp1.p.y, bp2.p.x, bp2.p.y);
                    //println("pathy");
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
                if(dual) endString = ods.get(endOD).nearestDualNodeID;
                else endString = ods.get(endOD).nearestIntersectionID;

                pathString = endString;
                path = new ArrayList<String>();
                
            }
            else
            {
                updateRoutes();
                //updateRouteOut();
                println("framerate " + frameRate);
                background(255);
                //showDIJ(); 
                
                if(it1.hasNext())
                {
                    startOD = it1.next();
                    startString = ods.get(startOD).nearestIntersectionID;
                    
                    if(dual) setupDIJ(startString, dualNodes);
                    else setupDIJ(startString, intersections);
                    
                    println("completed " +(countpaths+1) + " of " + ods.size() + " time taken: " + (millis()-clock) + "ms; estimated time remaining " + ((millis()-clock)*(ods.size() - countpaths + 1)/1000.0) + "s" );
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


