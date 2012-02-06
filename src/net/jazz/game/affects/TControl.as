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
    private var mLeftStarted:Boolean = false;
    private var mRightStarted:Boolean = false;
    private var mHorizontalLook:int = 0;
    private var mVerticalLook:int = 0;

    private var mBounds:TLevel;

    public function TControl(bounds:TLevel):void {
      mBounds = bounds;
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

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    public override function Prepare(target:IAffectable):void {
      var data:TControlData = GetData(target) as TControlData;
      if(mHorizontalLook == 0) data.RemovePower("move");
      else data.AddPower("move", CONFIG::JazzAcceleration * mHorizontalLook, CONFIG::JazzMaxSpeed * mHorizontalLook);
    }

    public override function Do(target:IAffectable):void {
      var obj:TObject = target as TObject;
      var data:TControlData = GetData(target) as TControlData;
      data.Elapsed(FP.elapsed);
      var dx:int = data.value;
      FP.console.log(dx);
      if(dx == 0) return;
      var mDx:int = mBounds.HorizontalLimit(obj, dx);
      FP.console.log("--- " + mDx);
      obj.HorizontalMove(mDx);
    }

    public override function Finish(target:IAffectable):void {
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
      SetData(target, new TControlData);
    }
  }
}