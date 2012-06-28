package net.jazz.game.data {

  public class TProperties {
    private var mGroups:Vector.<String> = new Vector.<String>();
    private var mKeys:Vector.<String> = new Vector.<String>();
    private var mSettings:Object = new Object();

    public function TProperties(node:XML = null) {
      if(!node) return;
      for each(var pr:XML in node.property)
        add(pr.@name, pr.@value.toString());
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

    public function fromAttributes(node:XML, skipList:Vector.<String> = null):void {
      for each(var attr:XML in node.attributes()) {
        var name:String = attr.name();
        if(skipList != null && skipList.indexOf(name) >= 0) continue;
        add(name, String(attr));
      }
    }

    public function get value():Object {
      return mSettings[""];
    }

    public function set value(v:Object):void {
      mSettings[""] = v;
    }

    public function removeGroup(name:String, def:TProperties = null):TProperties {
      if(mGroups.indexOf(name) < 0) return def;
      var gr:TProperties = findGroup(name, def);
      mGroups.splice(mGroups.indexOf(name), 1);
      mKeys.splice(mKeys.indexOf(name), 1);
      delete mSettings[name];
      return gr;
    }

    public function remove(name:String, def:Object = null):Object {
      var res:Object = def;
      if(mGroups.indexOf(name) >= 0) throw new Error("TProperties.remove: tryed to remove group!");
      if(mKeys.indexOf(name) >= 0) {
        res = find(name, def); // only if this was not a group
       mKeys.splice(mKeys.indexOf(name), 1);
       }
      delete mSettings[name];
      return res;
    }

    public function get groups():Vector.<String> {
      return mGroups;
    }

    public function get keys():Vector.<String> {
      return mKeys;
    }

    public function find(name:String, def:Object = null):Object {
      if(mGroups.indexOf(name) >= 0) return mSettings[name].value;
      if(mKeys.indexOf(name) >= 0) return mSettings[name];
      return def;
    }

    public function findGroup(name:String, def:TProperties = null):TProperties {
      if(mGroups.indexOf(name) < 0) return def;
      return mSettings[name];
    }

    public function clone():TProperties {
      var res:TProperties = new TProperties();
      res.value = value;
      for each(var key:String in mKeys) {
        if(mGroups.indexOf(key) >= 0) {
          res.add(key, findGroup(key).clone());
          continue;
        }
        var value:Object = find(key);
        try {
          res.add(key, value.clone());
        } catch(e:Error) {
          res.add(key, value);
        }
      }
      return res;
    }

    public function extend(other:TProperties):void {
      other = other.clone();
      for each(var key:String in other.keys)
        if(other.groups.indexOf(key) >= 0)
          add(key, other.findGroup(key));
        else add(key, other.find(key));
    }
  }
}