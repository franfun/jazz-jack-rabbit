package net.jazz.game.objects {
  import flash.geom.Rectangle;

  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.FP;

  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.TObject;

  public class TSimpleActor extends TObject implements IActor {
    private var anim:Spritemap;

    public function TSimpleActor(tiles:Class, tw:Number, th:Number,
                                 noAction:Array, action:Array,
                                 hitbox:Rectangle = null)
    {
      super();
      hitbox = hitbox || new Rectangle(0, 0, tw, th);
      setHitbox(hitbox.width, hitbox.height, hitbox.x, hitbox.y);
      graphic = anim = new Spritemap(tiles, tw, th);
      anim.add("noAction", noAction, 20, true);
      anim.add("action", action, 20, false);
      anim.play("noAction", true);
      type = "jumpad";
    }

    public function act():void {
      FP.console.log("act");
      anim.play("action", true);
      anim.callback = stop;
    }

    private function stop():void {
      FP.console.log("stop");
      anim.play("noAction", true);
      anim.callback = null;
    }
 }
}