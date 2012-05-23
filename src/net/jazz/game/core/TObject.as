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
      var bb:Boolean = collide("transparent", x, y) == null && collide("transparent", x, y + 1) != null;
      x += dx;
      if(omitSolid) return;
      var Dy:int = 0;
      while(collide("solid", x, y - Dy) || (bb && collide("transparent", x, y - Dy))) Dy += 1;
      y -= Dy;
    }

    public function VerticalMove(dy:int):void {
      y += dy;
    }

    public function isFalling():Boolean {
      var isOnTr:Boolean = this.collide("transparent", this.x, this.y) != null;
      var isOverTr:Boolean = this.collide("transparent", this.x, this.y+1) != null;
      return !(this.collide("solid", this.x, this.y+1) || (!isOnTr && isOverTr));
    }

    public function horizontalLimitStrict(max:int):int {
      var dx:int = max / Math.abs(max);
      var left:int = dx > 0 ? this.width + 1 : -1;
      for(var i:int = max; i != 0; i -= dx) {
        if(this.world.collidePoint("solid", this.x + left + i, this.y + 6 + this.height) &&
           !this.world.collidePoint("solid", this.x + left + i, this.y + this.height - 1)) break;
        if(this.world.collidePoint("transparent", this.x + left + i, this.y + 6 + this.height) &&
           !this.world.collidePoint("transparent", this.x + left + i, this.y + this.height - 1)) break;
      }
      return i;
    }

    public function horizontalLimit(max:int, climb:Boolean = true):int {
      var dx:int = max / Math.abs(max);
      if(climb)
        for(var i:int = max; i != 0; i -= dx) {
          var Dy:int = 0;
          var maxDY:int = 12;//Math.abs(8*i);
          while(this.collide("solid", this.x + i, this.y - Dy)
                // this.collide("transparent", this.x + i, this.y - Dy)
                && Dy < maxDY) Dy += 1;
          if(Dy < maxDY) break;
        }
      else
        for(i = max; i != 0 && this.collide("solid", this.x + i, this.y); i -= dx) {}
      return i;
    }

    public function verticalLimit(max:int):int {
      var dy:int = max / Math.abs(max);
      var collidesTr:Boolean = this.collide("transparent", this.x, this.y) != null;
      for(var i:int = max; i != 0; i -= dy) {
        if(!this.collide("solid", this.x, this.y + i)) {
          if(dy < 0) break;
          if(!this.collide("transparent", this.x, this.y + i)) break;
          if(collidesTr) break;
        }
      }
      return i;
    }

    //-----------------------------------------
    //---- IAffectable interface related code
    //-----------------------------------------

    public function prepare():void {
      for each(var af:TAffect in mAffects) af.prepare();
    }
    public function process():void {
      for each(var af:TAffect in mAffects) af.process();
    }
    public function finish():void {
      for each(var af:TAffect in mAffects) af.finish();
    }

    public function hasAffect(affect:Class):Boolean {
      for each(var af:TAffect in mAffects)
        if(af is affect) return true;
      return false;
    }

    public function getAffect(affect:Class):TAffect {
      for each(var af:TAffect in mAffects)
        if(af is affect) return af;
      return null;
    }

    public function getAllAffects(affect:Class):Array {
      var res:Array = [];
      for each(var af:TAffect in mAffects)
        if(af is affect) res.push(af);
      return res;
    }

    public function get currentAffects():Array {
      return mAffects;
    }

    public function reset():void {
      throw new Error("NO RESETS FOR OBJECTS!!!!");
    }

    public function addAffect(affect:TAffect):void {
      mAffects.push(affect);
      affect.Register(this);
    }

    public function removeAffect(affect:TAffect):void {
      affect.Unregister(this);
      mAffects.splice(mAffects.indexOf(affect), 1);
    }
  }
}