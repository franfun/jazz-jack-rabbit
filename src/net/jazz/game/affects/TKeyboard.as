package net.jazz.game.affects {
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  import net.flashpunk.FP;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;

  public class TKeyboard extends TAffect {
    private var mControl:TControl;
    private var mJump:TJump;
    private var mShoot:TShoot;

    public function TKeyboard(control:TControl, jump:TJump = null, shoot:TShoot = null) {
      mControl = control;
      mJump = jump;
      mShoot = shoot;
    }

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    public override function prepare():void {
      // var data:TKeyboardData = GetData(target) as TKeyboardData;

      if(Input.pressed(Key.RIGHT)) mControl.StartRight();
      if(Input.released(Key.RIGHT)) mControl.StopRight();

      if(Input.pressed(Key.LEFT)) mControl.StartLeft();
      if(Input.released(Key.LEFT)) mControl.StopLeft();

      if(mJump) {
        if(Input.pressed(Key.UP)) mJump.StartJump();
        if(Input.released(Key.UP)) mJump.StopJump();
      }

      if(mShoot) {
        if(Input.pressed(Key.SPACE)) mShoot.StartShoot();
        if(Input.released(Key.SPACE)) mShoot.StopShoot();

        if(Input.pressed(Key.CONTROL)) mShoot.nextWeapon();
      }
    }
  }
}
