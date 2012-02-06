package net.jazz.game.core {
  import net.flashpunk.Entity;

  /**
   * Map object.
   */
  public class TObject extends Entity implements IAffectable {
    /**
     * Affects list
     */
    protected var mAffects:Array = [];

    public function TObject() {
      super();
    }

    public function HorizontalMove(dx:int, omitSolid:Boolean = false):void {
      x += dx;
      if(omitSolid) return;
      var Dy:int = 0;
      while(collide("solid", x, y - Dy)) Dy += 1;
      y -= Dy;
    }

    //-----------------------------------------
    //---- IAffectable interface related code
    //-----------------------------------------

    public function Prepare():void {
      for each(var af:TAffect in mAffects) af.Prepare(this);
    }
    public function Do():void {
      for each(var af:TAffect in mAffects) af.Do(this);
    }
    public function Finish():void {
      for each(var af:TAffect in mAffects) af.Finish(this);
    }

    public function get currentAffects():Array {
      return mAffects;
    }

    public function AddAffect(affect:TAffect):void {
      mAffects.push(affect);
      affect.Register(this);
    }

    public function RemoveAffect(affect:TAffect):void {
      affect.Unregister(this);
      mAffects.splice(mAffects.indexOf(affect), 1);
    }
  }
}