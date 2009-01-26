import ui.BroadcastingDisplayObject;

class ui.ChromelessPlayer extends BroadcastingDisplayObject {
  public static var PACKAGE:String = "__Packages.ui.ChromelessPlayer";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE,
                                                          ChromelessPlayer);

  private static var PLAYER_URL:String = "http://www.youtube.com/apiplayer";

  private var player:MovieClip;
  private var loadInterval:Number;

  function ChromelessPlayer () {
    super();

    System.security.allowDomain('www.youtube.com');
    System.security.allowDomain('gdata.youtube.com');
    System.security.allowInsecureDomain('gdata.youtube.com');
    System.security.allowInsecureDomain('www.youtube.com');

    player = createEmptyMovieClip("player", 1);

    // create a listener object for the MovieClipLoader to use
    var t:ChromelessPlayer = this;
    var ytPlayerLoaderListener:Object = {
      onLoadInit: function() {
        // When the player clip first loads, we start an interval to
        // check for when the player is ready
        t.loadInterval = setInterval(function(){t.checkPlayerLoaded()}, 250);
      }
    };

    // create a MovieClipLoader to handle the loading of the player
    var ytPlayerLoader:MovieClipLoader = new MovieClipLoader();
    ytPlayerLoader.addListener(ytPlayerLoaderListener);

    // load the player
    ytPlayerLoader.loadClip(PLAYER_URL, player);
  }

  private function checkPlayerLoaded():Void {
    // once the player is ready, we can subscribe to events, or in the case of
    // the chromeless player, we could load videos
    if (isPlayerLoaded()) {
      trace("Player loaded:", this);
      hidePlayButton();
      player.addEventListener("onStateChange", bind(this, onPlayerStateChange));
      player.addEventListener("onError", bind(this, onPlayerError));
      broadcastMessage(EVENT_LOAD);
      clearInterval(loadInterval);
    }
  }

  private function hidePlayButton():Void {
    player.loadClip.overallHolder.videoPlayer.largePlayButton._alpha = 0;
    player.loadClip.overallHolder.videoPlayer.logo._visible = false;
  }

  public function isPlayerLoaded():Boolean {
    return player.isPlayerLoaded();
  }

  public function setSize(width:Number, height:Number):Void {
    if (isPlayerLoaded()) {
      player.setSize(width, height);
    }
  }

  public function cueVideoById(videoId:String):Void {
    if (isPlayerLoaded()) {
      player.cueVideoById(videoId);
    }
  }

  public function playVideo():Void {
    if (isPlayerLoaded()) {
      //player.playVideo();
      player.loadClip.overallHolder.videoPlayer.largePlayButton.onRelease();
    }
  }

  public function getVideoSize():/*Number*/Array {
    var v:Object = player.loadClip.overallHolder.videoPlayer.videoDisplay.video;
    var r:/*Number*/Array = [v.width, v.height];
    return r;
  }

  public function onPlayerStateChange(newState:Number):Void {
    trace("New player state: ", newState, getVideoSize());
  }

  public function onPlayerError(errorCode:Number):Void {
    trace("An error occurred: ", errorCode, this);
  }
}