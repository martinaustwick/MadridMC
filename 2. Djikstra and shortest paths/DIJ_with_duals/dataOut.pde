ArrayList<String> routesOut = new ArrayList<String>();

void updateRoutes()
{

  FileWriter outy;

  try
  {

    if(dual) outy = new FileWriter(sketchPath("")+"dataOut/routesDual.csv", true);
    else outy = new FileWriter(sketchPath("")+"dataOut/" + routesOutString, true);

    String s1 = startOD;
    String endIntersection = "";
    
    for (String s2 : routes.get (s1).keySet())
    {
      String routing = "";
      //                String startIntersection = routes.get(s1).get(s2).intersectionIDs.get(0);
      //                String endIntersection = routes.get(s1).get(s2).intersectionIDs.get(0);
      
      
      for (int i = 0; i<routes.get(s1).get(s2).intersectionIDs.size(); i++)
      {
        String routep = routes.get(s1).get(s2).intersectionIDs.get(i);
        routing += routep;
        
        if(i<(routes.get(s1).get(s2).intersectionIDs.size()-1))
        {
            routing += "|";
        }
        else
        {
            endIntersection = routep;
        }
      }
      //println("s1s2 " + s1+" "+s2 + " " + routesOutString);

      String line = s1 + ",";
      line += s2 + ",";
      line += startString + ",";
      line += endIntersection + ",";
      line += routing;
      line +="\r\n";
      outy.append(line);
      outy.flush();

    }
    outy.close();
    outy=null;
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
}


void saveNodes(HashMap<String, Node> nodes)
{
  Table interTable = new Table();
  interTable.addColumn("ID");
  interTable.addColumn("x");
  interTable.addColumn("y");
  //interTable.addColumn("destinations");
  for (String s : nodes.keySet ())
  {
    TableRow newRow = interTable.addRow();
    newRow.setString("ID", s);
    Node i = nodes.get(s);
    newRow.setFloat("x", i.p.x);
    newRow.setFloat("y", i.p.y);
  }
  
  if(!dual) saveTable(interTable, "dataOut/" +intersectionsOut);
  else saveTable(interTable, "dataOut/dualNodes.csv");
}

void saveEdges(HashMap<String,HashMap<String, Edge>> edgesMapOut)
{
  Table edgeTable = new Table();
  edgeTable.addColumn("startIntersectionID");
  edgeTable.addColumn("endIntersectionID");
  edgeTable.addColumn("cost");
  edgeTable.addColumn("time");

  for (String sid : edgesMapOut.keySet ())
  {
    for (String eid : edgesMapOut.get (sid).keySet())
    {
      TableRow newRow = edgeTable.addRow();
      newRow.setString("startIntersectionID", sid);
      newRow.setString("endIntersectionID", eid);

      Edge e = edgesMapOut.get(sid).get(eid);
      newRow.setFloat("cost", e.cost);
      newRow.setFloat("time", e.time);
    }
  }

  if(dual) saveTable(edgeTable, "dataOut/dualEdges.csv");
  else saveTable(edgeTable, "dataOut/" + edgesOut);
}

