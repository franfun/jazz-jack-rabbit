package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.IBounded;
  import net.jazz.game.objects.TSprite;

  public class TRapidFire extends TAffect implements IWorker {
    public function work(target:IAffectable):void {
      var rabbit:TObject = target as TObject;
      (rabbit.getAffect(TShoot) as TShoot).rapid();
    }
  }
}
