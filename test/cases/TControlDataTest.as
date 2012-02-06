package cases {
  import org.flexunit.Assert;
  import net.jazz.game.affects.data.TControlData;

  public class TControlDataTest {
    [Test(description = "test acceleration")]
    public function doTests():void {
      var cd:TControlData = new TControlData;
      cd.AddPower("keyboard", 100, 250);
      cd.Elapsed(2);
      Assert.assertEquals("Initial Acceleration", 200, cd.value);
      cd.RemovePower("keyboard");
      cd.Elapsed(1);
      Assert.assertEquals("Stopping", 100, cd.value);
      cd.Elapsed(0.5);
      Assert.assertEquals("Stopping send time", 50, cd.value);
      cd.Elapsed(1);
      Assert.assertEquals("Finished", 0, cd.value);
    }
  }
}