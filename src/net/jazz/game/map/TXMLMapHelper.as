package net.jazz.game.map {
  import net.jazz.game.data.TProperties;
  import net.jazz.game.core.TGraphic;
  import net.jazz.game.core.graphic.TTileset;

  public class TXMLMapHelper {
    protected var mGs:Vector.<TG> = new Vector.<TG>();
    private var mLayerCount:uint = 0;

    public function addTileset(node:XML):void {
      var nodeProps:TProperties = new TProperties(node.properties ? node.properties[0] : null);

      nodeProps.fromAttributes(node);
      nodeProps.fromAttributes(node.image[0]);
      var gt:String = nodeProps.remove("g-type") as String;
      switch(gt) {
      case "landscape":
        var t:TTileset = new TTileset(nodeProps);
        mGs.push(new TG(uint(nodeProps.remove("firstgid")), t));
        break;
      case "spritemap":
        throw new Error("Spritemap not yet Parsable");
        break;
      case "images":
        throw new Error("Images not yet Parsable");
        break;
      default:
        throw new Error("Unknown tileset type " + gt);
        break;
      }
    }

    private function parseObjectLayer(node:XML):void {
      throw new Error("Object layers are not parsable yet.");
    }

    public function parseLandscapeLayer(node:XML):TLandscape {
      var i:uint, j:uint;
      var p:TProperties = new TProperties(node.properties ? node.properties[0] : null);
      p.fromAttributes(node);
      var width:uint = uint(p.find("width"));
      var height:uint = uint(p.find("height"));
      var layerID:uint = mLayerCount++;
      var layerType:String = p.find("type", "") as String;
      var isMasked:Boolean = p.find("isMasked", "no") == "yes";

      var data:Array = new Array;
      for(i = 0; i < height; ++i) data[i] = new Array;

      if(node.data.@encoding == "csv") {
        var str:String = node.data.toString();
        var lines:Array = str.split("\n", height);
        for(i = 0; i < height; ++i) {
          var vals:Array = lines[i].split(",", width);
          for(j = 0; j < width; ++j) data[i][j] = uint(vals[j]);
        }
      } else {
        throw new Error("Unknown map data type!");
      }

      // Next is going to brake if tiles come more then one tileset proto
      var k:uint = 0; // tile proto index
      for(i = 0; i < height; ++i) {
        for(j = 0; j < width; ++j) {
          for(; k < mGs.length; ++k) {
            if(mGs[k].fgid <= data[i][j] && mGs[k].lgid > data[i][j]) break;
          }
          data[i][j] = data[i][j] - mGs[k].fgid;
        }
      }

      return new TLandscape(mGs[k].g as TTileset, data, layerID, layerType);
    }
  }
}

import net.jazz.game.core.TGraphic;

class TG {
  public var fgid:uint; // first GID
  public var lgid:uint; // last GID
  public var g:TGraphic;

  public function TG(fgid:uint, g:TGraphic) {
    this.g = g;
    this.lgid = (this.fgid = fgid) + this.g.countTiles;
  }
}
