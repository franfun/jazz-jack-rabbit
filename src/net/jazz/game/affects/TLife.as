package net.jazz.game.affects {
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.IColorizable;
  import net.jazz.game.core.IBounded;
  import net.jazz.game.objects.TBoom;

  public class TLife extends TAffect implements IBounded {
    private var mBounds:TLevel;
    private var mLife:uint;

    public function TLife(am:uint) {
      mLife = am;
    }

    public function hit():void {
      var enemy:TObject = target as TObject;
      --mLife;
      if(mLife > 0) {
        enemy.addAffect(new TBlink(0xFFFFFF));
        return;
      }
      TScore.instance.add(30);
      mBounds.remove(enemy);
      emitBoom(-20, -10, enemy.x, enemy.y);
      emitBoom(-15, -15, enemy.x, enemy.y);
      emitBoom(-5, -20, enemy.x, enemy.y);
      emitBoom(+20, -10, enemy.x, enemy.y);
      emitBoom(+15, -15, enemy.x, enemy.y);
    }

    private function emitBoom(dx:Number, dy:Number, x:Number, y:Number):void {
      dx +=  5 - Math.random() * 10;
      dy +=  5 - Math.random() * 10;
      var boom:TBoom = mBounds.create(TBoom) as TBoom;
      boom.init(dx, dy);
      boom.bounds = mBounds;
      boom.x = x;
      boom.y = y;
    }

    public function set bounds(bb:TLevel):void {
      mBounds = bb;
    }
  }
}
