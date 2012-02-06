package net.jazz.game.affects.data {
  import net.jazz.game.core.IAffectData;

  public class TControlData implements IAffectData {
    private var mPowers:Array = [];

    public function TControlData():void {
    }

    public function Elapsed(time:Number):void {
      var toDel:Array = [];
      for(var key:String in mPowers) {
        var newV:int = mPowers[key].curr + int(mPowers[key].acc * time);
        if(mPowers[key].curr != 0 && newV * mPowers[key].curr <= 0) {
          toDel.push(key);
          continue;
        }
        mPowers[key].curr = mPowers[key].acc > 0 ? Math.min(mPowers[key].max, newV) : Math.max(mPowers[key].max, newV);
      }

      for each(key in toDel) delete mPowers[key];
    }

    public function get value():int {
      var sp:int = 0;
      for(var key:String in mPowers)
        sp += mPowers[key].curr;
      return sp;
    }

    public function AddPower(name:String, acc:int, max:int):void {
      if(mPowers[name] == null) mPowers[name] = {acc: 0, max: 0, curr: 0, active:true};
      mPowers[name].acc = acc;
      mPowers[name].max = max;
    }

    public function RemovePower(name:String, acc:int = 0):void {
      if(!mPowers[name]) return;
      if(acc == 0) acc = -mPowers[name].acc;
      mPowers[name].acc = acc;
      mPowers[name].max *= -1;
    }
  }
}