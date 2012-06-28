package net.jazz.game.affects {
  import flash.geom.Rectangle;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TObject;

  import net.flashpunk.graphics.Canvas;

  public class TRabbitLife extends TAffect {
    private var mOnDeath:Function;

    private var mIsHitted:Boolean = false;
    private var mColors:Array = [0x000000, 0xff0000, 0xFF4108, 0xD708D7, 0x59DF08, 0x5508DF];
    private var mEndColor:Number = 0x5508DF;
    private var mStartColor:Number = 0x5508DF;
    private var mLife:uint = 5;
    private var mFilled:Rectangle = new Rectangle(20, 20, 0, 7);

    private var mCanvas:Canvas;
    private var mFullRect:Rectangle = new Rectangle(20, 20, 65, 7);

    public function TRabbitLife() {
    }

    public function set canvas(canvas:Canvas):void { mCanvas = canvas; }

    public function set onDeath(onDeath:Function):void { mOnDeath = onDeath; }

    public function hit():void {
      if(mIsHitted) return;
      var hit:THit = new THit;
      hit.callback = startBlink;
      target.addAffect(hit);
      mIsHitted = true;
      mStartColor = mEndColor;
      mEndColor = mColors[--mLife];
    }

    public function heal():void {
      if(mLife == 5) return;
      ++mLife;
    }

    public override function process():void {
      if(mLife * 13 == mFilled.width) return;
      mCanvas.fill(mFullRect, 0);
      mFilled.width += mFilled.width < mLife * 13 ? 1 : -1;
      var d:Number = Math.min(1, Math.abs((mLife * 13 - mFilled.width)) / 13);
      var r1:uint = mEndColor >> 16 & 0xff;
      var g1:uint = mEndColor >> 8 & 0xff;
      var b1:uint = mEndColor & 0xff;
      var r2:uint = mStartColor >> 16 & 0xff;
      var g2:uint = mStartColor >> 8 & 0xff;
      var b2:uint = mStartColor & 0xff;
      r1 = r1 + (r2 - r1) * d;
      g1 = g1 + (g2 - g1) * d;
      b1 = b1 + (b2 - b1) * d;
      var cc:Number = (((r1 << 8) + g1) << 8) + b1;
      mCanvas.fill(mFilled, cc);
    }

    private function startBlink():void {
      if(mLife == 0) {
        mOnDeath();
        return;
      }
      var blink:TBlink = new TBlink(0x880000, 5, 0x008888);
      blink.callback = endImmortality;
      target.addAffect(blink);
    }

    private function endImmortality():void {
      mIsHitted = false;
    }
  }
}
