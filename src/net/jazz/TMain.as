package net.jazz {
  import flash.display.Sprite;

  import net.jazz.game.core.TRoot;

  public class TMain extends Sprite {
    public function TMain() {
      var root:TRoot = new TRoot(320, 240, 30, false);
      addChild(root);
      root.StartLevel();
    }
  }
}