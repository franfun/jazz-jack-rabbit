package net.jazz.game.map {
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;
  import net.flashpunk.masks.Pixelmask;

  import net.jazz.game.core.TLevel;
  import net.jazz.game.objects.TImage;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TObjectIdea;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TAffectHive;

  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Rectangle;
  import flash.geom.Matrix;

  public class TBaseMap implements IMap {
    private var mLandscapes:Vector.<TLandscape> = new Vector.<TLandscape>;
    private var mObjects:Array = [];
    // [Embed(source="../../../../../res/sounds/collect.mp3")]
    // protected static var Collect:Class;
    // [Embed(source="../../../../../res/sounds/carrot.mp3")]
    // protected static var Carrot:Class;
    // [Embed(source="../../../../../res/sounds/rapidfire.mp3")]
    // protected static var RapidFire:Class;
    // [Embed(source="../../../../../res/sounds/shootBig.mp3")]
    // protected static var ShootBig:Class;

    // private var mObjects:Array = [];

    private var mCallback:Function;

    public function TBaseMap() {
    }

    public final function load(callback:Function):void {
      mCallback = callback;
      // TODO: check if map is loaded
      doLoad();
    }

    /**
     * Install level into level.
     *
     * @param TLevel where Level to install into.
     */
    public function install(where:TLevel, affectHive:TAffectHive):void {
      for each(var ls:TLandscape in mLandscapes)
        where.add(ls.build());

      for each(var obj:TObjectIdea in mObjects)
        if(obj) where.add(obj.build(affectHive));
    }

    protected final function loadDone():void {
      mCallback();
    }

    protected final function addLandscape(ls:TLandscape):void {
      mLandscapes.push(ls);
    }

    protected final function addObjects(objs:Array):void {
      objs.unshift(mObjects.length);
      objs.unshift(0);
      mObjects.splice.apply(mObjects, objs);
    }

    protected function doLoad():void {
      throw new Error("TBaseMap::doLoad needs to be implemented in derivative class");
    }

    // protected function addObject(obj:Entity):void {
    //   mObjects.push(obj);
    // }

    // protected function addEnemy(obj:TObject, moveType:String, moveLength:uint, x:Number, y:Number):void {
    //   obj.x = x;
    //   obj.y = y - obj.height;
    //   obj.type = "enemy";
    //   if(moveType == "circle") obj.addAffect(new TCircleWalk);
    //   else if(moveType == "free") obj.addAffect(new TFreeFly(moveLength * 32));
    //   obj.addAffect(new TKiller);
    //   obj.addAffect(new TLife(3));
    //   addObject(obj);
    // }

    // protected function addMiscObject(type:String, x:Number, y:Number):void {
    //   var ms:TImage;
    //   var af:TAffect;
    //   if(type == "rfmissile" || type == "launcher" || type == "blaster" || type == "carrot" || type == "fire") {
    //     var sfx:Sfx;
    //     switch(type) {
    //     case "rfmissile":
    //       ms = TImage.rfmissile;
    //       af = new TWeaponAmmo(2, 2);
    //       sfx = new Sfx(Collect);
    //       break;
    //     case "launcher":
    //       ms = TImage.launcher;
    //       af = new TWeaponAmmo(3, 2);
    //       sfx = new Sfx(Collect);
    //       break;
    //     case "blaster":
    //       ms = TImage.blaster;
    //       af = new TWeaponAmmo(1, 2);
    //       sfx = new Sfx(Collect);
    //       break;
    //     case "carrot":
    //       ms = TImage.carrot;
    //       af = new TCarrot;
    //       sfx = new Sfx(Carrot);
    //       break;
    //     case "fire":
    //       ms = TImage.fire;
    //       af = new TRapidFire;
    //       sfx = new Sfx(RapidFire);
    //       break;
    //     }
    //     ms.addAffect(new TFloating);
    //     ms.addAffect(af);
    //     ms.addAffect(new TCollactable(af as IWorker, 150, sfx));
    //   } else if(type == "bigrfmissile" || type == "biglauncher" || type == "bigblaster") {
    //     switch(type) {
    //     case "bigrfmissile":
    //       ms = TImage.bigrfmissile;
    //       af = new TWeaponAmmo(2, 14);
    //       break;
    //     case "biglauncher":
    //       ms = TImage.biglauncher;
    //       af = new TWeaponAmmo(3, 14);
    //       break;
    //     case "bigblaster":
    //       ms = TImage.bigblaster;
    //       af = new TWeaponAmmo(1, 14);
    //       break;
    //     }
    //     ms.addAffect(af);
    //     ms.addAffect(new TShootable(af as IWorker, 10, new Sfx(ShootBig)));
    //   }
    //   ms.x = x;
    //   ms.y = y - 32;
    //   addObject(ms);
    // }
  }
}