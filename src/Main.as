/**
 * Entry point for YubiTube
 */

import ui.YubiTube;

class Main {

  static function main(mc:MovieClip):Void {
    trace("YubiTube player.");
    Stage.scaleMode = "noscale";
    Stage.align = "TL";
    mc.attachMovie(YubiTube.PACKAGE, "app", 1);
  }
}
