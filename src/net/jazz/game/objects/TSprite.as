package net.jazz.game.objects {

  import flash.display.BitmapData;

  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;

  import net.jazz.game.affects.THit;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TRabbit;
  import net.jazz.game.core.IColorizable;

  public class TSprite extends TObject implements IColorizable {
    private var anim:Spritemap;

    public function TSprite(tiles:Class, w:Number, h:Number, frames:uint) {
      super();
      anim = new Spritemap(tiles, w, h);
      var fr:Array = [];
      for(var i:int = 0; i < frames; ++i) fr[i] = i;
      anim.add("move", fr, 15);
      anim.play("move");
      setHitbox(w, h, 0, 0);
      graphic = anim;
    }

    public function set flipped(bb:Boolean):void {
      anim.flipped = bb;
    }

    public function set color(cc:uint):void {
      anim.color = cc;
    }

    public function set colorOffset(cc:uint):void {
      anim.colorOffset = cc;
    }
   }
}
