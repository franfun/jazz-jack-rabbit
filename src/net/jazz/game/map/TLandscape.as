package net.jazz.game.map {
  import flash.display.BitmapData;

  import net.flashpunk.Entity;
  import net.flashpunk.graphics.Graphiclist;
  import net.flashpunk.graphics.Tilemap;
  import net.flashpunk.masks.Masklist;

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

      // maximum tiles fitting single bitmapdata
      var gw:uint = Math.floor(CONFIG::BitmapDataMaxWidth / graphic.tilewidth);
      var gh:uint = Math.floor(CONFIG::BitmapDataMaxWidth / graphic.tileheight);

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
      // var hitTiles:BitmapData = ((Bitmap)(new mTilesHit())).bitmapData;
      // var hitTrTiles:BitmapData = ((Bitmap)(new mTilesTr())).bitmapData;

      // tiles
      // var foreground:BitmapData = ((Bitmap)(new mForeground())).bitmapData;

      // hit area row size
      // var row_size:uint = Math.floor(hitTiles.width / tw);

      // iterating over rows
      while(dy < h * graphic.tileheight) {
        // iterating over columns
        while(dx < w * graphic.tilewidth) {
          // current block size
          var mx:uint = Math.min(w - col * gw, gw);
          var my:uint = Math.min(h - raw * gh, gh);
          // building blocks
          graphic.setSize(mx * graphic.tilewidth, my * graphic.tileheight);
          var tile:Tilemap = graphic.build() as Tilemap;
          if(!tile) throw new Error("tile was not built :(");
          // var hitBD:BitmapData = new BitmapData(mx * tw, my * th);
          // hitBD.lock();
          // hitBD.fillRect(new Rectangle(0, 0, hitBD.width, hitBD.height), 0);
          // iterating locally in block
          for(var lx:uint = 0; lx < mx; ++lx)
            for(var ly:uint = 0; ly < my; ++ly) {
              // processing single tile
              try {
                var tile_id:uint = data[raw * gh + ly][col * gw + lx];
              } catch(e:Error) { throw new Error("some trouble creating tile_id"); }
              // setting hit bitmaps
              // var hit_x:uint = tile_id % row_size;
              // var hit_y:uint = Math.floor(tile_id / row_size);
              // var clip:Rectangle = new Rectangle(lx * tw, ly * th, tw, th);
              // var m:Matrix = new Matrix(1, 0, 0, 1, clip.x - hit_x * tw, clip.y - hit_y * th);
              // hitBD.draw(hitTiles, m, null, null, clip);

              // setting data in tilemaps
              tile.setTile(lx, ly, tile_id);
            }
          // final building, possitioning
          // hitBD.unlock();
          // var hit:Pixelmask = new Pixelmask(hitBD, dx, dy);
          tile.x = dx;
          tile.y = dy;
          // integrating data
          Graphiclist(result.graphic).add(tile);
          // Masklist(mHitArea.mask).add(hit);
          // hit.parent = mHitArea;

          ++col;
          dx += gw * graphic.tilewidth;
        }
        col = 0;
        ++raw;
        dx = 0;
        dy += gh * graphic.tileheight;
      }
      return result;
    }
  }
}