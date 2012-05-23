package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TObject;

  public class TFloating extends TAffect {

    private var mTime:Number = 0;
    private var mDTime:Number = 0.05;
    private var dY:Number = 0;
    private var mDY:Number = -1;

    public override function Register(target:IAffectable):void {
      super.Register(target);
      var obj:TObject = target as TObject;
      if(Math.floor(obj.x / 32) % 2 == Math.floor(obj.y / 32) % 2) {
        obj.VerticalMove(3);
        mDY = 1;
        dY += 3;
      }
    }

    public override function process():void {
      mTime += FP.elapsed;
      if(mTime < mDTime) return;
      mTime -= mDTime;
      var obj:TObject = target as TObject;
      if(dY == 4 || dY == 0) {
        mDY *= -1;
      }
      obj.VerticalMove(mDY);
      dY += mDY;
    }
  }
}
