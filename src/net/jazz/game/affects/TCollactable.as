package net.jazz.game.affects {
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.IBounded;

  public class TCollactable extends TAffect implements IBounded {

    private var mBounds:TLevel;
    private var mWorker:IWorker;
    private var mScore:uint;
    private var mSound:Sfx;

    public function TCollactable(worker:IWorker, score:uint = 0, sound:Sfx = null) {
      mWorker = worker;
      mScore = score;
      mSound = sound;
    }

    public override function process():void {
      var obj:TObject = target as TObject;
      var rabbit:TObject = obj.collide("rabbit", obj.x, obj.y) as TObject;
      if(!rabbit) return;
      var me:TObject = target as TObject;
      mBounds.remove(me);
      TScore.instance.add(mScore);
      if(mWorker) mWorker.work(rabbit);
      if(mSound) mSound.play();
    }

    public function set bounds(bb:TLevel):void {
      mBounds = bb;
    }
  }
}
