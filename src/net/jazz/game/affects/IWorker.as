package net.jazz.game.affects {
  import net.jazz.game.core.IAffectable;

  public interface IWorker {
    function work(target:IAffectable):void;
  }
}
