package net.jazz.game.affects.data {
  import net.flashpunk.FP;

  import net.jazz.game.core.IAffectData;

  public class TControlData implements IAffectData {
    private var mPowers:Array = [];

    public function TControlData():void {
    }

    public function Elapsed(time:Number):void {
      var toDel:Array = [];
      for(var key:String in mPowers) {
        var newV:Number = mPowers[key].curr + Number(mPowers[key].acc * time);
        if(mPowers[key].curr != 0 && newV * mPowers[key].curr <= 0) {
          toDel.push(key);
          continue;
        }
        mPowers[key].curr = mPowers[key].acc > 0 ? Math.min(mPowers[key].max, newV) : Math.max(mPowers[key].max, newV);
      }

      for each(key in toDel) this.KillPower(key);
    }

    public function get value():Number {
      var sp:Number = 0;
      for(var key:String in mPowers) {
        sp += mPowers[key].curr;
      }
      return sp;
    }

    public function meldPower(name1:String, name2:String):void {
      if(mPowers[name1] == null) return;
      mPowers[name2].curr += mPowers[name1].curr;
      KillPower(name1);
    }

    public function GetPower(name:String):Object {
      return mPowers[name];
    }

    public function AddPower(name:String, acc:Number, max:Number):Object {
      if(mPowers[name] == null) mPowers[name] = {acc: 0, max: 0, curr: 0, active:true};
      mPowers[name].acc = acc;
      mPowers[name].max = max;
      return mPowers[name];
    }

    public function KillAllPowers():void {
      mPowers = [];
    }

    public function KillPower(name:String):void {
      if(!mPowers[name]) return;
      delete mPowers[name];
    }

    public function RemovePower(name:String, acc:Number = 0):void {
      if(!mPowers[name]) return;
      if(!mPowers[name].active) return;
      if(acc == 0) acc = -mPowers[name].acc;
      else acc = Math.abs(acc) * (mPowers[name].curr > 0 ? -1 : +1)
      mPowers[name].acc = acc;
      mPowers[name].max *= -1;
      mPowers[name].active = false;
    }
  }
}