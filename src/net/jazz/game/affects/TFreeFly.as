package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.IBounded;
  import net.jazz.game.core.TObject;
  import net.jazz.game.objects.TSprite;

  public class TFreeFly extends TAffect {

    private var mOrient:int = 1;
    private var mMaxDx:int;
    private var mDx:int;
    private var mOriginX:int;
    private var mOriginY:int;

    public function TFreeFly(max:int) {
      mMaxDx = max;
    }

    public override function process():void {
      var obj:TSprite = target as TSprite;
      mDx += mOrient * 10 * FP.elapsed * 10;
      if(mDx >= mMaxDx) {
        mDx = mMaxDx;
        mOrient = -1;
        obj.flipped = true;
      } else if(mDx <= 0) {
        mDx = 0;
        mOrient = 1;
        obj.flipped = false;
      }
      obj.x = mOriginX + mDx;
      if(mDx % 18 < 12) obj.y = mOriginY - 2;
      else obj.y = mOriginY;
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
      var obj:TObject = target as TObject;
      mOriginX = obj.x;
      mOriginY = obj.y;
    }
  }
}
