void showgraphs()
{
            if(showOD)
            {
              for(OD od: ods.values())
              {    
                 stroke(0,255,150);
                 od.display();
              }
            }
            
            if(showStreets)
            {
              for(StreetSegment sso: streetNetwork.values())
              {
                  sso.display();
              }
            }
        
        
        
            
            if(showInterSections)
            {
                for(Intersection i: intersections.values())
                {
                    stroke(120, 255, 50, 100);
                    i.display();
                    
//                    for(String s: i.destinations)
//                    {
//                        PVector p = intersections.get(s).p;
//                        line(p.x, p.y, i.p.x, i.p.y);
//                    }
                }
                
//                for(DualNode d: dualNodes.values())
//                {
//                    d.show();
//                }
                
                
            }
}
