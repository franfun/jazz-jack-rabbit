package net.jazz.game.core {
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Rectangle;

  import net.flashpunk.graphics.Canvas;

  public class TGoldenNumbers {
    [Embed(source="../../../../../res/golden-numbers.png")]
    protected static var Gold:Class;

    private static var sGold:BitmapData = (new Gold as Bitmap).bitmapData;

    public static function Write(where:Canvas, x:Number, y:Number, n:int, s:uint):void {
      var w:Number = s * 8;
      where.fill(new Rectangle(x, y, w, 7), 0);
      if(n == -1) {
        where.draw(x + w / 2 - 7, y, sGold, new Rectangle(70, 0, 14, 7));
        return;
      }
      var dx:Number = w -8;
      while(dx >= 0) {
        var d:int = n % 10;
        where.draw(x + dx, y, sGold, new Rectangle(d * 7, 0, 7, 7));
        dx -= 8;
        n /= 10;
      }
    }
  }
}