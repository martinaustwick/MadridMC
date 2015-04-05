float maxCost = 0;

HashMap<String, HashMap<String, Route>> loadRoutes(String filename)
{
  
    //key by OD
    HashMap<String, HashMap<String, Route>> routesIn = new HashMap<String, HashMap<String, Route>>();
    Table table = loadTable(filename, "header");

    // println("Route testing");
    // println(ods.size() + " OD points");
    // println(ods.size()*ods.size() + " possible routes");
    // println(table.getRowCount() + " total rows in table"); 
  
    int i = 0;
    for (TableRow row : table.rows()) 
    {
          /*
                At this point, we're pretty bound to a specific data structure
          */
          String sod = Integer.toString(row.getInt("start_OD"));
          String eod = Integer.toString(row.getInt("end_OD"));
          String [] routeArray = split(row.getString("route_intersections"), '|');
          ArrayList<String> routeList = new ArrayList<String>(Arrays.asList(routeArray));
          
          if(!sod.equals(eod))
          {
              Route r = new Route(routeList);
              r.startOD = sod;
              r.endOD = eod;
              r.findTotalCost();
              if(routesIn.get(sod)==null)routesIn.put(sod, new HashMap<String, Route>());
              routesIn.get(sod).put(eod,r);
          }
          //if(sod.equals(testOD)) println("testOD " + sod + " " + eod + " " + r.startOD + " " + r.endOD + " " + r.intersectionIDs.size());
    }
    println("routesize " + routesIn.size());
    
    return routesIn;
}


void loadods()
{
    /*
        Load high-level (flow) graphs
        ODs = nodes
        Flows = edges
    */
  
   String [] sp = loadStrings(ODpositions);
   int IDcol = 0;
   int xcol = 1;
   int ycol = 2;
   
   int starti = 1;
   for(int i = starti; i< sp.length; i++)
   {
       //println(sp[i]);
       String [] l = split(sp[i], ",");
       float x = map(float(l[xcol]), lonmin, lonmax, 0, width);
       float y = map(float(l[ycol]), latmin, latmax, height, 0);
       
       OD od = new OD();
       od.p = new PVector(x,y);
       
       ods.put(l[IDcol], od);
   }
}


void loadFlows()
{
    int oIDcol = 0;
    int dIDcol = 1;
    int weightCol = 9;
    int starti = 1;
    
    String [] sFlows = loadStrings(ODnetwork);
    for(int i = starti; i<sFlows.length; i++)
    {
        String [] thisRow = split(sFlows[i], ",");
        //println(thisRow);
        String o = thisRow[oIDcol];
        String d = thisRow[dIDcol];
        float w = float(thisRow[weightCol]);
        
        Flow newFlow = new Flow();
        newFlow.startOD = o;
        newFlow.endOD = d;
        newFlow.weight = w;
        
        //if(w>0)println(o + " " +  d + " " + w);
        
        //ignore diagonals for the purpose of normalisations
        if(w>maxFlow && !o.equals(d)) maxFlow = w;
        if(flows.get(o)==null) flows.put(o, new HashMap<String, Flow>());
        flows.get(o).put(d, newFlow);
        
    }    
}

void loadStreets()
{
   String [] sp = loadStrings(streetFile);
   int IDcol = 2;
   int routeCol = 0;
   
   /*
       Captures cost of the street network
   */
   int costF = 32;
   int costB = 33;
   
   
   
   streetNetwork = new HashMap<String, StreetSegment>();
   
   int starti = 1;
   for(int i = starti; i< sp.length; i++)
   {
       
       String [] l = split(sp[i], ";");
//       float x = map(float(l[xcol]), lonmin, lonmax, 0, width);
//       float y = map(float(l[ycol]), latmin, latmax, height, 0);
//       ods.put(l[IDcol], new PVector(x,y));
       

        StreetSegment ss = new StreetSegment(getPointsFromCell(l[routeCol]));
        float costForward = float(l[costF]);
        float costBack = float(l[costB]);
        
        /*
            Maximum costs ("distance/time")
        */
        if(costForward>maxCost) maxCost = costForward;
        if(costBack>maxCost) maxCost = costBack;
        
        ss.costs=new PVector(costForward, costBack);
        ss.ID = l[IDcol];
        //println(ss.costs);
        streetNetwork.put(l[IDcol], ss);
   }
}

ArrayList<PVector> getPointsFromCell(String cell)
{
    ArrayList<PVector> points = new ArrayList<PVector>();
    String []  cello = split(cell,'(');
    cello = split(cello[1], ')');
    //split cleaned cell into waypoints
    String [] waypoints = split(cello[0], ',');
    for(String ps: waypoints)
    {  
        String [] psa = split(ps, ' ');
        if(psa.length==2)
        {
            points.add(new PVector(float(psa[0]), float(psa[1])));
        }
    }    
    return points;
}
