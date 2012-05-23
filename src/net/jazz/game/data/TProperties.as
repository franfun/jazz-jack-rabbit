package net.jazz.game.data {

  public class TProperties {
    private var mGroups:Vector.<String> = new Vector.<String>();
    private var mKeys:Vector.<String> = new Vector.<String>();
    private var mSettings:Object = new Object();

    public function TProperties(node:XML = null) {
      if(!node) return;
      for each(var pr:XML in node.property)
        add(pr.@name, pr.@value);
    }

    public function add(name:String, value:Object):void {
      if(name.indexOf("/") < 0) {
        if(mKeys.indexOf(name) < 0) mKeys.push(name);
        if(mGroups.indexOf(name) < 0) {
          mSettings[name] = value;
          if(value is TProperties) mGroups.push(name);
          return;
        }
        (mSettings[name] as TProperties).value = value;
        return;
      }
      var bare:String = name.substr(0, name.indexOf("/"));
      var res:String = name.substr(name.indexOf("/") + 1);
      if(mGroups.indexOf(bare) < 0) {
        mGroups.push(bare);
        if(mKeys.indexOf(bare) < 0) mKeys.push(bare);
        var ob:TProperties = new TProperties;
        if(mSettings.hasOwnProperty(bare)) ob.value = mSettings[bare];
        mSettings[bare] = ob;
        ob.add(res, value);
        return;
      }
      mSettings[bare].add(res, value);
    }

    public function get value():Object {
      return mSettings[""];
    }

    public function set value(v:Object):void {
      mSettings[""] = v;
    }

    public function removeGroup(name:String):TProperties {
      if(mGroups.indexOf(name) < 0) return null;
      mGroups.splice(mGroups.indexOf(name), 1);
      mKeys.splice(mKeys.indexOf(name), 1);
      var gr:TProperties = mSettings[name];
      delete mSettings[name];
      return gr;
    }

    public function remove(name:String):Object {
      mKeys.splice(mKeys.indexOf(name), 1);
      if(mGroups.indexOf(name) >= 0)
        mGroups.splice(mGroups.indexOf(name), 1);
      var res:Object = find(name);;
      delete mSettings[name];
      return res;
    }

    public function get groups():Vector.<String> {
      return mGroups;
    }

    public function get keys():Vector.<String> {
      return mKeys;
    }

    public function find(name:String):Object {
      if(mGroups.indexOf(name) >= 0) return mSettings[name].value;
      return mSettings[name];
    }

    public function findGroup(name:String):TProperties {
      if(mGroups.indexOf(name) < 0) return null;
      return mSettings[name];
    }
  }
}