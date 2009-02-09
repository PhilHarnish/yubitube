import asunit.framework.TestCase;

class PassingTest extends TestCase {
  private var className:String = "PassingTest";

  public function test():Void {
    assertTrue("passing test", true);
  }
}
