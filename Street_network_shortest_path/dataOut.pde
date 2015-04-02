void saveRoutes()
{
      for(String s1: routes.keySet())
      {
          for(String s2: routes.get(s1).keySet())
          {
              String routing = "";
              for(String routep:routes.get(s1).get(s2).intersectionIDs)
              {
                  routing += routep;
                  routing += "|";
              }
              
              TableRow newRow = dataOut.addRow();
              //newRow.setString(
              newRow.setString("start_OD", startOD);
              newRow.setString("end_OD", endOD);
              newRow.setString("start_intersection", s1);
              newRow.setString("end_intersection", s2);
              newRow.setString("route_intersections", routing);
          }
      }
    
      saveTable(dataOut, "dataOut/routing.csv");
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
