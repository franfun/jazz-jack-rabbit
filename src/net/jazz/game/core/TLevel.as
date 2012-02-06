package net.jazz.game.core {
  import flash.display.BitmapData;
  import flash.geom.Rectangle;
  import flash.geom.Matrix;

  import net.flashpunk.World;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Graphiclist;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.graphics.Stamp;
  import net.flashpunk.masks.Masklist;
  import net.flashpunk.masks.Pixelmask;

  /**
   * Takes care of all the processes in single game
   */
  public class TLevel extends World implements IAffectHub {
    public static const FG_LAYER:uint = 10;
    public static const JAZZ_LAYER:uint = 15;
    public static const ELEMENT_LAYER:uint = 20;
    public static const OBJECT_LAYER:uint = 30;
    public static const LVL_LAYER:uint = 40;
    public static const BG_LAYER:uint = 70;
    public static const HIT_LAYER:uint = 70;
    public static const HITTR_LAYER:uint = 70;

    private var mForeground:Entity;
    private var mLevel:Entity;
    private var mBackground:Entity;
    private var mHitArea:Entity;
    private var mHitAreaTr:Entity;

    private var mJazz:TRabbit;

    private var mAffectables:Array = [];
    private var mObjects:Array = [];

    public function TLevel() {
      super();
      mForeground = new Entity();
      mForeground.graphic = new Graphiclist();
      mForeground.layer = FG_LAYER;

      mLevel = new Entity();
      mLevel.graphic = new Graphiclist();
      mLevel.layer = LVL_LAYER;

      mBackground = new Entity();
      mBackground.graphic = new Graphiclist();
      mBackground.layer = BG_LAYER;

      mHitArea = new Entity();
      mHitArea.layer = HIT_LAYER;
      mHitArea.mask = new Masklist();
      mHitArea.type = "solid";

      mHitAreaTr = new Entity();
      mHitAreaTr.layer = HITTR_LAYER;
      mHitAreaTr.mask = new Masklist();
      mHitAreaTr.type = "transparent";

      addList(mForeground, mBackground, mHitArea, mHitAreaTr, mLevel);
    }

    override public function update():void
    {
			// Check all enemies on collision then make them move
			// for each(var e:TEnemy in mEnemyList) {
			// 		dx = e.DX;
			// 		if((mLevel.collideRect(0, 0, e.x + dx, e.y - e.height, e.width, e.height))||
			// 			 (dx < 0 && !mLevel.collidePoint(0, 0, e.x + dx, e.y+10))||
			// 			 (dx > 0 && !mLevel.collidePoint(0, 0, e.x + e.width + dx, e.y+10)))
			// 			e.Turn();
			// 	}
			super.update();
			// var Dx:int = 0;
			// var dx:int = 0;
			// var mDy:int = Math.abs(mJazz.speed) * FP.elapsed;
			// var Dy:int = 0;
			// if(mJazz.speed != 0) { Dx = mJazz.speed * FP.elapsed; dx = mJazz.speed > 0 ? 1 : -1; } 
			// if(dx != 0) {
			// 	for(var i:int = Dx; i != 0; i -= dx) {
			// 		Dy = mJazz.isFalling ? 0 : -mDy;
			// 		while(mJazz.collide("solid", mJazz.x + i, mJazz.y - Dy) && Dy < mDy) Dy += 1;
			// 		if(Dy < mDy) break;
			// 	}
			// 	if(i != 0) {
			// 		mJazz.x += i;
			// 		mJazz.y -= Dy;
			// 	}
			// }
			// if(!mJazz.collide("solid", mJazz.x, mJazz.y+3)) mJazz.isFalling = true;
			// if(mJazz.isFalling) {
			// 	Dy = mJazz.fallSpeed;
			// 	var dy:int = Dy>0 ? 1 : -1;
			// 	while(mJazz.collide("solid", mJazz.x, mJazz.y + Dy * FP.elapsed) && Dy != 0) Dy -= dy;
      //   mJazz.y += Dy * FP.elapsed;
			// 	if(Dy != mJazz.fallSpeed && mJazz.fallSpeed < 0) mJazz.StopJump();
			// 	if(Dy != mJazz.fallSpeed && mJazz.fallSpeed > 0) mJazz.isFalling = false;
			// }

      FP.console.log("updating");

      for each(var af:IAffectable in mAffectables) af.Prepare();
      for each(af in mAffectables) af.Do();
      for each(af in mAffectables) af.Finish();

      FP.camera.x = Math.max(0, mJazz.x - 160);
      FP.camera.y = Math.max(0, mJazz.y - 100);
    }

    public function HorizontalLimit(obj:TObject, max:int):int {
      var dx:int = max / Math.abs(max);
      for(var i:int = max; i != 0; i -= dx) {
        var Dy:int = 0;
        while(obj.collide("solid", obj.x + i, obj.y - Dy) && Dy < Math.abs(dx)) Dy += 1;
        if(Dy < Math.abs(dx)) break;
      }
      return i;
    }

    /**
     * Fills level with data. Called in the very beginning.
     *
     * @param tiles Array 2-dimantional array of tiles on the map.
     *
     * @param tileset TTileset Tile data.used to build layers
     */
    public function MapData(tiles:Array, tileset:TTileset):void {
      // local tile width/height
      var tw:uint = tileset.tileWidth;
      var th:uint = tileset.tileHeight;

      // maximum tiles fitting single bitmapdata
      var gw:uint = Math.floor(CONFIG::BitmapDataMaxWidth / tw);
      var gh:uint = Math.floor(CONFIG::BitmapDataMaxWidth / th);

      // world sizes
      var h:uint = tiles.length;
      var w:uint = tiles[0].length;

      // count of bitmaps in raws and columns
      var raws:uint = Math.ceil(w / gw);
      var cols:uint = Math.ceil(h / gh);

      // current displacement in pixels and bitmaps
      var dx:uint = 0, raw:uint = 0;
      var dy:uint = 0, col:uint = 0;

      // hit areas tiles
      var hitTiles:BitmapData = tileset.HitareaBD();
      var hitTrTiles:BitmapData = tileset.HitareaTrBD();

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
          var fgt:Tilemap = tileset.FGTilemap(mx * tw, my * th);
          var bgt:Tilemap = tileset.BGTilemap(mx * tw, my * th);
          var lvlt:Tilemap = tileset.BGTilemap(mx * tw, my * th);
          var hitBD:BitmapData = new BitmapData(mx * tw, my * th);
          hitBD.fillRect(new Rectangle(0, 0, hitBD.width, hitBD.height), 0);
          var hitTrBD:BitmapData = new BitmapData(mx * tw, my * th);
          hitTrBD.fillRect(new Rectangle(0, 0, hitTrBD.width, hitTrBD.height), 0);
          // iterating locally in block
          for(var lx:uint = 0; lx < mx; ++lx)
            for(var ly:uint = 0; ly < my; ++ly)
              {
              // processing single tile
              var tile:Object = tiles[raw * gh + ly][col * gw + lx];
              // setting hit bitmaps
              var hit_x:uint = tile.lvl % row_size;
              var hit_y:uint = Math.floor(tile.lvl / row_size);
              var clip:Rectangle = new Rectangle(lx * tw, ly * th, tw, th);
              var m:Matrix = new Matrix(1, 0, 0, 1, clip.x - hit_x * tw, clip.y - hit_y * th);
              hitBD.draw(hitTiles, m, null, null, clip);
              // var clip:Rectangle = new Rectangle(lx * tw, ly * th, tw, th);
              // hitBD.draw(hitTiles, null, null,null, clip);
              // hitTrBD.draw(hitTrTiles, null, null, null, clip);
              // setting data in tilemaps
              fgt.setTile(lx, ly, tile.fg);
              bgt.setTile(lx, ly, tile.bg);
              lvlt.setTile(lx, ly, tile.lvl);
            }
          // final building, possitioning
          var hit:Pixelmask = new Pixelmask(hitBD, dx, dy);
          var hitTr:Pixelmask = new Pixelmask(hitTrBD,dx, dy);
          lvlt.x = fgt.x = bgt.x = dx;
          lvlt.y = fgt.y = bgt.y = dy;
          // integrating data
          Graphiclist(mForeground.graphic).add(fgt);
          Graphiclist(mBackground.graphic).add(bgt);
          Graphiclist(mLevel.graphic).add(lvlt);
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
     * Adds object to the stage.
     *
     * @param obj TObject object to add
     */
    public function AddObject(obj:TObject):void {
      mObjects.push(obj);
      add(obj);
      obj.layer = OBJECT_LAYER;
      obj.type = "object";
    }

    /**
     * Adds element to the stage.
     *
     * @param elem TElement elemnt to add
     */
    // public function AddElement(elem:TElement):void {
    //   AddObject(elem);
    //   obj.layer = ELEMENT_LAYER;
    //   obj.name = "element";
    // }

    /**
     * This guy is special!
     *
     * @param jazz TRabbit The One.
     */
    public function AddJazz(jazz:TRabbit):void {
      mJazz = jazz;
      AddObject(jazz);
      AddAffectable(jazz);
      jazz.layer = JAZZ_LAYER;
      jazz.type = "jazz";
    }

    //----------------------------------------
    //-- Affectable section
    //----------------------------------------

    public function get affectables():Array {
      return mAffectables;
    }

    public function RemoveAffectable(aff:IAffectable):void {
      mAffectables.splice(mAffectables.indexOf(aff), 1);
    }

    public function AddAffectable(aff:IAffectable):void {
      mAffectables.push(aff);
    }

    public function ProcessAffectables():void {

    }

  }
}