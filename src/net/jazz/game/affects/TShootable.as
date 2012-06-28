package net.jazz.game.affects {
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.IBounded;
  import net.jazz.game.core.TRabbit;
  import net.jazz.game.objects.TBullet;

  public class TShootable extends TAffect implements IBounded {

    private var mBounds:TLevel;
    private var mWorker:IWorker;
    private var mIsFlying:Boolean = false;
    private var mDY:Number = 0;
    private var mScore:uint;
    private var mSound:Sfx;

    public function TShootable(worker:IWorker = null, score:uint = 0, sound:Sfx = null) {
      mWorker = worker;
      mScore = score;
      mSound = sound;
    }

    public override function process():void {
      var obj:TObject = target as TObject;
      if(mIsFlying) {
        ++mDY;
        obj.VerticalMove(-2);
        if(mDY > 5) {
          var me:TObject = target as TObject;
          mBounds.remove(me);
        }
        return;
      }
      var bullet:TBullet = obj.collide("bullet", obj.x, obj.y) as TBullet;
      if(!bullet) return;
      bullet.hitted();
      if(mWorker) {
        mWorker.work(TRabbit.instance);
      }
      mIsFlying = true;
      TScore.instance.add(mScore);
      if(mSound) mSound.play();
    }

    public function set bounds(bb:TLevel):void {
      mBounds = bb;
    }
  }
}
