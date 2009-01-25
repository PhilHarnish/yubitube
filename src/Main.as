/**
 * Entry point for YubiTube
 */

import ui.YubiTube;
import util.PlayerData;

class Main {

  static function main(mc:MovieClip):Void {
    trace("YubiTube player.", mc);
    Stage.scaleMode = "noscale";
    Stage.align = "TL";
    var app:YubiTube = YubiTube(mc.attachMovie(YubiTube.PACKAGE, "app", 1));
    app.setPlayerData(new PlayerData(mc));
  }
}
