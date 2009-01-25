/**
 * YubiTube player
 */

import ui.VideoPanel;
import util.PlayerData;
import util.VideoData;

class ui.YubiTube extends MovieClip {
  public static var PACKAGE:String = "__Packages.ui.YubiTube";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE, YubiTube);

  private var playerData:PlayerData;
  private var displays:MovieClip;
  private var tf:TextField;

  function YubiTube() {
    super();
    
    displays = createEmptyMovieClip("displays", 1);
  }

  public function setPlayerData(data:PlayerData):Void {
    playerData = data;
    
    queueVideos(playerData.playlist.getVideoData());
  }

  public function queueVideos(videos:/*VideoData*/Array) {
    var count:Number = videos.length;
    for (var i = 0; i < count; i++) {
      var id:String = videos[i].videoId;
      trace("Queue video", id);
      displays[id] = displays.attachMovie(VideoPanel.PACKAGE,
                                          id,
                                          displays.getNextHighestDepth());
      displays[id].init(id);
    }
  }
}
