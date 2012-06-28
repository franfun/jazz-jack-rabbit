package net.jazz.game.core.graphic {
  import net.jazz.game.core.IConfigurable;
  import net.jazz.game.core.TGraphicSource;
  import net.jazz.game.core.TGraphic;
  import net.jazz.game.data.TProperties;

  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.Graphic;

  import flash.geom.Rectangle;

  public class TSpritemap extends TGraphic implements IConfigurable {
    public static const PROP_ANIM_GROUP:String = "anim";
    public static const PROP_ANIM_FRAMERATE:String = "frame-rate";
    public static const PROP_ANIM_FRAMES:String = "frames";
    public static const PROP_ANIM_REPEAT:String = "repeat";
    public var mask:Rectangle = null;

    private var mAnims:Vector.<TAnimData> = new Vector.<TAnimData>;

    public function TSpritemap(p:TProperties) {
      super(p);
    }

    public override function setProperties(p:TProperties):void {
      super.setProperties(p);

      if(p.groups.indexOf(PROP_ANIM_GROUP) >= 0) {
        var groups:TProperties = p.removeGroup(PROP_ANIM_GROUP);
        while(groups.groups.length > 0) {
          var gname:String = groups.groups[0];
          var gprops:TProperties = groups.removeGroup(gname);
          var frames:Array = gprops.remove(PROP_ANIM_FRAMES).split("-");
          var frameRate:uint = uint(gprops.remove(PROP_ANIM_FRAMERATE, 25));
          var repeat:Boolean = String(gprops.remove(PROP_ANIM_REPEAT, "true")) == "true";
          var animData:TAnimData = new TAnimData(gname, frames[0], frames[1], frameRate, repeat);
          mAnims.push(animData);
        }
      }
    }

    public override function build():Graphic {
      var res:Spritemap = new Spritemap(source.bitmap, tilewidth, tileheight);
      for each(var anim:TAnimData in mAnims)
        anim.apply(res);
      return res;
    }
  }
}

import net.flashpunk.graphics.Spritemap;

class TAnimData {
  public var name:String;
  public var frames:Array;
  public var frameRate:uint;
  public var repeat:Boolean;

  public function TAnimData(name:String, firstframe:uint, lastframe:uint, frameRate:uint, repeat:Boolean) {
    var frames:Array = [];
    if(firstframe > lastframe) {
      var swap:uint = firstframe;
      firstframe = lastframe;
      lastframe = swap;
    }
    for(var i:uint = firstframe; i <= lastframe; ++i) frames.push(i);

    this.name = name;
    this.frames = frames;
    this.frameRate = frameRate;
    this.repeat = repeat;
  }

  public function apply(s:Spritemap):void {
    s.add(name, frames, frameRate, repeat);
  }
}