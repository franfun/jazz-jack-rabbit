package net.jazz.game.core {
  import flash.display.BitmapData;
  import flash.display.Bitmap;
  import flash.geom.Rectangle;
  import flash.geom.Matrix;

  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Canvas;

  public class TMisc extends TObject {
    [Embed(source="../../../../../res/toolbar.png")]
    protected static var Toolbar:Class;

    private var mCanvas:Canvas;
    public function TMisc(affectBuilder:TAffectBuilder) {
      var bitmap:BitmapData = (new Toolbar as Bitmap).bitmapData;
      graphic = mCanvas = new Canvas(bitmap.width, bitmap.height);
      mCanvas.draw(0, 0, bitmap);
      graphic.scrollX = 0;
      graphic.scrollY = 0;
      y = FP.screen.height - bitmap.height;
      addAffect(affectBuilder.getByName("weapon-changer"));
      addAffect(affectBuilder.getByName("score"));
      addAffect(affectBuilder.getByName("timer"));
    }

    public function get canvas():Canvas { return mCanvas; }
  }
}
