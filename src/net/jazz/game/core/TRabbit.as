package net.jazz.game.core {
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.graphics.Image;

  import net.jazz.game.affects.TControl;

  public class TRabbit extends TObject implements IAffectable {
    [Embed(source = '../../../../../res/jazz-aligned.png')]
    private const JAZZ:Class;
    [Embed(source = '../../../../../res/jazz-jump.png')]
    private const JAZZ_JUMP:Class;

    private var mJazz:Spritemap = new Spritemap(JAZZ, 32, 34);
    private var mJazzJump:Image = new Spritemap(JAZZ_JUMP, 32, 36);

    public var shootCallback:Function = null;

    private var mIsFalling:Boolean = false;
    private var mIsJumping:Boolean = false;
    private var mIsShooting:Boolean = false;
    private var mIsFlipped:Boolean = false;
    private var mFallSpeed:int = 0;
    private var mLastGunShot:Number = 100;
    private var mShootRate:int = 10;
    private var mJumpDuration:Number = 0;
    private var mSpeed:Number = 0;

    public function get fallSpeed():int { return mFallSpeed; }
    public function get isJumping():Boolean { return mIsJumping; }
    public function get speed():Number { return mSpeed; }

    public function StopJump():void {
      mIsJumping = false;
      mFallSpeed = 0;
      mJumpDuration = 0;
    }

    public function TRabbit(control:TControl) {
      super();
      originX = -16;
      layer = 50;
      mJazz.add("stand", [0], 20, true);
      mJazz.add("run", [1, 2, 3, 4], 20, true);
      mJazz.add("stop", [7, 8], 40, true);
      mJazz.add("walk", [7, 8, 9, 10, 11, 12], 40, true);
      mJazz.add("fall", [13], 20, true);
      mJazz.add("crowch", [14, 15], 60, true);
      mJazz.add("shoot", [16, 17], 20, true);
      mJazz.add("fury_jump", [31, 32, 33, 34], 20, true);
      graphic = mJazz;
      type = "rabbit";
      setHitbox(32, 30, 0, -4);

      AddAffect(control);
    }

    public function get isFalling():Boolean { return mIsFalling; }
    public function set isFalling(bb:Boolean):void {
      if(mIsFalling == bb) return;
      mIsFalling = bb;
      if(mIsFalling) mFallSpeed = 1;
      else mFallSpeed = 0;
      SelectPlay();
    }

    public function get flipped():Boolean { return mIsFlipped; }
    public function set flipped(bb:Boolean):void {
      mIsFlipped = mJazz.flipped = mJazzJump.flipped = bb;
    }

    // override public function update():void
    // {
    //   mJazz.update();
    //   if(mLastGunShot < mShootRate / FP.frameRate) {
    //     if(mLastGunShot >= mShootRate / FP.frameRate)
    //       mLastGunShot = mShootRate / FP.frameRate;
    //   }
    //   if(Input.check(Key.SPACE)) {
    //     mLastGunShot += FP.elapsed;
    //     if(mLastGunShot >= mShootRate / FP.frameRate) {
    //       mLastGunShot = 0;
    //       shootCallback();
    //     }
    //   }

    //   if(Input.pressed(Key.RIGHT)) {
    //     flipped = false;
    //     mSpeed = 100;
    //     SelectPlay();
    //   }
    //   if(Input.pressed(Key.LEFT)) {
    //     flipped = true;
    //     mSpeed = -100;
    //     SelectPlay();
    //   }

    //   var changeWR:Boolean = Math.abs(mSpeed) < 150;
    //   if(Input.check(Key.RIGHT)) mSpeed += 250 * FP.elapsed;
    //   if(Input.check(Key.LEFT)) mSpeed -= 250 * FP.elapsed;
    //   mSpeed = Math.max(-250, Math.min(250, mSpeed));
    //   changeWR = changeWR && (Math.abs(mSpeed) >= 150);

    //   if(changeWR) SelectPlay();
    //   if((Input.released(Key.RIGHT) && mSpeed > 0) ||
    //       (Input.released(Key.LEFT) && mSpeed < 0)) {
    //     mSpeed = 0;
    //     SelectPlay();
    //   }
    //   if(Input.check(Key.UP) && !mIsFalling) {
    //     mFallSpeed = -200 - Math.abs(mSpeed) / 2;
    //     mIsJumping = true;
    //     mIsFalling = true;
    //     SelectPlay();
    //   }
    //   if(Input.released(Key.UP) && mIsJumping) {
    //     mIsJumping = false;
    //     mJumpDuration = 0;
    //   }
    //   if(Input.pressed(Key.SPACE)) {
    //     mIsShooting = true;
    //     SelectPlay();
    //   }
    //   if(Input.released(Key.SPACE)) {
    //     mIsShooting = false;
    //     mLastGunShot = 100;
    //     SelectPlay();
    //   }
    //   // jump power!!
    //   if(mIsJumping) {
    //     mFallSpeed -= 750 * FP.elapsed;
    //     mJumpDuration += FP.elapsed * FP.frameRate;
    //     if(mJumpDuration > 15) {
    //       mJumpDuration = 0;
    //       mIsJumping = false;
    //     }
    //   }
    //   // gravity
    //   if(mIsFalling && mFallSpeed < 420) {
    //     var redraw:Boolean = mFallSpeed <= 0;
    //     mFallSpeed += 750 * FP.elapsed;
    //     redraw = redraw && (mFallSpeed > 0);
    //     mFallSpeed = Math.min(mFallSpeed, 420);
    //     if(redraw) SelectPlay();
    //   }
    // }

    protected function SelectPlay():void {
      if(mIsFalling) {
        if(mFallSpeed>0) {
          graphic = mJazz;
          mJazz.play("fall");
        } else {
          if(mFallSpeed > -300) graphic = mJazzJump;
          else mJazz.play("fury_jump");
        }
      }
      else if(mSpeed != 0) {
        if(Math.abs(mSpeed) < 150) mJazz.play("walk");
        else mJazz.play("run");
      }
      else if(mIsShooting) mJazz.play("shoot");
      else mJazz.play("stand");
    }

  }
}