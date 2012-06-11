package net.jazz.game.core {
  import flash.display.Bitmap;
  import flash.display.BitmapData;

  import net.jazz.game.core.IConfigurable;
  import net.jazz.game.data.TProperties;

  public class TGraphicSource {
    public static const PROP_IMAGE_SOURCE:String = "source";

    [Embed(source="../../../../../res/diamondus-aligned-indexed.png")]
    protected var Tiles:Class;
    [Embed(source="../../../../../res/diamondus-hit-all.png")]
    protected var TilesHit:Class;
    [Embed(source = '../../../../../res/jazz-aligned.png')]
    private const JAZZ:Class;

    public var source:String = null;
    public function TGraphicSource(props:TProperties = null) {
      if(props) setProperties(props);
    }

    public function setProperties(p:TProperties):void {
      if(p.keys.indexOf(PROP_IMAGE_SOURCE) >= 0 ) source = String(p.remove(PROP_IMAGE_SOURCE));
    }

    public function get bitmap():BitmapData {
      switch(source) {
      case "diamondus-aligned-indexed.png":
        return Bitmap(new Tiles()).bitmapData;
      case "diamondus-hit-all.png":
        return Bitmap(new TilesHit()).bitmapData;
      case "jazz-aligned.png":
        return Bitmap(new JAZZ()).bitmapData;
      };
      return null;
    }
  }
}