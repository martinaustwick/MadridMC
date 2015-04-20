float maxCost = 0;


void loadods()
{
    /*
        Load high-level (flow) graphs
        ODs = nodes
        Flows = edges
    */
  
   String [] sp = loadStrings(positions);
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


void loadWeight()
{
    int oIDcol = 0;
    int dIDcol = 1;
    int weightCol = 9;
    int starti = 1;
    
    String [] sFlows = loadStrings(network);
    for(int i = starti; i<sFlows.length; i++)
    {
        String [] thisRow = split(sFlows[i], ",");
        //println(thisRow);
        String o = thisRow[oIDcol];
        String d = thisRow[dIDcol];
        float w = float(thisRow[weightCol]);
        //ignore diagonals for the purpose of normalisations
        if(w>maxFlow) maxFlow = w;
        if(flows.get(o)==null) flows.put(o, new HashMap<String, Float>());
        flows.get(o).put(d, w*10);
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
        if(!ss.ID.equals(l[IDcol]))println(l[IDcol]);
   }
   println("streets loaded");
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
