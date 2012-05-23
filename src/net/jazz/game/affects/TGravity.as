package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.IAffectable;

  /**
   * Implents pure jazz control - no device specific data.
   */
  public class TGravity extends TAffect {

    public var g:Number = 40;
    public var maxFallSpeed:Number = 150;
    public var v:Number = 0;
    public var active:Boolean = true;
    public var moved:Boolean = false;

    public function TGravity():void {
    }

    public function fire(power:Number):void {
      v = power;
    }

    public function Speed():Number {
      return v;
    }

    public override function process():void {
      moved = false;
      var obj:TObject = target as TObject;
      v += active ? g * FP.elapsed : 0;
      var dy:int = v;
      if(dy == 0) return;
      v = obj.verticalLimit(dy);
      moved = v == dy;
      if(v > maxFallSpeed) v = maxFallSpeed;
      obj.VerticalMove(v);
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
    }
  }
}