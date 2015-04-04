/*
    Max weight on an edge between intersections
 */
float maxEdgeWeight = 0;
String testOD = "239";

void weightEdges()
{

  for (String sod : flows.keySet ())
  {
    for (String eod : flows.get (sod).keySet())
    {
      Flow flow = flows.get(sod).get(eod);
      if (flow.weight>0)
      {
        Route r = routes.get(sod).get(eod);
        if (r!=null)
        {
          for (int i = 1; i<r.intersectionIDs.size (); i++)
          {
            String is1 = r.intersectionIDs.get(i-1);
            String is2 = r.intersectionIDs.get(i);
            if (edges.get(is1).get(is2)!=null) 
            {
              edges.get(is1).get(is2).weight+=flow.weight;
              //println(edges.get(is1).get(is2).weight);
              if (maxEdgeWeight<edges.get(is1).get(is2).weight &&!is1.equals(is2)) maxEdgeWeight = edges.get(is1).get(is2).weight;
            }
            //else println("Non edges /" + is1 + "/ /" + is2 + "/");
          }
        }
      }
    }
  }

  /*
        Test 
   */
  // println("testrun");
  // for(Route r:routes.get(testOD).values())
  // {
  //     println(r.startOD + " " + r.endOD);
  // }
}

void drawEdges()
{
  println("drawedges");
  for (String i1 : edges.keySet ())
  {
    for (String i2 : edges.get (i1).keySet())
    {

      //println(i1 + " " + i2);
      PVector p1 = intersections.get(i1).p;
      PVector p2 = intersections.get(i2).p;

      //if(edges.get(i1).get(i2).weight>1)println(edges.get(i1).get(i2).weight);
      float liner = edges.get(i1).get(i2).weight/maxEdgeWeight;
      //if(liner>0.99) println(liner);
      strokeWeight(10*liner);
      stroke(0);
      line(p1.x, p1.y, p2.x, p2.y);
    }
  }
  println("maxEdgeWeigh " + maxEdgeWeight);
}

void drawLoadedSegments()
{
  stroke(0,125);
  noFill();
  println("Draw Segments");
  //strokeWeight(3);
  for (StreetSegment sso : streetNetwork.values ())
  {
    String i1 = sso.startIntersection;
    String i2 = sso.endIntersection;

    if (i1!=null && i2!=null)
    {
      /*
                colour by orientation
       */

//      PVector p1 = intersections.get(i1).p;
//      PVector p2 = intersections.get(i2).p;
//
//      float hue = 255*(PVector.sub(p2, p1).heading() + PI)/PI;
      //println(PVector.sub(p2, p1).heading());
//      color c1 = color(hue, 255, 120);
//      color c2 = color((hue+128)%255, 255, 120);
      
      //println(i1 + " " + i2);
      if (!(edges.get(i1).get(i2)==null))
      {  

        float liner = edges.get(i1).get(i2).weight/maxEdgeWeight;
        //stroke(0, 255, 100, 125);
        //stroke(c1);
        strokeWeight(maxThickness*liner);
        sso.displayForward();
      }

      if (edges.get(i2).get(i1)!=null)
      {  
        float liner = edges.get(i2).get(i1).weight/maxEdgeWeight;
        //stroke(125, 255, 100, 125);
        //stroke(c2);
        strokeWeight(maxThickness*liner);
        sso.displayBack();
      }
    }
  }
  
  
  //drawWheel(new PVector(100, height-100));
}

void drawWheel(PVector centre)
{
    strokeWeight(6);
    pushMatrix();
    translate(centre.x, centre.y);
    //rotate(PI);
    for(int i = 0; i<256; i++)
    {
        stroke(i,255,125,120);
        line(0,0,0,-95);
        rotate(TWO_PI/255);
    }
}
