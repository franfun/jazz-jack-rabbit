package net.jazz.game.map {
  public class TXMLMap extends TBaseMap {
    public function addTileset(node:XML):void {
      var nodeProps:TProperties = new TProperties(node.properties);

      nodeProps.add("tile-width", node.@tilewidth);
      nodeProps.add("tile-height", node.@tileheight);
      nodeProps.add("fgid", node.@firstgid);
      nodeProps.add("source", 
      var gt:String = nodeProps.remove("g-type") as String;
      switch(gt) {
      case "landscape":
        
        break;
      case "spritemap":
        ;
        break;
      case "images":
        break;
      default:
        
        break;
      }
    }
  }
}