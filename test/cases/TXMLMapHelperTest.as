package cases {
  import org.flexunit.Assert;
  import net.jazz.game.map.TXMLMapHelper;
  import net.jazz.game.map.TLandscape;

  public class TXMLMapHelperTest {
    [Embed(source="../../res/test1.tmx", mimeType="application/octet-stream")]
    protected var TestMap1:Class;

    [Test(description = "test loading level data in two layers from diff tilesets")]
    public function doTests():void {
      var levelXML:XML = XML(new TestMap1);

      var parser:TXMLMapHelper = new TXMLMapHelper;

      // push tilesets
      parser.addTileset(levelXML.tileset[0]);
      parser.addTileset(levelXML.tileset[1]);

      // get layer data
      var ls:TLandscape = parser.parseLandscapeLayer(levelXML.layer[0]);

      Assert.assertEquals("level data", 1, ls.data[5][2]);
      Assert.assertNotNull("graphic exists", ls.graphic);
      Assert.assertNotNull("graphic source exists", ls.graphic.source);
      Assert.assertEquals("landscape source file", "diamondus-aligned-indexed.png", ls.graphic.source.source);

      // get next layer data
      ls = parser.parseLandscapeLayer(levelXML.layer[1]);

      Assert.assertEquals("level data", 71, ls.data[5][2]);
      Assert.assertEquals("landscape source file", "diamondus-aligned.png", ls.graphic.source.source);
    }
  }
}