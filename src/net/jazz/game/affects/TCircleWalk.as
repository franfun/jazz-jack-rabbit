package net.jazz.game.affects {
  import net.flashpunk.FP;

  import net.jazz.game.core.TObject;
  import net.jazz.game.core.TLevel;
  import net.jazz.game.core.TAffect;
  import net.jazz.game.core.IAffectable;
  import net.jazz.game.core.IBounded;

  public class TCircleWalk extends TAffect {

    private var mOrient:int = 1;

    public override function process():void {
      var obj:TObject = target as TObject;
      var dx:Number = obj.horizontalLimitStrict(4 * mOrient);
      if(dx == 0) {
        mOrient *= -1;
        dx = obj.horizontalLimitStrict(4 * mOrient);
        // Flip spritemap of given object
        // var spr:TSprite = (obj as TSprite);
        // if(spr) spr.flipped = (mOrient < 0);
      }
      obj.HorizontalMove(dx);
    }
  }
}
