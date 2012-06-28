package net.jazz.game.affects {
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;

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
      var rabbit:TObject = target as TObject;
      var rabbitGraphic:Spritemap = rabbit.graphic as Spritemap;
      rabbitGraphic.callback = callback;
      rabbitGraphic.play("die");
    }

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    private var mColorized:Boolean = false;
    public override function finish():void {
      if(!mIsAnimating) return;
      var rabbit:TObject = target as TObject;
      var vertical_speed:int = mGravity.Speed();
      var orient:int = mControl.orientation;
      var speed:int = Math.abs(mControl.Speed());
      var hit:THit = rabbit.getAffect(THit) as THit;
      var rabbitGraphic:Spritemap = rabbit.graphic as Spritemap;

      if(hit) {
        if(hit.state == THit.SUFFER) {
          rabbitGraphic.play("hurt");
          rabbitGraphic.flipped = orient > 0;
          return;
        }
      }
      if(vertical_speed != 0) {
        var type:String = vertical_speed > 0 ? "fall" : "jump";
        rabbitGraphic.flipped = orient > 0;
        rabbitGraphic.play(type);
      } else {
        if(speed != 0) {
          type = speed < 20 ? "walk" : "run";
          rabbitGraphic.play(type);
          rabbitGraphic.flipped = orient > 0;
        }
        else {
          if(mShoot && mShoot.shooted) {
            mShoot.shooted = false;
            rabbitGraphic.play("shoot");
          } else rabbitGraphic.play("stand");
        }
      }
    }
  }
}
