package net.jazz.game.core {
  import com.github.dimalev.picocontainer.TDefaultPicoContainer;

  /**
   * Agregates and builds TObject affects based on names.
   */
  public class TAffectHive {
    /**
     * Agregated dependencies injector.
     */
    private var mBuilder:TDefaultPicoContainer = new TDefaultPicoContainer;
    /**
     * Local name->Class map
     */
    private var mRegister:Object = new Object;

    private var mParent:TAffectHive;

    protected function get builder():TDefaultPicoContainer { return mBuilder; }

    public function TAffectHive(parent:TAffectHive = null) {
      if(parent) {
        mBuilder.parent = parent.builder;
        mParent = parent;
      }
    }

    public function pushAll(affects:Object):void {
      for(var key:String in affects)
        push(key, affects[key]);
    }

    public function push(name:String, affect:Class):void {
      trace("++ register " + name + " :: " + affect);
      mRegister[name] = affect;
      mBuilder.addComponent(affect);
    }

    public function getByName(name:String):TAffect {
      try {
        var aff:TAffect = mBuilder.getComponent(mRegister[name]) as TAffect;
        if(!aff && mParent) aff = mParent.getByName(name);
        return aff;
      } catch(e:Error) {
        trace("!!!! Error while finding affect. name = " + name);
        throw e;
      }
      return null;
    }
  }
}