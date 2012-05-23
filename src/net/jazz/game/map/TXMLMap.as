package net.jazz.game.map {
  public class TXMLMap extends TBaseMap {
    private var mLandscapeProtos:Vector.<TLandscapeProto> = new Vector.<TLandscapeProto>();
    private var mLayerCount:uint = 0;

    public function addTileset(node:XML):void {
      var nodeProps:TProperties = new TProperties(node.properties);

      nodeProps.add("name", node.@name);
      nodeProps.add("tilewidth", node.@tilewidth);
      nodeProps.add("tileheight", node.@tileheight);
      nodeProps.add("firstgid", node.@firstgid);
      nodeProps.add("source", node.image.@source);
      nodeProps.add("width", node.image.@width);
      nodeProps.add("height", node.image.@height);
      var gt:String = nodeProps.remove("g-type") as String;
      switch(gt) {
      case "landscape":
        mLandscapeProtos.push(new TLandscapeProto(nodeProps));
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

    public function addLayer(node:XML):void {
      var nodeName:String = node.name().toString();
      if(nodeName == "layer") addLandscapeLayer(node);
      else if(nodeName == "objectgroup") addObjectLayer(node);
      else throw new Error("Unknown layer kind: " + nodeName);
    }

    private function addObjectLayer(node:XML):void {
    }

    private function addLandscapeLayer(node:XML):void {
      var i:uint, j:uint;
      var p:TProperties = new TProperties(node);
      var width:uint = node.@width;
      var height:uint = node.@height;
      var layerID:uint = mLayerCount++;
      var layerType:String = p.find("type", "none");
      var isMasked:Boolean = p.find("isMasked", "no") == "yes";

      var data:Array = new Array;
      for(i = 0; i < height; ++i) data[i] = new Array;

      if(node.data.@encoding == "csv") {
        var str:String = node.data.toString();
        var lines:Array = str.split("\n", height);
        for(i = 0; i < height; ++i) {
          var vals:Array = lines.trim().split(",", width);
          for(j = 0; j < width; ++j) data[i][j] = vals[j];
        }
      } else {
      }

      // Next is going to brake if tiles come more then one tileset proto
      var k:uint = 0;
      for(i = 0; i < height; ++i) {
        for(j = 0; j < width; ++j) {
          for(; k < mLandscapeProtos.length; ++k)
            if(mLandscapeProtos[k].firstgid <= data[i][j] &&
               mLandscapeProtos[k].lastgid > data[i][j]) break;
          data[i][j] = data[i][j] - mLandscapeProtos[k].firstgid;
        }
      }

      addLandscapeLayer(
    }
  }
}

class TLandscapeProto implements IConfigurable {
  public var name:String;
  public var firstgid:uint;
  public var lastgid:uint = 0;
  public var tilewidth:Number;
  public var tileheigh:Number;
  public var width:Number;
  public var height:Number;
  public var source:String;
  public var maskSource:String = null;

  public function setProperties(p:TProperties):void {
    name = p.remove("name") as String;
    firstgid = p.remove("firstgid") as uint;
    tilewidth = p.remove("tilewidth") as Number;
    tileheight = p.remove("tileheight") as Number;
    source = p.remove("source") as String;
    width = p.remove("width") as Number;
    height = p.remove("height") as Number;
    maskSource = p.remove("maskSource") as String;
    lastgid = firstgid + Math.round(width / tilewidth) * Math.round(height / tileheigh);
  }

}
