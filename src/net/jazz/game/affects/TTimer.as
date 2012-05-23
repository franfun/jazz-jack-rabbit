package net.jazz.game.affects {
  import flash.geom.Rectangle;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TGoldenNumbers;

  import net.flashpunk.graphics.Canvas;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;

  public class TTimer extends TAffect {
    public static var instance:TTimer;
    private var mCanvas:Canvas;
    private var mTime:int = 0;

    public function TTimer(time:int) {
      this.time = time;
    }

    public function get time():int { return mTime; }
    public function set time(t:int):void { mTime = Math.min(10 * 60 * 1000 -1, t); }

    public override function Register(target:IAffectable):void {
      super.Register(target);
      mCanvas = (target as Entity).graphic as Canvas;
      mCanvas.fill(new Rectangle(109, 6, 8, 8));
      mCanvas.fill(new Rectangle(121, 6, 16, 8));
      mCanvas.fill(new Rectangle(141, 6, 8, 8));
      writeCurrentCount();
      instance = this;
    }

    public override function process():void {
      mTime -= FP.elapsed * 1000;
      writeCurrentCount();
    }

    private function writeCurrentCount():void {
      TGoldenNumbers.Write(mCanvas, 109, 6, mTime / 1000 / 60, 1);
      TGoldenNumbers.Write(mCanvas, 121, 6, mTime / 1000 % 60, 2);
      TGoldenNumbers.Write(mCanvas, 141, 6, mTime / 100 % 10, 1);
    }
  }
}
