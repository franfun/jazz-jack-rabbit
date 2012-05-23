package net.jazz.game.core {

  /**
   * Contains and processes affectables.
   */
  public interface IAffectHub {
    /**
     * Get list current affectables.
     */
    function get affectables():Array;

    /**
     * Processes all affectables.
     */
    function ProcessAffectables():void;

    /**
     * Add affectable.
     *
     * @param aff IAffectable Object to add
     */
    function addAffectable(aff:IAffectable):void;

    /**
     * Remove affectable.
     *
     * @param aff IAffectable Object to remove
     */
    function removeAffectable(aff:IAffectable):void;
  }
}