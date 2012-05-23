package net.jazz.game.affects {
  import flash.geom.Rectangle;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TGoldenNumbers;

  import net.flashpunk.graphics.Canvas;
  import net.flashpunk.Entity;

  public class TScore extends TAffect {
    public static var instance:TScore;
    private var mCanvas:Canvas;
    private var mCurrentCount:int = 0;
    private var mTargetCount:int = 0;

    public override function Register(target:IAffectable):void {
      super.Register(target);
      mCanvas = (target as Entity).graphic as Canvas;
      mCanvas.fill(new Rectangle(21, 6, 64, 8));
      writeCurrentCount();
      instance = this;
    }

    public function add(count:int):void {
      mTargetCount += count;
    }

    public override function process():void {
      if(mCurrentCount != mTargetCount) {
        mCurrentCount += 7;
        if(mCurrentCount > mTargetCount) mCurrentCount = mTargetCount;
        writeCurrentCount();
      }
    }

    private function writeCurrentCount():void {
      TGoldenNumbers.Write(mCanvas, 21, 6, mCurrentCount, 8);
    }
  }
}
