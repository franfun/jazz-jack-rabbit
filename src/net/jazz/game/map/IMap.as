package net.jazz.game.map {
  // import net.flashpunk.World;
  import net.flashpunk.Entity;

  import net.jazz.game.core.TLevel;

  /**
   * Defines main interface for map instance.
   */
  public interface IMap {
    function load(callback:Function):void;
    function install(where:TLevel):void;
  }
}