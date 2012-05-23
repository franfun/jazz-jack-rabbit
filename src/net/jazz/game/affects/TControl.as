package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.affects.data.TControlData;

  /**
   * Implents pure jazz control - no device specific data.
   */
  public class TControl extends TAffect {
    /**
     * If left button pressed
     */
    private var mLeftStarted:Boolean = false;
    /**
     * If right button pressed
     */
    private var mRightStarted:Boolean = false;
    /**
     * Current required orientation. -1 left, +1 right, 0 no movement required
     */
    private var mHorizontalLook:int = 0;

    public var extraPower:Number = 0;

    private var mLastDelta:int;
    private var mV:Number = 0;

    private var mActive:Boolean = true;

    public function TControl():void {
    }

    /**
     * Moving left started.
     */
    public function StartLeft():void {
      mHorizontalLook = -1;
      mLeftStarted = true;
    }

    /**
     * Moving left stoped.
     */
    public function StopLeft():void {
      mLeftStarted = false;
      if(mHorizontalLook != -1) return;
      mHorizontalLook = (mRightStarted ? 1 : 0);
    }

    /**
     * Moving right started.
     */
    public function StartRight():void {
      mHorizontalLook = 1;
      mRightStarted = true;
    }

    /**
     * Moving right stoped.
     */
    public function StopRight():void {
      mRightStarted = false;
      if(mHorizontalLook != 1) return;
      mHorizontalLook = (mLeftStarted ? -1 : 0);
    }

    public function Speed():Number {
      return mV;
    }

    public function set active(bb:Boolean):void {
      if(mActive == bb) return;
      mActive = bb;
      mV = 0;
    }

    public function get active():Boolean { return mActive; }

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    public override function prepare():void {
      // var obj:TObject = target as TObject;

      // if(mHorizontalLook == 0) value.RemovePower("move", 50);
      // else {
      //   if(!mActive) return;
      //   var power:Object = value.GetPower("move");
      //   if(power == null) {
      //     value.AddPower("move", 30 * mHorizontalLook, 20 * mHorizontalLook);
      //     return;
      //   }
      //   if(power.curr * mHorizontalLook < 0 && power.active) value.RemovePower("move", 50);
      // }
    }

    public var orientation:int;

    public override function process():void {
      if((mActive && mV == 0) && mHorizontalLook == 0) return;
      var obj:TObject = target as TObject;
      var dt:Number = FP.elapsed;
      if(mV < 0) {
        orientation = +1;
        if(mHorizontalLook < 0) mV = Math.max(-28, mV - dt * 90);
        else {
          if(mLastDelta == 0) mV = 0;
          else mV = Math.max(-45, mV + dt * 200);
        }
        if(mHorizontalLook == 0 && mV > 0) mV = 0;
      } else if(mV > 0) {
        orientation = -1;
        if(mHorizontalLook > 0) mV = Math.min(28, mV + dt * 90);
        else {
          if(mLastDelta == 0) mV = 0;
          else mV = Math.min(45, mV - dt * 200);
        }
        if(mHorizontalLook == 0 && mV < 0) mV = 0;
      } else {
        if(mHorizontalLook < 0) mV = Math.max(-28, mV - dt * 90);
        else mV = Math.min(28, mV + dt * 90);
      }
      var dx:int = ((mActive ? mV : 0) + extraPower) * dt * 10;
      if(dx == 0) return;
      var mDx:int = mLastDelta = obj.horizontalLimit(dx);
      obj.HorizontalMove(mDx);
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
    }
  }
}
