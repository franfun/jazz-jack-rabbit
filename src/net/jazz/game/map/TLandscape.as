package net.jazz.game.map {
  import flash.display.BitmapData;
  import flash.geom.Rectangle;
  import flash.geom.Matrix;

  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Graphiclist;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.masks.Masklist;
  import net.flashpunk.masks.Pixelmask;

  import net.jazz.game.core.graphic.TTileset;

  public class TLandscape {
    public var graphic:TTileset;
    public var type:String;
    public var layer:uint;
    public var data:Array;

    public function TLandscape(graphic:TTileset, data:Array, layer:uint, type:String) {
      this.graphic = graphic;
      this.data = data;
      this.layer = layer;
      this.type = type;
    }

    public function build():Entity {
      if(!data) throw new Error("No map data!");
      if(!graphic) throw new Error("No graphic to build tilemap");

      var result:Entity = new Entity;
      result.layer = layer;
      result.type = type;
      result.graphic = new Graphiclist();

      // tile sizes
      var tw:Number = graphic.tilewidth;
      var th:Number = graphic.tileheight;

      // maximum tiles fitting single bitmapdata
      var gw:uint = Math.floor(CONFIG::BitmapDataMaxWidth / tw);
      var gh:uint = Math.floor(CONFIG::BitmapDataMaxWidth / th);

      // world sizes
      var h:uint = data.length;
      var w:uint = data[0].length;

      // count of bitmaps in raws and columns
      var raws:uint = Math.ceil(w / gw);
      var cols:uint = Math.ceil(h / gh);

      // current displacement in pixels and bitmaps
      var dx:uint = 0, raw:uint = 0;
      var dy:uint = 0, col:uint = 0;

      // hit areas tiles
      var hitTiles:BitmapData = null;
      // hit area row size
      var row_size:uint = 0;
      var has_mask:Boolean = false;

      trace(graphic.mask);
      trace(type);
      if(graphic.mask != null && type != "") {
        trace("adding mask");
        hitTiles = graphic.mask.bitmap;
        row_size = Math.floor(hitTiles.width / tw);
        result.mask = new Masklist();
        has_mask = true;
      }

      // iterating over rows
      while(dy < h * th) {
        // iterating over columns
        while(dx < w * tw) {
          // current block size
          var mx:uint = Math.min(w - col * gw, gw);
          var my:uint = Math.min(h - raw * gh, gh);
          // building blocks
          graphic.setSize(mx * tw, my * th);
          var tile:Tilemap = graphic.build() as Tilemap;
          // iterating locally in block
          for(var lx:uint = 0; lx < mx; ++lx)
            for(var ly:uint = 0; ly < my; ++ly) {
              // processing single tile

              // setting data in tilemaps
              tile.setTile(lx, ly, data[raw * gh + ly][col * gw + lx]);
            }
          // final building, possitioning
          tile.x = dx;
          tile.y = dy;
          // integrating data
          Graphiclist(result.graphic).add(tile);

          if(has_mask) {
            var hitBD:BitmapData = new BitmapData(mx * tw, my * th);
            hitBD.lock();
            hitBD.fillRect(new Rectangle(0, 0, hitBD.width, hitBD.height), 0);
            for(lx = 0; lx < mx; ++lx)
              for(ly = 0; ly < my; ++ly) {
                var tile_id:uint = data[raw * gh + ly][col * gw + lx];
                // setting hit bitmaps
                var hit_x:uint = tile_id % row_size;
                var hit_y:uint = Math.floor(tile_id / row_size);
                var clip:Rectangle = new Rectangle(lx * tw, ly * th,
                                                   tw, th);
                var m:Matrix = new Matrix(1, 0, 0, 1, clip.x - hit_x * tw, clip.y - hit_y * th);
                hitBD.draw(hitTiles, m, null, null, clip);
              }
            hitBD.unlock();
            var hit:Pixelmask = new Pixelmask(hitBD, dx, dy);
            Masklist(result.mask).add(hit);
            hit.parent = result;
          }

          ++col;
          dx += gw * tw;
        }
        col = 0;
        ++raw;
        dx = 0;
        dy += gh * th;
      }
      return result;
    }
  }
}