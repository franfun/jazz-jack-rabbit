package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.IAffectable;

  public class TCameraWatch extends TAffect {
    public static const MAX_SPEED:Number = 10;
    public override function process():void {
      var target:TObject = this.target as TObject;
      var nx:Number = Math.max(0, target.x - 160);
      var dx:Number = nx - FP.camera.x;
      var ny:Number = Math.max(0, target.y - 100);
      var dy:Number = ny - FP.camera.y;
      if(dx > MAX_SPEED) nx = FP.camera.x + MAX_SPEED;
      else if(dx < -MAX_SPEED) nx = FP.camera.x - MAX_SPEED;
      if(dy > MAX_SPEED) ny = FP.camera.y + MAX_SPEED;
      else if(dy < -MAX_SPEED) ny = FP.camera.y - MAX_SPEED;
      FP.camera.x = nx;
      FP.camera.y = ny;
    }
  }
}