package net.jazz.game.core {
  import net.jazz.game.core.IConfigurable;
  import net.jazz.game.data.TProperties;

  public class TGraphicSource {
    public static const PROP_IMAGE_SOURCE:String = "source";
    public var source:String = null;
    public function TGraphicSource(props:TProperties = null) {
      if(props) setProperties(props);
    }

    public function setProperties(p:TProperties):void {
      if(p.keys.indexOf(PROP_IMAGE_SOURCE) >= 0 )
        source = String(p.remove(PROP_IMAGE_SOURCE));
    }
  }
}