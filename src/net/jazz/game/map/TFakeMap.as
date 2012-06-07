package net.jazz.game.map {
  import flash.utils.Timer;
  import flash.events.TimerEvent;
  import flash.geom.Rectangle;

  // import net.flashpunk.World;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.Sfx;
  import net.flashpunk.graphics.Backdrop;

  import net.jazz.game.affects.TJumpad;
  import net.jazz.game.affects.TCollactable;
  import net.jazz.game.affects.TCircleWalk;
  import net.jazz.game.affects.TFloating;
  import net.jazz.game.affects.TShootable;
  import net.jazz.game.objects.TSprite;
  import net.jazz.game.core.TLevel;

  /**
   * Simple example implementation of map.
   */
  public class TFakeMap extends TBaseMap {
    // [Embed(source="../../../../../res/diamondus-bg.png")]
    // protected var DiamondusBg:Class;
    // [Embed(source="../../../../../res/diamondus-aligned-indexed.png")]
    // protected var Tiles:Class;
    // [Embed(source="../../../../../res/diamondus-hit.png")]
    // protected var TilesHit:Class;
    // [Embed(source="../../../../../res/diamondus-special.png")]
    // protected var DiamSpec:Class;
    // [Embed(source="../../../../../res/diamondus-hit-transparent.png")]
    // protected var TilesTr:Class;
    // [Embed(source="../../../../../res/level-misc-aligned.png")]
    // protected var Misc:Class;
    // [Embed(source="../../../../../res/tortal1.png")]
    // protected var Tortail:Class;
    // [Embed(source="../../../../../res/bee1.png")]
    // protected var Bee:Class;
    // [Embed(source="../../../../../res/map.tmx", mimeType="application/octet-stream")]
    // protected var DiamondusMap1:Class;
    [Embed(source="../../../../../res/fake-1.tmx", mimeType="application/octet-stream")]
    protected var FakeMap1:Class;

    // protected var map:Object = {"tortal1": Tortail,
    //                             "bee1": Bee,
    //                             "diamondus-aligned": Tiles,
    //                             "special": DiamSpec
    // };

    // private var mTileData:TGraphicManager = new TGraphicManager();

    public function TFakeMap() {
      // mTileData.setImageMap(map);
      // mTilesHit = TilesHit;
      // mTilesTr = TilesTr;
      // mForeground = Tiles;
    }

    // public function addLayer(node:XML):void {
    //   var nodeName:String = node.name().toString();
    //   if(nodeName == "layer") addLandscapeLayer(node);
    //   else if(nodeName == "objectgroup") addObjectLayer(node);
    //   else throw new Error("Unknown layer kind: " + nodeName);
    // }

    // public override function install(where:TLevel):void {
    //   super.install(where);

    //   var e:Entity = new Entity;
    //   e.graphic = new Backdrop(DiamondusBg);
    //   where.add(e);
    //   e.layer = 1000;
    //   e.graphic.scrollX = 0.2;
    //   e.graphic.scrollY = 0.2;
    // }

    protected final override function doLoad():void {
      var levelXML:XML = XML(new FakeMap1);

      var helper:TXMLMapHelper = new TXMLMapHelper;

      // var mapParams:Object = fromProperties(levelXML.properties.property);
      // var levelBlocks:String = mapParams["level-tiles"];

      // var w:uint = levelXML.@width;
      // var h:uint = levelXML.@height;

      // var tw:uint = 32; //tileset.tileWidth;
      // var th:uint = 32; //tileset.tileHeight;

      // setLevelSize(w, h);

      for each(var tileset:XML in levelXML.tileset) {
        helper.addTileset(tileset);
          // var gid:int = tileset.@firstgid;
          // var name:String = tileset.@name;
          // var tsw:uint = tileset.@tilewidth;
          // var tsh:uint = tileset.@tileheight;
          // if(name == levelBlocks) {
          //   mTileData.levelBlocks(gid, name, tsw, tsh,
          //                         (tileset.image.@width / tsw) *
          //                         (tileset.image.@height / tsh));
          // } else {
          //   var params:Object = fromProperties(tileset.properties.property);
          //   switch(params.type) {
          //   case "spritemap":
          //     mTileData.addEnemy(gid, name, tsw, tsh,
          //                        tileset.image.@width / tsw, { move: params["move"] });
          //     break;
          //   case "misc":
          //     mTileData.misc(gid);
          //     break;
          //   }
          // }
          // for each(var tile:XML in tileset.tile) {
          //   var lid:uint = tile.@id;
          //   params = fromProperties(tile.properties.property);
          //   switch(params.type) {
          //   case "actor":
          //     var action:Array = params.action.split(",");
          //     var hitbox:Array = params.hitbox.split(",");
          //     mTileData.actor(gid + lid, name, tsw, tsh, [tile.@id], action,
          //                     new Rectangle(hitbox[0], hitbox[1], hitbox[2], hitbox[3]));
          //     break;
          //   case "image":
          //     var x:Number = lid % Math.round(tileset.image.@width / tsw) * tsw;
          //     var y:Number = Math.floor(lid / Math.round(tileset.image.@width / tsw)) * tsh;
          //     mTileData.image(gid + lid, name, tsw, tsh, x, y);
          //     break;
          //   }
          // }
        }

      var layers:Vector.<XML> = new Vector.<XML>;
      for each(var layer:XML in levelXML.layer) {
          layers.push(layer);
        }

      while(layers.length > 0) {
        addLandscape(helper.parseLandscapeLayer(layers.pop()));
        // var key:String;
        // // if(layer.@name.substr(0, 11) == "background-") key = "bg" + layer.@name.substr(11);
        // // else if(layer.@name.substr(0, 11) == "foreground-") key = "fg" + layer.@name.substr(11);
        // if(layer.@name == "background") key = "bg";
        // else if(layer.@name == "background-1") key = "bg1";
        // else if(layer.@name == "foreground") key = "fg";
        // else if(layer.@name == "transparent") key = "tr";
        // else if(layer.@name == "level") key = "lvl";
        // else continue;
        // var i:uint = 0;
        // var j:uint = 0;
        // for each(tile in layer.data.tile) {
        //   mLevelData[j][i][key] = mTileData.levelBlockLID(tile.@gid);
        //   ++i;
        //   if(i==w) {
        //     ++j;
        //     i = 0;
        //   }
        // }
      }

      // var miscTiles:BitmapData = ((Bitmap)(new Misc())).bitmapData;
      // for each(var obj:XML in levelXML.objectgroup.object) {
      //   params = fromProperties(obj.properties.property);
      //   switch(mTileData.getType(obj.@gid)) {
      //   case TGraphicManager.ENEMY:
      //     var ts:Object = mTileData.getEnemyData(obj.@gid);
      //     var sp:TSprite = mTileData.getEnemySpritemap(obj.@gid);
      //     addEnemy(sp, ts.move, params.move, obj.@x, obj.@y);
      //     break;
      //   case TGraphicManager.MISC:
      //     addMiscObject(mTileData.getMiscSubType(obj.@gid), obj.@x, obj.@y);
      //     break;
      //   case TGraphicManager.OTHER:
      //     var actor:TObject = mTileData.getOther(obj.@gid);
      //     if(!actor) break;
      //     actor.x = obj.@x;
      //     actor.y = obj.@y - obj.@height;
      //     addObject(actor);
      //     switch(params.type) {
      //     case "moving-jumpad":
      //       actor.addAffect(new TCircleWalk());
      //     case "jumpad":
      //       actor.addAffect(new TJumpad(params.power));
      //       break;
      //     case "bonus":
      //       actor.addAffect(new TFloating);
      //       actor.addAffect(new TCollactable(null, 30, new Sfx(TBaseMap.Collect)));
      //       break;
      //     case "shootable":
      //       actor.addAffect(new TShootable(null));
      //     }
      //     if(params.solid == "true") actor.type = "solid";
      //     break;
      //   }
      // }

      var t:Timer = new Timer(0, 1);
      t.addEventListener(TimerEvent.TIMER_COMPLETE, callLoadDone);
      t.start();
    }

    private function callLoadDone(e:TimerEvent):void {
      Timer(e.target).removeEventListener(TimerEvent.TIMER_COMPLETE, callLoadDone);
      loadDone();
    }
  }
}
