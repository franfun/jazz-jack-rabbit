package net.jazz.game.objects {

  import flash.geom.Rectangle;

  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.graphics.Spritemap;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;

  public class TBoom extends TObject {
    [Embed(source="../../../../../res/boom.png")]
    protected static var Boom:Class;

    private var mBoom:Spritemap;
    private var mBounds:TLevel;
    private var mDX:Number;
    private var mDY:Number;

    public function TBoom() {
      super();
      mBoom = new Spritemap(Boom, 30, 25);
      mBoom.add("move", [6, 5, 4, 3, 2, 1, 0], 24, false);
      mBoom.callback = kill;
      graphic = mBoom;
    }

    public function set bounds(bb:TLevel):void { mBounds = bb; }

    public function init(dx:Number, dy:Number):void {
      mDX = dx;
      mDY = dy;
      mBoom.play("move", true);
    }

    public override function process():void {
      mDY += 20 * FP.elapsed * 10;
      HorizontalMove(mDX * FP.elapsed * 10);
      VerticalMove(mDY * FP.elapsed * 10);
    }

    private function kill():void {
      mBounds.recycle(this);
   }
  }
}