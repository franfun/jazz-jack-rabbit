package net.jazz.game.core {
  import net.jazz.game.core.IConfigurable;
  import net.jazz.game.data.TProperties;

  import net.flashpunk.Graphic;

  public class TGraphic implements IConfigurable {
    public static const PROP_NAME:String = "name";
    public static const PROP_TILEWIDTH:String = "tilewidth";
    public static const PROP_TILEHEIGHT:String = "tileheight";
    public static const PROP_WIDTH:String = "width";
    public static const PROP_HEIGHT:String = "height";

    public var source:TGraphicSource = new TGraphicSource;
    public var name:String;
    public var tilewidth:Number;
    public var tileheight:Number;
    public var width:Number;
    public var height:Number;

    public function TGraphic(props:TProperties) {
      this.setProperties(props);
    }

    public function setProperties(p:TProperties):void {
      source.setProperties(p);
      if(p.keys.indexOf(PROP_NAME) >= 0) name = String(p.remove(PROP_NAME) as TProperties);
      if(p.keys.indexOf(PROP_TILEWIDTH) >= 0) tilewidth = Number(p.remove(PROP_TILEWIDTH));
      if(p.keys.indexOf(PROP_TILEHEIGHT) >= 0) tileheight = Number(p.remove(PROP_TILEHEIGHT));
      if(p.keys.indexOf(PROP_WIDTH) >= 0) width = Number(p.remove(PROP_WIDTH));
      if(p.keys.indexOf(PROP_HEIGHT) >= 0) height = Number(p.remove(PROP_HEIGHT));
    }

    public function get countTiles():uint {
      return Math.round(width / tilewidth) * Math.round(height / tileheight);
    }

    public function build():Graphic {
      throw new Error("TGraphic itself cannot build Graphic instances!");
    }
  }
}
