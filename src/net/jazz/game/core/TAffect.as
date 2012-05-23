package net.jazz.game.core {

  import flash.utils.Dictionary;

  /**
   * Basic affect interface.
   */
  public class TAffect {
    private var mTarget:IAffectable;
    /**
     * Before applying filter.
     *
     * @param target IAffectable Who to affect
     */
    public function prepare():void {
    }

    /**
     * Apply filter.
     *
     * @param target IAffectable Who to affect
     */
    public function process():void {
    }

    /**
     * After applying filter.
     *
     * @param target IAffectable Who to affect
     */
    public function finish():void {
    }

    protected function get target():IAffectable { return mTarget; }

    /**
     * Register this target to be affected
     *
     * @param target IAffectable New target
     */
    public function Register(target:IAffectable):void {
      mTarget = target;
    }

    /**
     * Remove this target to be affected
     *
     * @param target IAffectable target
     */
    public function Unregister(target:IAffectable):void {
      mTarget = null;
    }
  }
}