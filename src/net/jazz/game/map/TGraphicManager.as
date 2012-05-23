package net.jazz.game.map {
  import flash.utils.Dictionary;
  import flash.display.Loader;
  import flash.net.URLRequest;
  import flash.geom.Rectangle;

  import net.flashpunk.FP;

  import net.jazz.game.core.TObject;
  import net.jazz.game.objects.TImage;
  import net.jazz.game.objects.TSprite;
  import net.jazz.game.objects.TSimpleActor;

  public class TGraphicManager {
    public static const MISC:String = "misc";
    public static const ENEMY:String = "enemy";
    public static const LEVEL_BLOCKS:String = "level blocks";
    public static const OTHER:String = "other";

    private var mMiscGid:uint;
    private var mEnemies:Dictionary = new Dictionary;
    private var mActors:Dictionary = new Dictionary;
    private var mSimpleImages:Dictionary = new Dictionary;

    private var mImages:Object = {};
    private var mLoadingImages:Object = {};

    private var mLevelGID:uint;
    private var mLevelFramesCount:uint;

    private var mCallback:Function;

    /**
     * Set first gid of misc elements.
     *
     * @param uint gid First gid.
     */
    public function misc(gid:uint):void {
      mMiscGid = gid;
    }

    /**
     * Set GID as base of spritemap.
     *
     * @param uint gid GID of spritemap.
     *
     * @param String image Name of source image.
     *
     * @param Number tw Tile width.
     *
     * @param Number th Tile height.
     *
     * @param uint frames Frames count in animation.
     *
     * @param Object extra Object extra data.
     */
    public function addEnemy(gid:uint, image:String, tw:Number, th:Number, frames:uint, extra:Object = null):void {
      extra = extra || {};
      mEnemies[gid] = {src:image, tw: tw, th: th, frames: frames, extra: extra};
    }

    /**
     * Extracts data about givven enemy.
     *
     * @param uint gid GID of enemy.
     *
     * @return Object Extra data givven on enemy construction.
     */
    public function getEnemyData(gid:uint):Object {
      return mEnemies[gid].extra;
    }

    public function getEnemySpritemap(gid:uint):TSprite {
      if(mEnemies[gid] != null)
        return new TSprite(mImages[mEnemies[gid].src],
                           mEnemies[gid].tw, mEnemies[gid].th, mEnemies[gid].frames);
      throw new Error("Enemy with " + gid + " not found");
    }

    public function actor(gid:uint, src:String, tw:Number, th:Number,
                          noAction:Array, action:Array, hitbox:Rectangle):void
    {
      mActors[gid] = {src: src, tw: tw, th:th, action:action, noAction:noAction, hitbox:hitbox};
    }

    public function image(gid:uint, src:String, tw:Number, th:Number,
                          x:Number, y:Number):void
    {
      mSimpleImages[gid] = {src: src, tw: tw, th:th, x:x, y:y};
    }

    public function getOther(gid:uint):TObject {
      if(mActors[gid])
        return new TSimpleActor(mImages[mActors[gid].src], mActors[gid].tw, mActors[gid].th,
                                mActors[gid].noAction, mActors[gid].action, mActors[gid].hitbox);
      else if(mSimpleImages[gid])
        return new TImage(mImages[mSimpleImages[gid].src], mSimpleImages[gid].x, mSimpleImages[gid].y,
                          mSimpleImages[gid].tw, mSimpleImages[gid].th);
      return null;
    }

    /**
     * Level blocks.
     *
     * @param uint gid First gid of level items.
     *
     * @param String image Name of source image.
     *
     * @param Number tw Tile width.
     *
     * @param Number th Tile height.
     *
     * @param uint frames Frames count in animation.
     */
    public function levelBlocks(gid:uint, image:String, tw:Number, th:Number, frames:uint):void {
      mLevelGID = gid;
      mLevelFramesCount = frames;
    }

    /**
     * Local for level blocks sprite id.
     *
     * @param uint gid GID of block.
     *
     * @return uint Local id (LID) of block in spritemap.
     */
    public function levelBlockLID(gid:uint):uint {
      return gid - mLevelGID;
    }

    /**
     * Start loading content.
     *
     * @param Function callback Callback on load done.
     */
    public function load(callback:Function):void {
    }

    /**
     * Load image.
     *
     * @param String name Name of image.
     *
     * @param URLRequest url URL of image.
     */
    public function source(name:String, url:URLRequest):void {
      // mLoadingImages[name] = new Loader
    }

    /**
     * Set image corresponding givven name.
     *
     * @param String name Image name.
     *
     * @param Object image Class of BitmapData corresponding this name.
     *
     */
    public function setImage(name:String, image:Object):void {
      mImages[name] = image;
    }

    public function setImageMap(map:Object):void {
      for(var key:String in map)
        setImage(key, map[key]);
    }

    /**
     * Get object type by it's GID.
     *
     * @param gid uint GID of item.
     *
     * @return String Item type.
     */
    public function getType(gid:uint):String {
      if(gid >= mMiscGid && gid < mMiscGid + 16) return MISC;
      if(mEnemies[gid]) return ENEMY;
      return OTHER;
    }

    /**
     * Misc type. E.g. RF-Missile of Big RF-Missile.
     *
     * @param uint gid GID of image.
     *
     * @return String Subtype name of item.
     */
    public function getMiscSubType(gid:uint):String {
      return TImage.MISC_SUBTYPES[gid - mMiscGid];
    }

    // private function findIn(dict:Dictionary, gid:uint):Boolean {
    //   return dict[gid] != ;
    // }
  }
}
