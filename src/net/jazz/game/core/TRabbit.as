package net.jazz.game.core {
  import flash.display.BlendMode;
  import net.flashpunk.Entity;
  import net.flashpunk.FP;
  import net.flashpunk.graphics.Spritemap;
  import net.flashpunk.graphics.Image;

  public class TRabbit extends TObject implements IAffectable, IColorizable {
    public static var instance:TRabbit;
    [Embed(source = '../../../../../res/jazz-aligned.png')]
    private const JAZZ:Class;
    [Embed(source = "../../../../../res/jazz-move.xml", mimeType="application/octet-stream")]
    private const JAZZ_MOVE:Class;

    private var mJazz:Spritemap;

    public var shootCallback:Function = null;

    private var mIsFlipped:Boolean = false;

    public function TRabbit() {
      super();
      originX = -16;
      graphic = mJazz;
      type = "rabbit";
      FP.console.log("START Building rabbit spritemap START");
      var data:XML = XML(new JAZZ_MOVE);
      FP.console.log(data.toXMLString());
      mJazz = new Spritemap(JAZZ, data.animation.@frameWidth, data.animation.@frameHeight);
      for each(var frame:XML in data.animation.frames) {
          var arr:Array = frame.toString().replace(/ +/g, "").split(",");
          FP.console.log(arr);
          mJazz.add(frame.@name, arr, frame.@rate, frame.@repeat == "true");
        }
      setHitbox(data.hitbox.@width, data.hitbox.@height, data.hitbox.@x, data.hitbox.@y);
      FP.console.log("STOP Building rabbit spritemap STOP");

      instance = this;
    }

    public function get flipped():Boolean { return mJazz.flipped; }
    public function set flipped(bb:Boolean):void { mJazz.flipped = bb; }

    private var mLastWhat:String = null;
    public function Play(what:String, callback:Function = null):void {
      if(graphic != mJazz) graphic = mJazz;
      // protect from cutting shoot animation
      if(mLastWhat == "shoot" && what == "stand") return;
      mLastWhat = what;
      if(what == "shoot") mJazz.callback = PlayStand;
      else mJazz.callback = callback;
      mJazz.play(what);
    }

    private function PlayStand():void {
      mJazz.play("stand");
    }

    public function set color(cc:uint):void {
      mJazz.color = cc;
    }

    public function set colorOffset(cc:uint):void {
      mJazz.colorOffset = cc;
    }

  }
}