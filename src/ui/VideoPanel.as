
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import model.VideoData;
import ui.BroadcastingDisplayObject;
import ui.ChromelessPlayer;
import util.TabStyleFactory;

class ui.VideoPanel extends BroadcastingDisplayObject {
  public static var PACKAGE:String = "__Packages.ui.VideoPanel";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE, VideoPanel);

  private static var IMG_URL:String = "http://i.ytimg.com/vi/ID/hqdefault.jpg";
  private static var WIDE_RECT:Rectangle = new Rectangle(0, 45, 480, 270);
  private static var WIDE_TEST:Rectangle = new Rectangle(-1, 43, 482, 274);
  private static var IMG_WIDTH:Number = 480;
  private static var IMG_HEIGHT:Number = 360;

  private var videoPlayer:ChromelessPlayer;
  private var thumbnail:MovieClip;
  private var thumbnailImage:MovieClip;
  private var thumbnailMask:MovieClip;
  private var videoId:String;
  private var active:Boolean;
  private var width:Number;
  private var height:Number;

  function VideoPanel (style:TabStyleFactory) {
    super();

    width = 320;
    height = 240;

    videoPlayer = ChromelessPlayer(attachMovie(ChromelessPlayer.PACKAGE,
                                               "videoPlayer",
                                               1));
    thumbnail = createEmptyMovieClip("thumbnail", 2);
    //thumbnail.filters = [TabStyleFactory.SMOOTH]

    videoPlayer.addListener(this);
    videoPlayer._visible = false;

    setActive(false);
  }

  public function init(id:String):Void {
    videoId = id;
    // create a MovieClipLoader to handle the loading of the thumbnail
    var thumbnailLoader:MovieClipLoader = new MovieClipLoader();
    thumbnailImage = thumbnail.createEmptyMovieClip("thumbnailImage", 1);

    thumbnailLoader.addListener(this);
    thumbnailLoader.loadClip(IMG_URL.split('ID').join(videoId), thumbnailImage);
  }

  public function onLoadInit ():Void {
    trace("on load init..");
    var w = IMG_WIDTH;
    var h = IMG_HEIGHT;
    var bmpData:BitmapData = new BitmapData(w, h); //true and 0 color allows for transparency
    bmpData.draw(thumbnailImage, new Matrix(), TabStyleFactory.offsetColors(-32));
    bmpData.floodFill(5, 1, 0x00000000);
    bmpData.floodFill(5, h - 1, 0x00000000);
    bmpData.colorTransform(new Rectangle(0, 0, w, h), TabStyleFactory.offsetColors(-256));

    var maskMc:MovieClip = thumbnail.createEmptyMovieClip("maskMc", 3);
    var style:TabStyleFactory = new TabStyleFactory(maskMc);
    var maskRect:Rectangle = bmpData.getColorBoundsRect(0xFF000000, 0, false);
    if (WIDE_TEST.containsRectangle(maskRect)) {
      maskRect = WIDE_RECT;
    }
    trace("Rect", maskRect);
    thumbnailImage._y -= maskRect.y;
    maskRect.y = 0;
    style.setFill(0xFF0000).drawRect(maskRect);
    thumbnail.setMask(maskMc);
  }

  public function setSize(newWidth:Number, newHeight:Number):Void {
    width = newWidth;
    height = newHeight;
    var scale:Number = newWidth / IMG_WIDTH * 100;
    thumbnail._xscale = scale;
    thumbnail._yscale = scale;
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

}
