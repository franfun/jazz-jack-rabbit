package net.jazz.game.map {
  import flash.display.BitmapData;
  import net.flashpunk.Entity;

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
      throw new Error("Landscape building not implemented yet!");
      return null;
    }
  }
}