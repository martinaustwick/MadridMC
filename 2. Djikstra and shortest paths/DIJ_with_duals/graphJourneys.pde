int [] journeyLengths;

void updatejourneyLengths(ArrayList<String> path)
{
    
    float pathCost = 0;
    for(int i = 1; i<path.size(); i++)
    {  
       // println("Journey Costs: " + path.get(i-1) +"->"+
        if(dual) pathCost += dualEdges.get(path.get(i-1)).get(path.get(i)).cost;
        else pathCost += edges.get(path.get(i-1)).get(path.get(i)).cost;
    }
    //println("pathCost [minutes]" + pathCost/60);
    journeyLengths[int(constrain(pathCost/60,0,journeyLengths.length-1))]++;
}

void showJourneyLengths()
{  
   if(journeyLengths!=null)
   {
     float yHeight = 150;
     float maxN = max(journeyLengths);
     //println(maxN);
     for(int i = 0; i<journeyLengths.length;i++)
     {
         float dy = journeyLengths[i]*yHeight/maxN;
         line(4*i, yHeight, 4*i, yHeight-dy);
         
         if(i%10==0) text(i, (4*i)-2, yHeight + 15);
     }
     //println("maxN " + maxN);
   }
    
}

