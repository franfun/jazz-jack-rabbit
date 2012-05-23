package net.jazz.game.map {
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;
  import net.flashpunk.graphics.Graphiclist;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.masks.Masklist;
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
    [Embed(source="../../../../../res/sounds/collect.mp3")]
    protected static var Collect:Class;
    [Embed(source="../../../../../res/sounds/carrot.mp3")]
    protected static var Carrot:Class;
    [Embed(source="../../../../../res/sounds/rapidfire.mp3")]
    protected static var RapidFire:Class;
    [Embed(source="../../../../../res/sounds/shootBig.mp3")]
    protected static var ShootBig:Class;

    public static const FG_LAYER:uint = 10;
    public static const LVL_LAYER:uint = 40;
    public static const BG_LAYER:uint = 70;
    public static const HIT_LAYER:uint = 70;
    public static const HITTR_LAYER:uint = 70;

    protected var mTilesHit:Class;
    protected var mTilesTr:Class;
    protected var mForeground:Class;

    private var mForegrounds:Array = [new Entity];
    private var mLevel:Entity = new Entity();
    private var mBackgrounds:Array = [new Entity, new Entity];
    private var mHitArea:Entity = new Entity();
    private var mHitAreaTr:Entity = new Entity();

    private var mObjects:Array = [];
    protected var mLevelData:Array = [];

    private var mCallback:Function;

    public function TBaseMap() {
      mForegrounds[0].graphic = new Graphiclist();
      mForegrounds[0].layer = FG_LAYER;

      mLevel.graphic = new Graphiclist();
      mLevel.layer = LVL_LAYER;

      mBackgrounds[0].graphic = new Graphiclist();
      mBackgrounds[0].layer = BG_LAYER + 1;
      mBackgrounds[1].graphic = new Graphiclist();
      mBackgrounds[1].layer = BG_LAYER;

      mHitArea.layer = HIT_LAYER;
      mHitArea.mask = new Masklist();
      mHitArea.type = "solid";

      mHitAreaTr.graphic = new Graphiclist();
      mHitAreaTr.layer = HITTR_LAYER;
      mHitAreaTr.mask = new Masklist();
      mHitAreaTr.type = "transparent";
    }

    public function load(callback:Function):void {
      mCallback = callback;
    }

    /**
     * Install level into level.
     *
     * @param TLevel where Level to install into.
     */
    public function install(where:TLevel):void {
      build();

      where.addList(mBackgrounds);
      where.addList(mHitArea, mHitAreaTr, mLevel);
      where.addList(mForegrounds);

      for each(var obj:TObject in mObjects) where.add(obj);
    }

    protected function loadDone():void {
      mCallback();
    }

    private function build():void {
      // local tile width/height
      var tw:uint = 32; //tileset.tileWidth;
      var th:uint = 32; //tileset.tileHeight;

      // maximum tiles fitting single bitmapdata
      var gw:uint = Math.floor(CONFIG::BitmapDataMaxWidth / tw);
      var gh:uint = Math.floor(CONFIG::BitmapDataMaxWidth / th);

      // world sizes
      var h:uint = mLevelData.length;
      var w:uint = mLevelData[0].length;

      // count of bitmaps in raws and columns
      var raws:uint = Math.ceil(w / gw);
      var cols:uint = Math.ceil(h / gh);

      // current displacement in pixels and bitmaps
      var dx:uint = 0, raw:uint = 0;
      var dy:uint = 0, col:uint = 0;

      // hit areas tiles
      var hitTiles:BitmapData = ((Bitmap)(new mTilesHit())).bitmapData;
      var hitTrTiles:BitmapData = ((Bitmap)(new mTilesTr())).bitmapData;

      // tiles
      var foreground:BitmapData = ((Bitmap)(new mForeground())).bitmapData;

      // hit area row size
      var row_size:uint = Math.floor(hitTiles.width / tw);

      // iterating over rows
      while(dy < h * th) {
        // iterating over columns
        while(dx < w * tw) {
          // current block size
          var mx:uint = Math.min(w - col * gw, gw);
          var my:uint = Math.min(h - raw * gh, gh);
          // building blocks
          var fgt:Tilemap = new Tilemap(foreground, mx * tw, my * th, tw, th);
          var bgt:Tilemap = new Tilemap(foreground, mx * tw, my * th, tw, th);
          var bgt1:Tilemap = new Tilemap(foreground, mx * tw, my * th, tw, th);
          var lvlt:Tilemap = new Tilemap(foreground, mx * tw, my * th, tw, th);
          var trt:Tilemap = new Tilemap(foreground, mx * tw, my * th, tw, th);
          var hitBD:BitmapData = new BitmapData(mx * tw, my * th);
          hitBD.lock();
          hitBD.fillRect(new Rectangle(0, 0, hitBD.width, hitBD.height), 0);
          var hitTrBD:BitmapData = new BitmapData(mx * tw, my * th);
          hitTrBD.lock();
          hitTrBD.fillRect(new Rectangle(0, 0, hitTrBD.width, hitTrBD.height), 0);
          // iterating locally in block
          for(var lx:uint = 0; lx < mx; ++lx)
            for(var ly:uint = 0; ly < my; ++ly) {
              // processing single tile
              var tile:Object = mLevelData[raw * gh + ly][col * gw + lx];
              // setting hit bitmaps
              var hit_x:uint = tile.lvl % row_size;
              var hit_y:uint = Math.floor(tile.lvl / row_size);
              var clip:Rectangle = new Rectangle(lx * tw, ly * th, tw, th);
              var m:Matrix = new Matrix(1, 0, 0, 1, clip.x - hit_x * tw, clip.y - hit_y * th);
              hitBD.draw(hitTiles, m, null, null, clip);

              hit_x = tile.tr % row_size;
              hit_y = Math.floor(tile.tr / row_size);
              clip = new Rectangle(lx * tw, ly * th, tw, th);
              m = new Matrix(1, 0, 0, 1, clip.x - hit_x * tw, clip.y - hit_y * th);
              hitTrBD.draw(hitTrTiles, m, null, null, clip);

              // var clip:Rectangle = new Rectangle(lx * tw, ly * th, tw, th);
              // hitBD.draw(hitTiles, null, null,null, clip);
              // hitTrBD.draw(hitTrTiles, null, null, null, clip);
              // setting data in tilemaps
              trt.setTile(lx, ly, tile.tr);
              fgt.setTile(lx, ly, tile.fg);
              bgt.setTile(lx, ly, tile.bg);
              bgt1.setTile(lx, ly, tile.bg1);
              lvlt.setTile(lx, ly, tile.lvl);
            }
          // final building, possitioning
          hitBD.unlock();
          var hit:Pixelmask = new Pixelmask(hitBD, dx, dy);
          hitTrBD.unlock();
          var hitTr:Pixelmask = new Pixelmask(hitTrBD,dx, dy);
          trt.x = lvlt.x = fgt.x = bgt.x = dx;
          trt.y = lvlt.y = fgt.y = bgt.y = dy;
          // integrating data
          Graphiclist(mForegrounds[0].graphic).add(fgt);
          Graphiclist(mBackgrounds[0].graphic).add(bgt);
          Graphiclist(mBackgrounds[1].graphic).add(bgt1);
          Graphiclist(mLevel.graphic).add(lvlt);
          Graphiclist(mHitAreaTr.graphic).add(trt);
          Masklist(mHitArea.mask).add(hit);
          hit.parent = mHitArea;
          Masklist(mHitAreaTr.mask).add(hitTr);
          hitTr.parent = mHitAreaTr;

          ++col;
          dx += gw * tw;
        }
        col = 0;
        ++raw;
        dx = 0;
        dy += gh * th;
      }
    }

    /**
     * Sets level size and initializes level data object.
     *
     * @param uint w Level width
     *
     * @param uint h Level height
     */
    protected function setLevelSize(w:uint, h:uint):void {
      for(var i:uint = 0; i < h; ++i) {
        mLevelData[i] = new Array();
        for(var j:uint = 0; j < w; ++j)
          mLevelData[i][j] = {};
      }
    }

    protected function addObject(obj:Entity):void {
      mObjects.push(obj);
    }

    protected function addEnemy(obj:TObject, moveType:String, moveLength:uint, x:Number, y:Number):void {
      obj.x = x;
      obj.y = y - obj.height;
      obj.type = "enemy";
      if(moveType == "circle") obj.addAffect(new TCircleWalk);
      else if(moveType == "free") obj.addAffect(new TFreeFly(moveLength * 32));
      obj.addAffect(new TKiller);
      obj.addAffect(new TLife(3));
      addObject(obj);
    }

    protected function addMiscObject(type:String, x:Number, y:Number):void {
      var ms:TImage;
      var af:TAffect;
      if(type == "rfmissile" || type == "launcher" || type == "blaster" || type == "carrot" || type == "fire") {
        var sfx:Sfx;
        switch(type) {
        case "rfmissile":
          ms = TImage.rfmissile;
          af = new TWeaponAmmo(2, 2);
          sfx = new Sfx(Collect);
          break;
        case "launcher":
          ms = TImage.launcher;
          af = new TWeaponAmmo(3, 2);
          sfx = new Sfx(Collect);
          break;
        case "blaster":
          ms = TImage.blaster;
          af = new TWeaponAmmo(1, 2);
          sfx = new Sfx(Collect);
          break;
        case "carrot":
          ms = TImage.carrot;
          af = new TCarrot;
          sfx = new Sfx(Carrot);
          break;
        case "fire":
          ms = TImage.fire;
          af = new TRapidFire;
          sfx = new Sfx(RapidFire);
          break;
        }
        ms.addAffect(new TFloating);
        ms.addAffect(af);
        ms.addAffect(new TCollactable(af as IWorker, 150, sfx));
      } else if(type == "bigrfmissile" || type == "biglauncher" || type == "bigblaster") {
        switch(type) {
        case "bigrfmissile":
          ms = TImage.bigrfmissile;
          af = new TWeaponAmmo(2, 14);
          break;
        case "biglauncher":
          ms = TImage.biglauncher;
          af = new TWeaponAmmo(3, 14);
          break;
        case "bigblaster":
          ms = TImage.bigblaster;
          af = new TWeaponAmmo(1, 14);
          break;
        }
        ms.addAffect(af);
        ms.addAffect(new TShootable(af as IWorker, 10, new Sfx(ShootBig)));
      }
      ms.x = x;
      ms.y = y - 32;
      addObject(ms);
    }
  }
}