package net.jazz.game.affects {
  import flash.display.BitmapData;

  import net.flashpunk.FP;
  import net.flashpunk.Sfx;

  import net.jazz.game.affects.TGravity;
  import net.jazz.game.objects.IActor;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TRabbit;
  import net.jazz.game.core.IAffectable;

  public class TJumpad extends TAffect {
    [Embed(source="../../../../../res/sounds/jumpad.mp3")]
    protected static var Jumpad:Class;

    private var mIsJumping:Boolean = false;

    private var mPower:Number;
    private var mSfx:Sfx;

    public function TJumpad(power:Number) {
      FP.console.log("power " + power);
      mPower = power;
      mSfx = new Sfx(Jumpad);
    }

    public override function process():void {
      var obj:TObject = target as TObject;
      var rabbit:TRabbit = obj.collide("rabbit", obj.x, obj.y) as TRabbit;
      if(rabbit) {
        if(mIsJumping) return;
        mIsJumping = true;
        var gravity:TGravity = rabbit.getAffect(TGravity) as TGravity;
        gravity.fire(-mPower);
        mSfx.play();
        var actor:IActor = target as IActor;
        if(actor) actor.act();
      } else {
        if(!mIsJumping) return;
        mIsJumping = false;
      }
    }
  }
}