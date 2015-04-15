//void setupDualDIJ(String originID)
//{
//    clock = millis();
//    for(DualNode i: intersections.values())
//    {
//          i.seen = false;
//          i.d = 99999999;
//    }
//    saveIntersections();
//    saveEdges();
//    
//    wList = new ArrayList<String>();
//    wList.add(originID);
//    //doneList = new ArrayList<String>();
//    intersections.get(originID).d = 0;
//    
//    path =  new ArrayList<String>();
//    it2 = ods.keySet().iterator();
//    
//    endOD = it2.next();
//    endString = ods.get(endOD).nearestIntersectionID;
//    pathString = endString;
//    DIJforwardComplete = false;
//    //pathString = ods.get(it2.next()).nearestIntersectionID;
//    frameRate(4000);
//}
