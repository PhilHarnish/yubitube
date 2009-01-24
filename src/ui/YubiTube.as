/**
 * YubiTube player
 */

import flash.external.ExternalInterface;
import ui.BroadcastingDisplayObject;
import ui.VideoPanel;

class ui.YubiTube extends BroadcastingDisplayObject {
  public static var PACKAGE:String = "__Packages.ui.YubiTube";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE, YubiTube);

  private var mainDisplay:VideoPanel;
  private var tf:TextField;

  function YubiTube() {
    super();
    
    mainDisplay = VideoPanel(attachMovie(VideoPanel.PACKAGE, "mainDisplay", 1));
  }
}
