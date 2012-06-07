package net.jazz.game.map {
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;
  import net.flashpunk.masks.Pixelmask;

  import net.jazz.game.core.TLevel;
  import net.jazz.game.objects.TImage;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.objects.TSprite;
  import net.jazz.game.affects.TKiller;
  import net.jazz.game.affects.TCircleWalk;
  import net.jazz.game.affects.TFreeFly;
  import net.jazz.game.affects.TLife;
  import net.jazz.game.affects.TWeaponAmmo;
  import net.jazz.game.affects.TFloating;
  import net.jazz.game.affects.TCollactable;
  import net.jazz.game.affects.TShootable;
  import net.jazz.game.affects.IWorker;
  import net.jazz.game.affects.TRapidFire;
  import net.jazz.game.affects.TCarrot;

  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Rectangle;
  import flash.geom.Matrix;

  public class TBaseMap implements IMap {
    private var mLandscapes:Vector.<TLandscape> = new Vector.<TLandscape>;
    // [Embed(source="../../../../../res/sounds/collect.mp3")]
    // protected static var Collect:Class;
    // [Embed(source="../../../../../res/sounds/carrot.mp3")]
    // protected static var Carrot:Class;
    // [Embed(source="../../../../../res/sounds/rapidfire.mp3")]
    // protected static var RapidFire:Class;
    // [Embed(source="../../../../../res/sounds/shootBig.mp3")]
    // protected static var ShootBig:Class;

    // public static const FG_LAYER:uint = 10;
    // public static const LVL_LAYER:uint = 40;
    // public static const BG_LAYER:uint = 70;
    // public static const HIT_LAYER:uint = 70;
    // public static const HITTR_LAYER:uint = 70;

    // protected var mTilesHit:Class;
    // protected var mTilesTr:Class;
    // protected var mForeground:Class;

    // private var mObjects:Array = [];

    private var mCallback:Function;

    public function TBaseMap() {
      // mForegrounds[0].graphic = new Graphiclist();
      // mForegrounds[0].layer = FG_LAYER;

      // mLevel.graphic = new Graphiclist();
      // mLevel.layer = LVL_LAYER;

      // mBackgrounds[0].graphic = new Graphiclist();
      // mBackgrounds[0].layer = BG_LAYER + 1;
      // mBackgrounds[1].graphic = new Graphiclist();
      // mBackgrounds[1].layer = BG_LAYER;

      // mHitArea.layer = HIT_LAYER;
      // mHitArea.mask = new Masklist();
      // mHitArea.type = "solid";

      // mHitAreaTr.graphic = new Graphiclist();
      // mHitAreaTr.layer = HITTR_LAYER;
      // mHitAreaTr.mask = new Masklist();
      // mHitAreaTr.type = "transparent";
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
    public function install(where:TLevel):void {
      for each(var ls:TLandscape in mLandscapes)
        where.add(ls.build());

      // for each(var obj:TObject in mObjects) where.add(obj);
    }

    protected final function loadDone():void {
      mCallback();
    }

    protected final function addLandscape(ls:TLandscape):void {
      mLandscapes.push(ls);
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