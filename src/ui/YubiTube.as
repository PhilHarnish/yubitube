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
  private var panels:MovieClip;
  private var activePanel:VideoPanel;
  private var tf:TextField;

  function YubiTube() {
    panels = createEmptyMovieClip("panels", 1);
  }

  public function onResize(width:Number, height:Number) {
    activePanel.setSize(width, height-25);
    activePanel._y = 25;
  }

  public function setPlayerData(data:PlayerData):Void {
    playerData = data;
    
    queueVideos(playerData.playlist.getVideoData());
  }

  public function queueVideos(videos:/*VideoData*/Array) {
    var count:Number = videos.length;
    if (!count) {
      return;
    }
    for (var i = 0; i < count; i++) {
      var id:String = videos[i].videoId;
      trace("Queue video", id);
      panels[id] = panels.attachMovie(VideoPanel.PACKAGE,
                                      id,
                                      panels.getNextHighestDepth());
      panels[id].init(id);
    }
    // Set active panel
    activePanel = panels[videos[0].videoId];
    activePanel.setActive(true);
  }
}
