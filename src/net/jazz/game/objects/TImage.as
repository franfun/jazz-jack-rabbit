package net.jazz.game.objects {
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Rectangle;

  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;

  import net.jazz.game.affects.THit;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;

  public class TImage extends TObject {
    [Embed(source="../../../../../res/items.png")]
    protected static var Items:Class;
    protected static var mItemImage:BitmapData = (new Items as Bitmap).bitmapData;

    public static const MISC_SUBTYPES:Array = ["fire", "carrot", "life", "rfmissile", "launcher", "blaster",
                                               "biglauncher", "bigblaster", "bigrfmissile", "haste", "powershell",
                                               "shell", "levelend", "checkpoint", "secretlevel", "mark"];
    public static function get fire():TImage {
      return new TImage(mItemImage, 0, 0, 32, 32);
    }

    public static function get carrot():TImage {
      return new TImage(mItemImage, 32, 0, 32, 32);
    }

    public static function get life():TImage {
      return new TImage(mItemImage, 64, 0, 32, 32);
    }

    public static function get rfmissile():TImage {
      return new TImage(mItemImage, 96, 0, 32, 32);
    }

    public static function get bigrfmissile():TImage {
      return new TImage(mItemImage, 0, 32, 32, 32);
    }

    public static function get launcher():TImage {
      return new TImage(mItemImage, 128, 0, 32, 32);
    }

    public static function get biglauncher():TImage {
      return new TImage(mItemImage, 192, 0, 32, 32);
    }

    public static function get blaster():TImage {
      return new TImage(mItemImage, 160, 0, 32, 32);
    }

    public static function get bigblaster():TImage {
      return new TImage(mItemImage, 224, 0, 32, 32);
    }

    public function TImage(tiles:Object, dx:Number, dy:Number, w:Number, h:Number) {
      var anim:Image = new Image(tiles, new Rectangle(dx, dy, w, h));
      setHitbox(w, h, 0, 0);
      graphic = anim;
    }
  }
}
