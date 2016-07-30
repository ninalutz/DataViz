void drawNetwork(ArrayList<Edge> lines){
 for(int i = 0; i<lines.size(); i++){
         lines.get(i).drawEdge();
    }
}

void drawNodes(){
     for(int i = 0; i<OD.size(); i++){
        OD.get(i).drawNodes();
   }
   for(int i = 0; i<Network.size(); i++){
        Network.get(i).drawNetworkNodes();
   }

}