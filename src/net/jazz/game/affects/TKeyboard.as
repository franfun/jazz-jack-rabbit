package net.jazz.game.affects {
  import net.flashpunk.utils.Input;
  import net.flashpunk.utils.Key;
  import net.flashpunk.FP;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;

  public class TKeyboard extends TAffect {
    private function FindControl(target:IAffectable, data:TKeyboardData):void {
      for each(var affect:TAffect in target.currentAffects)
        if(affect is TControl) {
          data.control = affect as TControl;
          return;
        }
    }

    //-------------------------------------------------
    //-- TAffect specific implementation
    //-------------------------------------------------
    public override function Prepare(target:IAffectable):void {
      var data:TKeyboardData = GetData(target) as TKeyboardData;
      if(!data.control) {
        FindControl(target, data);
        if(!data.control) {
          return;
        }
      }

      if(Input.pressed(Key.RIGHT)) data.control.StartRight();
      if(Input.released(Key.RIGHT)) data.control.StopRight();

      if(Input.pressed(Key.LEFT)) data.control.StartLeft();
      if(Input.released(Key.LEFT)) data.control.StopLeft();
    }

    public override function Do(target:IAffectable):void {
    }

    public override function Finish(target:IAffectable):void {
    }

    public override function Register(target:IAffectable):void {
      super.Register(target);
      var data:TKeyboardData = new TKeyboardData as TKeyboardData;
      SetData(target, data);
      FindControl(target, data);
    }
  }
}

import net.jazz.game.core.IAffectData;
import net.jazz.game.affects.TControl;

class TKeyboardData implements IAffectData {
  public var control:TControl;
}