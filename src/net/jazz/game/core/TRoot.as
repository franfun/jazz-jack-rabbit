package net.jazz.game.core {
  import flash.display.Bitmap;

  import net.flashpunk.Engine;
  import net.flashpunk.FP;

  import net.jazz.game.affects.TControl;
  import net.jazz.game.affects.TKeyboard;

  public class TRoot extends Engine {
    [Embed(source="../../../../../res/diamondus-aligned-indexed.png")]
    protected var Tiles:Class;
    [Embed(source="../../../../../res/diamondus-hit.png")]
    protected var TilesHit:Class;
    [Embed(source="../../../../../res/diamondus-hit-transparent.png")]
    protected var TilesTr:Class;
    [Embed(source="../../../../../res/map.tmx", mimeType="application/octet-stream")]
    protected var DiamondusMap1:Class;

    public function TRoot(w:uint, h:uint, fps:uint, tick:Boolean) {
      super(w*2, h*2, fps, tick);

      // FP.screen.scale = 2;
      FP.console.enable();
    }

    public function StartLevel():void {
      var tileset:TTileset = new TTileset(Bitmap(new Tiles).bitmapData,
                                          Bitmap(new Tiles).bitmapData,
                                          Bitmap(new TilesHit).bitmapData,
                                          Bitmap(new TilesTr).bitmapData, 32, 32);

      var level:TLevel = new TLevel;

      var levelXML:XML = XML(new DiamondusMap1);
      var w:uint = levelXML.@width;
      var h:uint = levelXML.@height;
      FP.console.log("w = " + w + " h = " + h);

      var data:Array = new Array();
      for(var i:uint = 0; i < h; ++i) {
        data[i] = new Array();
        for(var j:uint = 0; j < w; ++j)
          data[i][j] = {bg: 0, fg: 0, lvl:0};
      }

      for each(var layer:XML in levelXML.layer) {
        var key:String;
        if(layer.@name == "background") key = "bg";
        else if(layer.@name == "foreground") key = "fg";
        else if(layer.@name == "level") key = "lvl";
        else continue;
        i = 0;
        j = 0;
        for each(var tile:XML in layer.data.tile) {
          data[j][i][key] = tile.@gid - 1;
          ++i;
          if(i==w) {
            ++j;
            i = 0;
          }
        }
      }

      level.MapData(data, tileset);

      var control:TControl = new TControl(level);

      var jazz:TRabbit = new TRabbit(control);
      jazz.AddAffect(new TKeyboard);

      level.AddJazz(jazz);

      FP.world = level;
    }
  }
}