

void loadPosns()
{
   String [] sp = loadStrings(positions);
   int IDcol = 0;
   int xcol = 1;
   int ycol = 2;
   
   int starti = 1;
   for(int i = starti; i< sp.length; i++)
   {
       println(sp[i]);
       String [] l = split(sp[i], ",");
       float x = map(float(l[xcol]), lonmin, lonmax, 0, width);
       float y = map(float(l[ycol]), latmin, latmax, height, 0);
       posns.put(l[IDcol], new PVector(x,y));
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
        if(w>maxWeight) maxWeight = w;
        if(weight.get(o)==null) weight.put(o, new HashMap<String, Float>());
        weight.get(o).put(d, w*10);
    }
    
}

