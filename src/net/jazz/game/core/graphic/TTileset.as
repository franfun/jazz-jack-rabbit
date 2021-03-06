package net.jazz.game.core.graphic {
  import net.jazz.game.core.IConfigurable;
  import net.jazz.game.core.TGraphicSource;
  import net.jazz.game.core.TGraphic;
  import net.jazz.game.data.TProperties;

  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.Graphic;

  public class TTileset extends TGraphic implements IConfigurable {
    public static const PROP_MASK:String = "mask";
    public var mask:TGraphicSource = null;

    private var mWidth:Number;
    private var mHeight:Number;

    public function TTileset(p:TProperties) {
      super(p);
    }

    public override function setProperties(p:TProperties):void {
      super.setProperties(p);
      if(p.groups.indexOf(PROP_MASK) >= 0) mask = new TGraphicSource(p.removeGroup(PROP_MASK));
    }

    public final function setSize(w:Number, h:Number):void {
      this.mWidth = w;
      this.mHeight = h;
    }

    public override function build():Graphic {
      return new Tilemap(source.bitmap, mWidth, mHeight, tilewidth, tileheight);
    }

    // public function buildLandscape(data:Array, id:uint, type:String):TLandscape {
    //   var ls:TLandscape = new TLandscape();
    //   ls.tilewidth = this.tilewidth;
    //   ls.tileheight = this.tileheight;
    //   ls.data = data;
    //   ls.layer = id;
    //   ls.type = type;
    //   return ls;
    // }
  }
}