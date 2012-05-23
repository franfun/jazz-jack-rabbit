package net.jazz.game.affects {
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TRabbit;

  public class TKiller extends TAffect {
    public override function process():void {
      var obj:TObject = target as TObject;
      var rabbit:TRabbit = obj.collide("rabbit", obj.x, obj.y) as TRabbit;
      if(rabbit) (rabbit.getAffect(TRabbitLife) as TRabbitLife).hit();
    }
  }
}
