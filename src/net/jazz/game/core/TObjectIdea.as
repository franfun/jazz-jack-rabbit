package net.jazz.game.core {
  import flash.geom.Rectangle;

  import net.jazz.game.data.TProperties;
  import net.jazz.game.core.TGraphic;
  import net.jazz.game.core.TAffectHive;

  import net.flashpunk.Entity;
  import net.flashpunk.Graphic;

  public class TObjectIdea {
    public static const PROP_MASK:String = "g-hitbox";
    public static const PROP_X:String = "x";
    public static const PROP_Y:String = "y";
    public static const PROP_SPELLS_GROUP:String = "spells";

    private var mX:Number;
    private var mY:Number;
    private var mHitbox:Rectangle;
    private var mSpells:TProperties;
    private var mGraphic:TGraphic;
    private var mLayerID:uint;

    public function set layerID(id:uint):void { mLayerID = id; }

    public function TObjectIdea(g:TGraphic, props:TProperties) {
      mSpells = props.removeGroup(PROP_SPELLS_GROUP);
      mX = Number(props.find(PROP_X));
      mY = Number(props.find(PROP_Y));
      if(props.keys.indexOf(PROP_MASK) >= 0) {
        var r:Array = props.remove(PROP_MASK).split(",");
        mHitbox = new Rectangle(r[0], r[1], r[2], r[3]);
      }
      mGraphic = g;
    }

    public function build(affects:TAffectHive):Entity {
      var e:TObject = new TObject(mX, mY, mGraphic.build());
      trace("Building object....");

      if(mHitbox) {
        e.setHitbox(mHitbox.x, mHitbox.y, mHitbox.width, mHitbox.height);
        e.y -= mHitbox.height;
      }

      for each(var key:String in mSpells.keys) {
          trace("+++++ Adding affect " + key);
        if(mSpells.groups.indexOf(key) >= 0) {
          var g:TProperties = mSpells.findGroup(key);
          var affect:TAffect = affects.getByName(key);
          // affect.setProperties(g);
          e.addAffect(affect);
          continue;
        }
        var s:String = String(key);
        e.addAffect(affects.getByName(s));
      }
      return e;
    }
  }
}