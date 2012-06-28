package net.jazz.game.affects {
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;

  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.IAffectable;

  /**
   * Implents pure jazz control - no device specific data.
   */
  public class THit extends TAffect {
    public static const NONE:String = "none";
    public static const SUFFER:String = "suffer";

    [Embed(source="../../../../../res/sounds/hurt.mp3")]
    public static var HurtSound:Class;

    private var mHurtSound:Sfx;

    protected var mTime:Number = 0;
    protected var mControl:TControl;
    protected var mGravity:TGravity;

    public var callback:Function;

    private var mState:String = NONE;
    public function THit():void {
      mHurtSound = new Sfx(HurtSound);
    }

    public function get state():String { return mState; }

    public function get timing():Number { return mTime; }

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    public override function prepare():void {
      if(mState == NONE) StartAffect();
      if(mState == SUFFER) {
        if(mTime > 200) StopSuffer();
      }
    }

    public override function process():void {
      mTime += FP.elapsed * 1000;
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
      mControl = target.getAffect(TControl) as TControl;
      mGravity = target.getAffect(TGravity) as TGravity;
    }

    private function StartAffect():void {
      mState = SUFFER;
      mHurtSound.play();
      var rr:int = mControl.orientation;
      // .active = false;
      mTime = 0;
      mControl.active = false;
      mControl.extraPower = rr * 80;
      mGravity.fire(-10);
    }

    private function StopSuffer():void {
      // rab.active = true;
      mTime = 0;
      mControl.active = true;
      mControl.extraPower = 0;
      callback();
      target.removeAffect(this);
    }
  }
}
