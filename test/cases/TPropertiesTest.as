package cases {
  import org.flexunit.Assert;
  import net.jazz.game.data.TProperties;

  public class TPropertiesTest {
    [Test(description = "test simple operations")]
    public function doTests():void {
      var pr:TProperties = new TProperties();
      pr.value = "main";
      Assert.assertEquals("Setting main value", "main", pr.value);
      pr.add("onCollide", "bonus");
      pr.add("onCollide/bonus/score", "150");
      pr.add("onCollide/bonus/sound", "ding");
      Assert.assertEquals("Setting property", "bonus", pr.find("onCollide"));
      var bonus:TProperties = pr.findGroup("onCollide").findGroup("bonus");
      Assert.assertEquals("Subgroup keys", "150", bonus.find("score"));
      Assert.assertEquals("Subgroup keys", "ding", bonus.find("sound"));
      var keys:Vector.<String> = bonus.keys;
      Assert.assertEquals("Keys count", 2, keys.length);
      Assert.assertTrue("key value", keys.indexOf("score") >= 0);
      Assert.assertTrue("key value", keys.indexOf("sound") >= 0);
      pr.add("onShoot", "blow");
      pr.add("animation", "red");
      Assert.assertEquals("Check keys", "blow", pr.find("onShoot"));
      Assert.assertEquals("Check keys", "red", pr.find("animation"));
      pr.add("onCollide/bonus", "best");
      Assert.assertEquals("Subgroup value", "best", bonus.value);
      var res:Object = pr.remove("animation");
      Assert.assertEquals("remove value", "red", res);
      keys = pr.keys;
      Assert.assertTrue("removed key possition", keys.indexOf("animation") < 0);
      keys = pr.findGroup("onCollide").keys;
      Assert.assertTrue("before remove group name possition", keys.indexOf("bonus") >= 0);
      bonus = pr.findGroup("onCollide").removeGroup("bonus");
      Assert.assertTrue("removed group name possition", keys.indexOf("bonus") < 0);
      Assert.assertEquals("Subgroup keys", "150", bonus.find("score"));
      Assert.assertEquals("Subgroup keys", "ding", bonus.find("sound"));
    }

    [Test(description = "test from XML")]
    public function fromXML():void {
      var xml:XML = <properties>
        <property name="onCollide" value="boom"/>
        <property name="onCollide/boom" value="badaboom"/>
        <property name="size" value="15"/>
        <property name="size/width" value="5"/>
        <property name="size/height" value="12"/>
        <property name="size/rect/width" value="left"/>
        <property name="size/rect/height" value="right"/>
        </properties>;

      var pr:TProperties = new TProperties(xml);
      Assert.assertEquals("Value", "boom", pr.find("onCollide"));
      Assert.assertEquals("Value", "15", pr.find("size"));
      var onC:TProperties = pr.findGroup("onCollide");
      Assert.assertEquals("Subgroup value", "badaboom", onC.find("boom"));
      var size:TProperties = pr.findGroup("size");
      Assert.assertEquals("Subgroup value", "15", size.value);
      Assert.assertEquals("Subgroup value", "5", size.find("width"));
      Assert.assertEquals("Subgroup value", "12", size.find("height"));
      var rect:TProperties = size.findGroup("rect");
      Assert.assertEquals("Subgroup value", "left", rect.find("width"));
      Assert.assertEquals("Subgroup value", "right", rect.find("height"));
      var keys:Vector.<String> = size.keys;
      Assert.assertEquals("Keys count", 3, keys.length);
      Assert.assertTrue("key value", keys.indexOf("width") >= 0);
      Assert.assertTrue("key value", keys.indexOf("height") >= 0);
      Assert.assertTrue("key value", keys.indexOf("rect") >= 0);
    }

    [Test(description = "test from XML node attributes")]
    public function fromAttributes():void {
      var xml:XML = <node left="true" right="false" twenty="20" />;
      var pr:TProperties = new TProperties();
      pr.fromAttributes(xml, new <String>["right"]);
      Assert.assertEquals("Value", "true", pr.find("left"));
      Assert.assertEquals("Value", "nothing", pr.find("right", "nothing"));
      Assert.assertEquals("Value", "20", pr.find("twenty"));
    }
  }
}