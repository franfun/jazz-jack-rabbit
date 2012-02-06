package net.jazz.game.core {
  import flash.display.BitmapData;

  import net.flashpunk.graphics.Tilemap;

  public class TTileset {
    private var mForeground:BitmapData;
    private var mBackground:BitmapData;
    private var mHitarea:BitmapData;
    private var mHitareaTr:BitmapData;

    private var mTileWidth:uint;
    private var mTileHeight:uint;

    public function TTileset(fg:BitmapData, bg:BitmapData, hit:BitmapData, hitTr:BitmapData, tw:uint, th:uint) {
      mForeground = fg;
      mBackground = bg;
      mHitarea = hit;
      mHitareaTr = hitTr;
      mTileWidth = tw;
      mTileHeight = th;
    }

    public function get tileWidth():uint { return mTileWidth; }
    public function get tileHeight():uint { return mTileHeight; }

    public function FGTilemap(w:uint, h:uint):Tilemap {
      return new Tilemap(mForeground, w, h, mTileWidth, mTileHeight);
    }

    public function BGTilemap(w:uint, h:uint):Tilemap {
      return new Tilemap(mBackground, w, h,mTileWidth, mTileHeight);
    }

    public function HitareaBD():BitmapData { return mHitarea; }
    public function HitareaTrBD():BitmapData { return mHitareaTr; }
  }
}