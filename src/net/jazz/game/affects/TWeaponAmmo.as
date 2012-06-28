package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.IBounded;

  public class TWeaponAmmo extends TAffect implements IWorker {
    private var mType:uint;
    private var mAmmount:uint;

    public function TWeaponAmmo(type:uint, amm:uint) {
      mType = type;
      mAmmount = amm;
    }

    public function work(target:IAffectable):void {
      var rabbit:TObject = target as TObject;
      (rabbit.getAffect(TShoot) as TShoot).addAmmo(mType, mAmmount);
    }
  }
}
