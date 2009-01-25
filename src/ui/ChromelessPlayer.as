import ui.BroadcastingDisplayObject;

class ui.ChromelessPlayer extends BroadcastingDisplayObject {
  public static var PACKAGE:String = "__Packages.ui.ChromelessPlayer";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE,
                                                          ChromelessPlayer);

  private static var PLAYER_URL:String = "http://www.youtube.com/apiplayer?t=" + (new Date()).getTime();

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
        trace("file loaded...");
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
      trace("Player loaded.", this);
      player.addEventListener("onStateChange", onPlayerStateChange);
      player.addEventListener("onError", onPlayerError);
      broadcastMessage(EVENT_LOAD);
      clearInterval(loadInterval);
    }
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

  public function onPlayerStateChange(newState:Number):Void {
    trace("New player state: "+ newState);
  }

  public function onPlayerError(errorCode:Number):Void {
    trace("An error occurred: "+ errorCode);
  }
}