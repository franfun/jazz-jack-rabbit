package net.jazz.game.core {

  /**
   * Affect list routing implementation.
   */
  public interface IAffectable {
    /**
     * Affects getter
     */
    function get currentAffects():Array;

    /**
     * Add affect to the list
     *
     * @param affect TAffect Affect to add
     */
    function AddAffect(affect:TAffect):void;

    /**
     * Remove affect from the list
     *
     * @param affect TAffect Affect to removex
     */
    function RemoveAffect(affect:TAffect):void;

    function Prepare():void;
    function Do():void;
    function Finish():void;
  }
}