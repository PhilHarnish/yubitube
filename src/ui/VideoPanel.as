
import model.VideoData;
import ui.BroadcastingDisplayObject;
import ui.ChromelessPlayer;

class ui.VideoPanel extends BroadcastingDisplayObject {
  public static var PACKAGE:String = "__Packages.ui.VideoPanel";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE, VideoPanel);

  private var videoPlayer:ChromelessPlayer;
  private var videoId:String;
  private var active:Boolean;
  private var width:Number;
  private var height:Number;

  function VideoPanel () {
    super();

    width = 320;
    height = 240;

    videoPlayer = ChromelessPlayer(attachMovie(ChromelessPlayer.PACKAGE,
                                               "mainDisplay",
                                               1));
    videoPlayer.addListener(this);
    setActive(false);
  }

  public function init(id:String):Void {
    trace("Loading ", id);
    videoId = id;
  }

  public function setSize(newWidth:Number, newHeight:Number):Void {
    width = newWidth;
    height = newHeight;
    videoPlayer.setSize(width, height);
  }

  public function getSize():/*Number*/Array {
    var r:/*Number*/Array = [width, height];
    return r;
  }

  public function getVideoSize():/*Number*/Array {
    return videoPlayer.getVideoSize();
  }

  public function setActive(state:Boolean):Void {
    active = state;
    _visible = Boolean(videoPlayer.isPlayerLoaded() && active);
    if (active) {
      VideoData.fromId(videoId).fetchMetadata();
    }
  }

  public function playVideo():Void {
    if (active) {
      videoPlayer.playVideo();
    }
  }

  public function onDisplayLoad():Void {
    videoPlayer.setSize(width, height);
    setActive(active);
    videoPlayer.cueVideoById(videoId);
  }

}
