/**
 * Entry point for test suite
 */

import asunit.framework.TestSuite;
import asunit.textui.TestRunner;

class AllTests extends TestSuite {
  private var className:String = "AllTests";

  public function AllTests() {
    super();
    addTest(new PassingTest());
  }

  public static function main():Void {
    var runner:TestRunner = new TestRunner();
    runner.start(AllTests);
  }
}
