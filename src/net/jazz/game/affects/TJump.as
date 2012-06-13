package net.jazz.game.affects {
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;

  public class TJump extends TAffect {
    public static const MAX_FLY_TIME:Number = 300;

    [Embed(source="../../../../../res/sounds/jump.mp3")]
    public static var JumpSound:Class;

    private var mJumpSound:Sfx;
    private var mGravity:TGravity;
    private var mControl:TControl;

    private var mBounds:TLevel;
    private var mIsJumping:Boolean = false;
    private var mJumped:Boolean = false;
    private var mDur:uint = 0;

    public function TJump(gravity:TGravity, control:TControl):void {
      mGravity = gravity;
      mControl = control;

      mJumpSound = new Sfx(JumpSound);
    }

    public function set bounds(bounds:TLevel):void { mBounds = bounds; }

    public function StartJump():void {
      mIsJumping = true;
    }

    public function StopJump():void {
      mIsJumping = false;
    }

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    public override function prepare():void {
      if(mIsJumping) {
        if(mJumped == false) {
          if(!(target as TObject).isFalling()) DoStartJump();
        }
      } else {
        if(mJumped == true) {
          DoStopJump();
        }
      }
    }

    public override function process():void {
      if(mJumped) {
        mDur += FP.elapsed * 1000;
        if(mDur > MAX_FLY_TIME) DoStopJump();
      }
    }

    public override function finish():void {
      if(!mIsJumping) return;
      if(mGravity.moved) return;
      DoStopJump();
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
    }

    private function DoStartJump():void {
      mJumpSound.play();
      var power:Number = Math.min(-10, -Math.abs(mControl.Speed()) / 3);
      mGravity.fire(power);
      mGravity.active = false;
      mJumped = true;
      mDur = 0;
    }

    private function DoStopJump():void {
      mGravity.active = true;
      mJumped = false;
    }
  }
}
