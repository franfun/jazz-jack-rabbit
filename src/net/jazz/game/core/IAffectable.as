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
    function addAffect(affect:TAffect):void;

    /**
     * Remove affect from the list
     *
     * @param affect TAffect Affect to removex
     */
    function removeAffect(affect:TAffect):void;

    /**
     * Finds if there is an active affect of this type
     *
     * @param affect class which has to extend TAffect to find
     */
    function hasAffect(affect:Class):Boolean;

    /**
     * Finds an active affect of this type
     *
     * @param affect class which has to extend TAffect to find
     */
    function getAffect(affect:Class):TAffect;

    /**
     * Finds all affects of this type
     *
     * @param affect usually interface
     */
    function getAllAffects(affect:Class):Array;

    function prepare():void;
    function process():void;
    function finish():void;

    function reset():void;
  }
}