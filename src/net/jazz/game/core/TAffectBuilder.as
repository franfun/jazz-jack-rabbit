package net.jazz.game.core {
  import com.github.dimalev.picocontainer.TDefaultPicoContainer;

  import net.jazz.game.affects.TControl;
  import net.jazz.game.affects.TGravity;
  import net.jazz.game.affects.TKeyboard;
  import net.jazz.game.affects.TRabbitAnimator;
  import net.jazz.game.affects.TRabbitLife;
  import net.jazz.game.affects.TJump;
  import net.jazz.game.affects.TShoot;
  import net.jazz.game.affects.TCircleWalk;
  import net.jazz.game.affects.TCameraWatch;
  import net.jazz.game.affects.TWeaponChanger;
  import net.jazz.game.affects.TScore;
  import net.jazz.game.affects.TTimer;

  /**
   * Agregates and builds TObject affects based on names.
   */
  public class TAffectBuilder {
    /**
     * Agregated dependencies injector.
     */
    private var mBuilder:TDefaultPicoContainer = new TDefaultPicoContainer;
    /**
     * Local name->Class map
     */
    private var mRegister:Object = new Object;

    public function TAffectBuilder() {
      pushAll({control: TControl,
            gravity: TGravity,
            keyboard: TKeyboard,
            "rabbit-animator": TRabbitAnimator,
            "rabbit-life": TRabbitLife,
            jump: TJump,
            shoot: TShoot,
            score: TScore,
            timer: TTimer,
            "circle-walk": TCircleWalk,
            "camera-watch": TCameraWatch,
            "weapon-changer": TWeaponChanger});
    }

    public function pushAll(affects:Object):void {
      for(var key:String in affects)
        push(key, affects[key]);
    }

    public function push(name:String, affect:Class):void {
      trace("++ register" + name + " :: " + affect);
      mRegister[name] = affect;
      mBuilder.addComponent(affect);
    }

    public function getByName(name:String):TAffect {
      return mBuilder.getComponent(mRegister[name]) as TAffect;
    }
  }
}