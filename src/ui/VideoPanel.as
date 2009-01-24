import ui.BroadcastingDisplayObject;
import ui.ChromelessPlayer;

class ui.VideoPanel extends BroadcastingDisplayObject {
  public static var PACKAGE:String = "__Packages.ui.VideoPanel";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE, VideoPanel);

  private var videoPlayer:ChromelessPlayer;

  function VideoPanel () {
    super();
    videoPlayer = ChromelessPlayer(attachMovie(ChromelessPlayer.PACKAGE,
                                               "mainDisplay",
                                               1));
  }
}
