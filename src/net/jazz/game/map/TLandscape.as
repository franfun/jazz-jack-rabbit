package net.jazz.game.map {
  import flash.display.BitmapData;
  import net.flashpunk.Entity;

  public class TLandscape {
    public var tilewidth:Number;
    public var tileheight:Number;
    public var graphic:Class;
    public var mask:BitmapData;
    public var type:String;
    public var layer:uint;
    public var data:Array;

    public function build():Entity {
      if(!data) throw new Error("No map data!");
      if(!graphic) throw new Error("No graphic to build tilemap");
      return null;
    }
  }
}