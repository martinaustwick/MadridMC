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
               stroke(0, 150);
              for(StreetSegment sso: streetNetwork.values())
              {
                 
                  sso.display();
              }
            }
        
        
        
            
            if(showInterSections)
            {
                if(dual)
                {
                  for(Node i: dualNodes.values())
                  {
                      stroke(200, 255, 150, 75);
                      i.display();
  
                  }
                }
                else{
                  stroke(120, 255, 150, 75);
                  noFill();
                  for(Node i: intersections.values())
                  {
                      
                      i.display();
  
                  }
                }
                
//                for(DualNode d: dualNodes.values())
//                {
//                    d.show();
//                }
                
                
            }
            
            if(showFlows) drawWeights();
}
