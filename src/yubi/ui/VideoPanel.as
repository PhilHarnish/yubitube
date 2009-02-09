
import yubi.model.VideoData;
import yubi.ui.BroadcastingDisplayObject;
import yubi.ui.ChromelessPlayer;
import yubi.ui.VideoThumbnail;

class yubi.ui.VideoPanel extends BroadcastingDisplayObject {
  public static var PACKAGE:String = "__Packages.yubi.ui.VideoPanel";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE, VideoPanel);

  private var videoPlayer:ChromelessPlayer;
  private var thumbnail:MovieClip;
  private var videoId:String;
  private var active:Boolean;
  private var width:Number;
  private var height:Number;

  function VideoPanel () {
    super();

    width = 320;
    height = 240;

    videoPlayer = ChromelessPlayer(attachMovie(ChromelessPlayer.PACKAGE,
                                               "videoPlayer",
                                               1));
    thumbnail = VideoThumbnail(attachMovie(VideoThumbnail.PACKAGE,
                                           "thumbnail",
                                           2));
    thumbnail.onRelease = bind(this, onThumbnailRelease);

    videoPlayer.addListener(this);

    setActive(false);
  }

  public function init(id:String):Void {
    videoId = id;
    thumbnail.init(id);
  }

  public function setSize(newWidth:Number, newHeight:Number):Void {
    width = newWidth;
    height = newHeight;
    thumbnail.setSize(width, height);
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
    _visible = true;//Boolean(videoPlayer.isPlayerLoaded() && active);
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

  private function onThumbnailRelease():Void {
    trace("Playing...");
    playVideo()
    thumbnail._visible = false;
  }

}
