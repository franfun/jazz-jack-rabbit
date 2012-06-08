package net.jazz.game.core {
  import flash.display.BitmapData;
  import flash.geom.Rectangle;
  import flash.geom.Matrix;

  import net.flashpunk.World;
  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Graphiclist;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.graphics.Stamp;
  import net.flashpunk.masks.Masklist;
  import net.flashpunk.masks.Pixelmask;

  /**
   * Takes care of all the processes in single game
   */
  public class TLevel extends World implements IAffectHub {
    public static const JAZZ_LAYER:uint = 15;
    public static const ELEMENT_LAYER:uint = 20;
    public static const OBJECT_LAYER:uint = 30;

    private var mJazz:TRabbit;

    private var mAffectables:Array = [];

    private var mToDelete:Array = [];
    private var mWorking:Boolean = false;

    private var mMisc:TMisc;

    override public function update():void
    {
      super.update();

      mWorking = true;
      for each(var af:IAffectable in mAffectables)
        if(mToDelete.indexOf(af) < 0) af.prepare();
      for each(af in mAffectables)
        if(mToDelete.indexOf(af) < 0) af.process();
      for each(af in mAffectables)
        if(mToDelete.indexOf(af) < 0) af.finish();
      mWorking = false;

      for each(af in mToDelete) removeAffectable(af);
      mToDelete = [];

      super.update();
    }

    public function get misc():TMisc { return mMisc; }

    public function addMisc(misc:TMisc):void {
      add(misc);
      mMisc = misc;
      mMisc.layer = 0;
    }

    /**
     * Adds object to the stage.
     *
     * @param obj TObject object to add
     */
    public override function add(obj:Entity):Entity {
      var res:Entity = super.add(obj);
      // obj.layer = OBJECT_LAYER;
      if(obj is IAffectable) addAffectable(obj as IAffectable);
      return res;
    }

    public override function recycle(obj:Entity):Entity {
      removeAffectable(obj as IAffectable);
      return super.recycle(obj);
    }

    public override function remove(obj:Entity):Entity {
      if(obj is IAffectable) removeAffectable(obj as IAffectable);
      return super.remove(obj);
    }

    /**
     * This guy is special!
     *
     * @param jazz TRabbit The One.
     */
    public function AddJazz(jazz:TRabbit):void {
      mJazz = jazz;
      add(jazz);
      jazz.layer = JAZZ_LAYER;
    }

    public function get jazz():TRabbit { return mJazz; }

    //----------------------------------------
    //-- Affectable section
    //----------------------------------------

    public function get affectables():Array {
      return mAffectables;
    }

    public function removeAffectable(aff:IAffectable):void {
      if(mAffectables.indexOf(aff) < 0) return;
      if(mWorking) {
        if(mToDelete.indexOf(aff) >= 0) return;
        mToDelete.push(aff);
        return;
      }
      mAffectables.splice(mAffectables.indexOf(aff), 1);
    }

    public function addAffectable(aff:IAffectable):void {
      if(mAffectables.indexOf(aff) >= 0) throw new Error("Affectable added twise");
      var bounded:Array = aff.getAllAffects(IBounded);
      for each(var af:IBounded in bounded)
        af.bounds = this;
      mAffectables.push(aff);
    }

    public function ProcessAffectables():void {

    }

  }
}