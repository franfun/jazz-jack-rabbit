package net.jazz.game.affects {
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Rectangle;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TMisc;
  import net.jazz.game.core.TGoldenNumbers;

  import net.flashpunk.graphics.Canvas;
  import net.flashpunk.FP;
  import net.flashpunk.Entity;

  public class TWeaponChanger extends TAffect {
    [Embed(source="../../../../../res/bullets/all-types.png")]
    protected static var Types:Class;

    private var mTypesBitmap:BitmapData;
    private var mCanvas:Canvas;
    private var mCurrentWeapon:uint = 0;
    private var mY:Number;
    private var mIsShowing:Boolean = false;
    private var mCurrentCount:int = -1;
    private var mTargetCount:int = -1;

    public function TWeaponChanger() {
      mTypesBitmap = (new Types as Bitmap).bitmapData;
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
      mCanvas = (target as Entity).graphic as Canvas;
      mCanvas.draw(249, 2, mTypesBitmap, new Rectangle(mCurrentWeapon * 64, 0, 64, 26));
      writeCurrentCount();
    }

    public function setWeapon(type:uint):void {
      if(type == mCurrentWeapon) return;
      mCurrentWeapon = type;
      mY = 0;
      mIsShowing = true;
    }

    public function updateAmmoCount(count:int):void {
      mTargetCount = count;
      if(mTargetCount == -1 && mCurrentCount != -1) {
        mCurrentCount = -1;
        writeCurrentCount();
      } else if (mTargetCount != -1 && mCurrentCount == -1) {
        mCurrentCount = 0;
        writeCurrentCount();
      }
    }

    public override function process():void {
      if(mCurrentCount != mTargetCount) {
        mCurrentCount += (mCurrentCount > mTargetCount ? -1 : 1);
        writeCurrentCount();
      }
      if(!mIsShowing) return;
      mY += FP.elapsed * 26 * 2;
      if(mY >= 26) {
        mY = 26;
        mIsShowing = false;
      }
      mCanvas.draw(249, 2, mTypesBitmap, new Rectangle(mCurrentWeapon * 64, 26 - mY, 64, mY));
    }

    private function writeCurrentCount():void {
      TGoldenNumbers.Write(mCanvas, 223, 20, mCurrentCount, 3);
    }
  }
}