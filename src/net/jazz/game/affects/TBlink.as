package net.jazz.game.affects {
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IColorizable;
  import net.flashpunk.FP;

  public class TBlink extends TAffect {
    public var callback:Function;

    private var mTime:Number = 0;
    private var mOneTime:Number = 0.2;
    private var mCount:Number;
    private var mRed:uint;
    private var mBlue:uint;
    private var mGreen:uint;
    private var mRedOffset:uint;
    private var mBlueOffset:uint;
    private var mGreenOffset:uint;

    public function TBlink(colorOffset:uint, times:uint = 1, color:uint = 0xFFFFFF) {
      mRed = (color >> 16) & 0xff;
      mGreen = (color >> 8) & 0xff;
      mBlue = color & 0xff;
      mRedOffset = (colorOffset >> 16) & 0xff;
      mGreenOffset = (colorOffset >> 8) & 0xff;
      mBlueOffset = colorOffset & 0xff;
      mCount = times;
    }

    public override function process():void {
      var obj:IColorizable = target as IColorizable;
      mTime += FP.elapsed;
      if(mTime > mOneTime * mCount) {
        obj.color = 0xFFFFFF;
        obj.colorOffset = 0x000000;
        target.removeAffect(this);
        if(callback != null) callback();
        return;
      }
      var m:Number = Math.abs(Math.sin(mTime / mOneTime * Math.PI));
      var r:uint = m * mRedOffset;
      var g:uint = m * mGreenOffset;
      var b:uint = m * mBlueOffset;
      obj.colorOffset = (((r << 8) + g) << 8) + b;
      r = (1 - m) * (0xff - mRed) + mRed;
      g = (1 - m) * (0xff - mGreen) + mGreen;
      b = (1 - m) * (0xff - mBlue) + mBlue;
      obj.color = (((r << 8) + g) << 8) + b;
    }

  }
}