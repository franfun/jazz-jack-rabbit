package net.jazz.game.core {
  import flash.display.Bitmap;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.geom.ColorTransform;

  import net.flashpunk.Engine;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.utils.TouchPad;
  import net.flashpunk.graphics.Image;

  import net.jazz.game.map.IMap;
  import net.jazz.game.map.TFakeMap;
  import net.jazz.game.affects.TControl;
  import net.jazz.game.affects.TGravity;
  import net.jazz.game.affects.TKeyboard;
  import net.jazz.game.affects.TRabbitAnimator;
  import net.jazz.game.affects.TRabbitLife;
  import net.jazz.game.affects.TJump;
  import net.jazz.game.affects.TShoot;
  import net.jazz.game.affects.TCircleWalk;
  import net.jazz.game.affects.TCameraWatch;
  import net.jazz.game.affects.TWeaponChanger;
  import net.jazz.game.affects.TScore;
  import net.jazz.game.affects.TTimer;

  public class TRoot extends Engine {
//     private var mColors:Array = [[0xff00007c, 0xff0404a0, 0xff0c0cc8, 0xff1814e0, 0xff2824fc, 0xff544cfc, 0xff8074fc,
//                                   0xffa8a0fc],
//                                  [0xffff0000, 0xffffa600, 0xffffff00, 0xffff5100],
//                                  [0xfffcfc00, 0xfffca400, 0xfffc5000, 0xfffc0000],
// [0xfff4fc00, 0xff5c3000, 0xffac8400],
// [0xff0058a4, 0xff00284c, 0xff0090fc]];

    /**
     * Game Level to play.
     */
    private var mLevel:TLevel;
    /**
     * Map data.
     */
    private var mMap:IMap;
    /**
     * Level wide affects. Should be never reseted.
     */
    private var mGameHive:TAffectHive;
    /**
     * Per-object affeect builder. Resets after building each object.
     */
    private var mObjectHive:TAffectHive;
    
    private var mLevelAffectBuilder:TAffectHive;

    // private var mOnFadedCallback:Function;
    // private var mFadeLevel:Number = 1;
    // private var mFadeSpeed:Number = 0;

    private var mMisc:TMisc;

    public function TRoot(w:uint, h:uint, fps:uint, tick:Boolean) {
      super(w, h, fps, tick);

      FP.screen.scale = 2;
      FP.console.enable();
    }

    public function get misc():TMisc { return mMisc; }

    // private var r:uint = 0;
    // public override function render():void {
    //   super.render();
    //   processFade();
    //   for(var j:int = 0; j < mColors.length; ++j) {
    //     for(var i:int = 0; i < mColors[j].length; ++i)
    //       FP.buffer.threshold(FP.buffer, new Rectangle(0, 0, FP.buffer.width, FP.buffer.height), new Point(0,0), "==",
    //                           mColors[j][i], mColors[j][i] + 1, 0xffffffff, false);
    //     for(i = 0; i < mColors[j].length; ++i)
    //       FP.buffer.threshold(FP.buffer, new Rectangle(0, 0, FP.buffer.width, FP.buffer.height), new Point(0,0), "==",
    //                           mColors[j][i] + 1, mColors[j][(7 + i - r) % mColors[j].length], 0xffffffff, false);
    //   }
    //   r = (r + 1) % 8;
    // }

    public function StartLevel():void {
      buildLevelHive();
      buildObjectHive();

      mLevel = new TLevel;
      mLevel.addMisc(mMisc = new TMisc(mGameHive));

      var life:TRabbitLife = mObjectHive.getByName("rabbit-life") as TRabbitLife;
      life.canvas = mMisc.canvas;

      mMap = new TFakeMap();
      mMap.load(LoadDone);
    }

    private function LoadDone():void {
      // var life:TRabbitLife = new TRabbitLife(mLevel.misc.canvas, onDeath);

      mMap.install(mLevel, mObjectHive);

      FP.world = mLevel;
    }

    // private function onDeath():void {
    //   var animator:TRabbitAnimator = mJazz.getAffect(TRabbitAnimator) as TRabbitAnimator;
    //   animator.playDeath(onDeathPlayed);
    // }

    // private function onDeathPlayed():void {
    //   fadeIn(onFaded);
    // }

    // public function fadeIn(callback:Function):void {
    //   mFadeSpeed = -0.08;
    //   mFadeLevel = 1;
    //   mOnFadedCallback = callback;
    // }

    // private function onFaded():void {
    // }

    // private var mColorTransform:ColorTransform = new ColorTransform;
    // private function processFade():void {
    //   mFadeLevel += mFadeSpeed;
    //   mColorTransform.redMultiplier = mColorTransform.greenMultiplier = mColorTransform.blueMultiplier  = mFadeLevel;
    //   FP.buffer.colorTransform(new Rectangle(0,0,320,240), mColorTransform);
    //   if(mFadeLevel == 0 && mFadeSpeed < 0) {
    //     mFadeSpeed = mFadeLevel = 0;
    //     mOnFadedCallback();
    //   } else if(mFadeLevel >= 1 && mFadeSpeed > 0) {
    //     mFadeSpeed = 0;
    //     mFadeLevel = 1;
    //     mOnFadedCallback();
    //   }
    // }

    private function buildLevelHive():void {
      mGameHive = new TAffectHive();
      mGameHive.pushAll({
            score: TScore,
            timer: TTimer,
            gravity: TGravity,
            "weapon-changer": TWeaponChanger});
    }

    private function buildObjectHive():void {
      mObjectHive = new TAffectHive(mGameHive);
      mObjectHive.pushAll({control: TControl,
            "rabbit-animator": TRabbitAnimator,
            "rabbit-life": TRabbitLife,
            jump: TJump,
            shoot: TShoot,
            keyboard: TKeyboard,
            "circle-walk": TCircleWalk,
            "camera-watch": TCameraWatch});
    }
  }
}