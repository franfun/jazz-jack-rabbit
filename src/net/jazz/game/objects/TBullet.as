package net.jazz.game.objects {

  import flash.geom.Rectangle;

  import net.flashpunk.FP;
  import net.flashpunk.graphics.Image;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.Sfx;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.affects.TLife;

  public class TBullet extends TObject {
    [Embed(source="../../../../../res/bullets/blaster.png")]
    protected static var Blaster:Class;
    [Embed(source="../../../../../res/bullets/toaster.png")]
    protected static var Toaster:Class;
    [Embed(source="../../../../../res/bullets/rf-missile.png")]
    protected static var RFMissile:Class;
    [Embed(source="../../../../../res/bullets/launcher.png")]
    protected static var Launcher:Class;
    [Embed(source="../../../../../res/boom-2.png")]
    protected static var Boom:Class;
    [Embed(source="../../../../../res/sounds/touch.mp3")]
    public static var TouchSound:Class;
    [Embed(source="../../../../../res/sounds/hit.mp3")]
    public static var HitSound:Class;

    private var mTypes:Array = [];
    private var mBoom:Spritemap;
    private var mType:uint;
    private var mSubType:uint;
    private var mDy:Number;

    private var mTouch:Sfx;
    private var mHit:Sfx;

    private var mBounds:TLevel;
    private var mFly:Boolean;
    private var mOrient:int = 1;

    public function TBullet() {
      super();
      mTouch = new Sfx(TouchSound);
      mHit = new Sfx(HitSound);
      mTypes.push(new Image(Blaster));
      mTypes.push(new Image(Toaster));
      mTypes.push(new Image(RFMissile));
      mTypes.push(new Image(Launcher));
      mBoom = new Spritemap(Boom, 23, 24);
      mBoom.add("move", [0, 1, 2, 3, 4, 5, 6], 24, false);
      mBoom.callback = kill;
      type = "bullet";
    }

    public function init(type:int = 0):void {
      mType = type;
      graphic = mTypes[type];
      setHitbox(mTypes[type].width, mTypes[type].height, 0, 0);
      mFly = true;
      mDy = -25;
      if(mType == 3) mSubType = 10;
    }

    public function set bounds(bb:TLevel):void { mBounds = bb; }

    public function set orient(z:int):void {
      mOrient = z;
      (graphic as Image).flipped = mOrient < 0;
    }

    public function set subType(st:uint):void {
      mSubType = st;
    }

    public override function process():void {
      super.process();
      if(!mFly) return;
      if(mType == 2) {
        var mdy:uint = (mSubType == 0 ? -6 : + 6) * FP.elapsed * 10;
        VerticalMove(mdy);
      } else if(mType == 3) {
        var ddy:Number = mDy + 35 * FP.elapsed * 10;
        mdy = (mDy + ddy) / 2 * FP.elapsed * 10;
        mDy = ddy;
        var dy:uint = this.verticalLimit(mdy);
        if(dy != mdy) {
          mDy = -mDy;
          mTouch.play();
        }
        VerticalMove(dy);
      }
      var mdx:Number = 35 * mOrient * FP.elapsed * 10;
      var dx:Number = this.horizontalLimit(mdx, false);
      if(Math.abs(dx) == 0) {
        if(mType == 3 && mSubType > 0) {
          mOrient *= -1;
          --mSubType;
          mTouch.play();
        } else {
          boom();
          return;
        }
      }
      HorizontalMove(dx);
      if(x < FP.camera.x - 30 || x > FP.camera.x + FP.screen.width + 30 ||
         y < FP.camera.y - 30 || y > FP.camera.y + FP.screen.height + 30)
        kill();
      var enemy:TObject = collide("enemy", x, y) as TObject;
      if(enemy) {
        boom();
        (enemy.getAffect(TLife) as TLife).hit();
      }
    }

    public function hitted():void {
      boom();
    }

    private function boom():void {
      mFly = false;
      graphic = mBoom;
      mBoom.play("move", true);
      this.y -= 10;
      this.x += 10 * mOrient;
      mHit.play();
    }

    private function kill():void {
      mBounds.recycle(this);
   }
  }
}