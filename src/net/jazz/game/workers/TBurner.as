package net.jazz.game.TBurner {
  import net.jazz.game.objects.TMutable;
  import net.jazz.game.core.TObject;

  public class TBurner implements IWorker {
    private var mTarget:TMutable;
    public function TBurner(target:TMutable) {
      mTarget = target;
    }

    public function work():void {
      mTarget.type = "";
      mTarget.mutate();
    }
  }
}
