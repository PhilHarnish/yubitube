/**
 * Entry point for YubiTube
 */

import model.PlayerData;
import ui.YubiTube;

class Main {
  
  static var application:YubiTube;

  static function main(mc:MovieClip):Void {
    trace("YubiTube player.", mc);
    Stage.scaleMode = "noscale";
    Stage.align = "TL";
    Stage.addListener(Main);
    application = YubiTube(mc.attachMovie(YubiTube.PACKAGE, "app", 1));
    application.setPlayerData(new PlayerData(mc));
    
    onResize();
  }
  
  static function onResize():Void {
    application.onResize(Stage.width, Stage.height);
  }
}
