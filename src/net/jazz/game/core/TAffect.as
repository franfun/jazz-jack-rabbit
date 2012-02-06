package net.jazz.game.core {

  import flash.utils.Dictionary;

  /**
   * Basic affect interface.
   */
  public class TAffect {
    /**
     * Objects who are processed by this affect.
     */
    private var mTargets:Array = [];
    /**
     * Data associated with each target.
     */
    private var mData:Dictionary = new Dictionary;

    /**
     * Before applying filter.
     *
     * @param target IAffectable Who to affect
     */
    public function Prepare(target:IAffectable):void {
    }

    /**
     * Apply filter.
     *
     * @param target IAffectable Who to affect
     */
    public function Do(target:IAffectable):void {
    }

    /**
     * After applying filter.
     *
     * @param target IAffectable Who to affect
     */
    public function Finish(target:IAffectable):void {
    }

    /**
     * Register this target to be affected
     *
     * @param target IAffectable New target
     */
    public function Register(target:IAffectable):void {
      mTargets.push(target);
    }

    /**
     * Register this target to be affected
     *
     * @param target IAffectable New target
     */
    public function Unregister(target:IAffectable):void {
      mTargets.splice(mTargets.indexOf(target), 1);
      DelData(target);
    }

    public function GetData(target:IAffectable):IAffectData {
      return mData[target];
    }

    protected function SetData(target:IAffectable, data:IAffectData):void {
      DelData(target);
      mData[target] = data;
    }

    private function DelData(target:IAffectable):void {
      delete mData[target];
    }
  }
}