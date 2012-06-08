package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TRabbit;

  public class TRabbitAnimator extends TAffect {
    private var mGravity:TGravity;
    private var mControl:TControl;
    private var mShoot:TShoot;

    private var mIsAnimating:Boolean = true;

    public function TRabbitAnimator(gravity:TGravity, control:TControl, shoot:TShoot = null) {
      mGravity = gravity;
      mControl = control;
      mShoot = shoot;
    }

    public function playDeath(callback:Function):void {
      mIsAnimating = false;
      var rabbit:TRabbit = target as TRabbit;
      rabbit.Play("die", callback);
    }

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    private var mColorized:Boolean = false;
    public override function finish():void {
      if(!mIsAnimating) return;
      var rabbit:TRabbit = target as TRabbit;
      var vertical_speed:int = mGravity.Speed();
      var orient:int = mControl.orientation;
      var speed:int = Math.abs(mControl.Speed());
      var hit:THit = rabbit.getAffect(THit) as THit;

      if(hit) {
        if(hit.state == THit.SUFFER) {
          rabbit.Play("hurt");
          rabbit.flipped = orient > 0;
          return;
        }
      }
      if(vertical_speed != 0) {
        var type:String = vertical_speed > 0 ? "fall" : "jump";
        rabbit.flipped = orient > 0;
        rabbit.Play(type);
      } else {
        if(speed != 0) {
          type = speed < 20 ? "walk" : "run";
          rabbit.Play(type);
          rabbit.flipped = orient > 0;
        }
        else {
          if(mShoot && mShoot.shooted) {
            mShoot.shooted = false;
            rabbit.Play("shoot");
          } else rabbit.Play("stand");
        }
      }
    }
  }
}
