ArrayList<String> routesOut = new ArrayList<String>();
void updateRouteOut()
{
    
        for(String s1: routes.keySet())
        {
            for(String s2: routes.get(s1).keySet())
            {
                String routing = "";
                String startIntersection = routes.get(s1).get(s2).intersectionIDs.get(0);
                String endIntersection = routes.get(s1).get(s2).intersectionIDs.get(0);
                for(String routep:routes.get(s1).get(s2).intersectionIDs)
                {
                    routing += routep;
                    routing += "|";
                    
                    endIntersection = routep;
                }
                
                
                
                String line = s1 + ",";
                line += s2 + ",";
                line += startIntersection + ",";
                line += endIntersection + ",";
                line += routing;
                //line +="\r\n";
                routesOut.add(line);
            }
        }
        println(routesOut.size() + " routes, " + (1+countpaths)*ods.size() + " expected");

}


void saveRoutes()
{
    PrintWriter pw = createWriter("dataOut/" + routesOutString);
    pw.println("start_OD, endO_D, start_Intersection, end_Intersection, route_Intersections");
    for(String s: routesOut)
    {  
        pw.println(s);
    }
    pw.flush();
    pw.close();
}

void updateRoutes()
{
   
    FileWriter outy;
    
    try
    {
      
        //outy = new BufferedWriter(new FileWriter(sketchPath("")+"dataOut/" + routesOut, true));
        outy = new FileWriter(sketchPath("")+"dataOut/" + routesOutString, true);
        
//        for(String s1: routes.keySet())
//        {
          String s1 = startOD;
            for(String s2: routes.get(s1).keySet())
            {
                String routing = "";
                String startIntersection = routes.get(s1).get(s2).intersectionIDs.get(0);
                String endIntersection = routes.get(s1).get(s2).intersectionIDs.get(0);
                for(String routep:routes.get(s1).get(s2).intersectionIDs)
                {
                    routing += routep;
                    routing += "|";
                    
                    endIntersection = routep;
                }
                //println("s1s2 " + s1+" "+s2 + " " + routesOutString);
                
                String line = s1 + ",";
                line += s2 + ",";
                line += startIntersection + ",";
                line += endIntersection + ",";
                line += routing;
                line +="\r\n";
                outy.append(line);
                outy.flush();
                
                //outy = null;
                
                //output.println("start_OD, endO_D, start_Intersection, end_Intersection, route_Intersections");
                // output.println(line);
                // output.flush();
            }
        //}
        outy.close();
        outy=null;
        
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    

}


void saveIntersections()
{
    Table interTable = new Table();
    interTable.addColumn("ID");
    interTable.addColumn("x");
    interTable.addColumn("y");
    //interTable.addColumn("destinations");
    for(String s: intersections.keySet())
    {
        TableRow newRow = interTable.addRow();
        newRow.setString("ID", s);
        Intersection i = intersections.get(s);
        newRow.setFloat("x", i.p.x);
        newRow.setFloat("y", i.p.y);
    }
    saveTable(interTable, "dataOut/" +intersectionsOut);
}

void saveEdges()
{
    Table edgeTable = new Table();
    edgeTable.addColumn("startIntersectionID");
    edgeTable.addColumn("endIntersectionID");
    edgeTable.addColumn("cost");
    edgeTable.addColumn("time");
    
    for(String sid: edges.keySet())
    {
        for(String eid: edges.get(sid).keySet())
        {
              TableRow newRow = edgeTable.addRow();
              newRow.setString("startIntersectionID", sid);
              newRow.setString("endIntersectionID", eid);
              
              Edge e = edges.get(sid).get(eid);
              newRow.setFloat("cost", e.cost);
              newRow.setFloat("time", e.time);
        }
    }
    
    saveTable(edgeTable, "dataOut/" + edgesOut);
}
