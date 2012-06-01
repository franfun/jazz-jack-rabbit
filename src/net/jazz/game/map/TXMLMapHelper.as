package net.jazz.game.map {
  import net.jazz.game.data.TProperties;

  public class TXMLMapHelper {
    private var mLandscapeProtos:Vector.<TLandscapeProto> = new Vector.<TLandscapeProto>();
    private var mLayerCount:uint = 0;

    public function addTileset(node:XML):void {
      var nodeProps:TProperties = new TProperties(node.properties[0]);

      nodeProps.fromAttributes(node);
      nodeProps.fromAttributes(node.image[0]);
      var gt:String = nodeProps.remove("g-type") as String;
      switch(gt) {
      case "landscape":
        var lp:TLandscapeProto = new TLandscapeProto();
        lp.setProperties(nodeProps);
        mLandscapeProtos.push(lp);
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
      var p:TProperties = new TProperties(node);
      p.fromAttributes(node);
      var width:uint = uint(p.find("width"));
      var height:uint = uint(p.find("height"));
      var layerID:uint = mLayerCount++;
      var layerType:String = p.find("type", "none") as String;
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
          for(; k < mLandscapeProtos.length; ++k)
            if(mLandscapeProtos[k].firstgid <= data[i][j] &&
               mLandscapeProtos[k].lastgid > data[i][j]) break;
          try {
            data[i][j] = data[i][j] - mLandscapeProtos[k].firstgid;
          } catch(e:Error) {
            throw new Error(mLandscapeProtos[0].firstgid + " -> " + mLandscapeProtos[0].lastgid);
          }
        }
      }

      return mLandscapeProtos[k].buildLandscape(data, layerID, layerType);
    }
  }
}

import net.jazz.game.core.IConfigurable;
import net.jazz.game.data.TProperties;
import net.jazz.game.map.TLandscape;

class TLandscapeProto implements IConfigurable {
  public var name:String;
  public var firstgid:uint;
  public var lastgid:uint = 0;
  public var tilewidth:Number;
  public var tileheight:Number;
  public var width:Number;
  public var height:Number;
  public var source:String;
  public var maskSource:String = null;

  public function setProperties(p:TProperties):void {
    name = String(p.remove("name"));
    firstgid = uint(p.remove("firstgid"));
    tilewidth = Number(p.remove("tilewidth"));
    tileheight = Number(p.remove("tileheight"));
    source = p.remove("source") as String;
    width = Number(p.remove("width"));
    height = Number(p.remove("height"));
    maskSource = String(p.remove("maskSource"));
    lastgid = firstgid + Math.round(width / tilewidth) * Math.round(height / tileheight);
  }

  public function buildLandscape(data:Array, id:uint, type:String):TLandscape {
    var ls:TLandscape = new TLandscape();
    ls.tilewidth = this.tilewidth;
    ls.tileheight = this.tileheight;
    ls.data = data;
    ls.layer = id;
    ls.type = type;
    return ls;
  }
}
