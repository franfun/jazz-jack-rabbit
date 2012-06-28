package net.jazz.game.map {
  import net.jazz.game.data.TProperties;
  import net.jazz.game.core.TObjectIdea;
  import net.jazz.game.core.TGraphic;
  import net.jazz.game.core.graphic.TTileset;
  import net.jazz.game.core.graphic.TSpritemap;

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
        var s:TSpritemap = new TSpritemap(nodeProps);
        mGs.push(new TG(uint(nodeProps.remove("firstgid")), s, nodeProps));
        trace("added spritemap");
        break;
      case "images":
        throw new Error("Images not yet Parsable");
        break;
      default:
        throw new Error("Unknown tileset type " + gt);
        break;
      }
    }

    public function parseObjectLayer(node:XML):Array {
      var res:Array = [];
      var layerID:uint = mLayerCount++;
      for each(var obj:XML in node.object) {
        var objI:TObjectIdea = null;
        try {
          objI = parseObject(obj);
        } catch(e:Error) {
          trace(e);
        }
        objI.layerID = layerID;
        res.push(objI);
      }
      trace("Objects : " + res.join(" :: "));
      return res;
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
      var k:int = getGByGID(data[0][0]); // tile proto index
      for(i = 0; i < height; ++i)
        for(j = 0; j < width; ++j)
          data[i][j] = data[i][j] - mGs[k].fgid;

      return new TLandscape(mGs[k].g as TTileset, data, layerID, layerType);
    }

    private function parseObject(obj:XML):TObjectIdea {
      trace("++++ start parsing object");
      var props:TProperties = new TProperties(obj.properties ? obj.properties[0] : null);
      props.fromAttributes(obj);

      var gid:uint = uint(props.remove("gid"));
      var k:int = getGByGID(gid); // tile proto index
      if(k < 0) throw new Error("Graphic for object not found. GID = " + gid);

      props.extend(mGs[k].props);
      trace("---- object building OK");

      return new TObjectIdea(mGs[k].g, props);
    }

    private function getGByGID(gid:uint):int {
      for(var k:int = 0; k < mGs.length; ++k)
        if(mGs[k].fgid <= gid && mGs[k].lgid > gid) return k;
      return -1;
    }
  }
}

import net.jazz.game.core.TGraphic;
import net.jazz.game.data.TProperties;

class TG {
  public var fgid:uint; // first GID
  public var lgid:uint; // last GID
  public var g:TGraphic;
  public var props:TProperties;

  public function TG(fgid:uint, g:TGraphic, props:TProperties = null) {
    this.g = g;
    this.lgid = (this.fgid = fgid) + this.g.countTiles;
    this.props = props;
  }
}
