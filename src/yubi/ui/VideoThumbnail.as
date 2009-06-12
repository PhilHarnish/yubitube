
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;

import yubi.util.TabStyleFactory;

class yubi.ui.VideoThumbnail extends MovieClip {
  public static var PACKAGE:String = "__Packages.yubi.ui.VideoThumbnail";
  public static var LINKED:Boolean = Object.registerClass(PACKAGE,
                                                          VideoThumbnail);

  public static var DEFAULT:String = "DEFAULT";
  public static var HQ_DEFAULT:String = "HQ_DEFAULT";
  public static var FIRST:String = "FIRST";
  public static var SECOND:String = "SECOND";
  public static var THIRD:String = "THIRD";

  private static var TYPE_MAP:Object = {
    DEFAULT: 'default',
    HQ_DEFAULT: 'hqdefault',
    FIRST: '0',
    SECOND: '1',
    THIRD: '2'
  };
  private static var IMG_URL:String = "http://i.ytimg.com/vi/ID/TYPE.jpg";
  private static var DEFAULT_RECT:Rectangle = new Rectangle(0, 0, 120, 90);
  private static var HQ_DEFAULT_RECT:Rectangle = new Rectangle(0, 0, 480, 360);
  private static var NUMBERED_RECT:Rectangle = new Rectangle(0, 0, 320, 240);
  private static var SIZE_MAP:Object = {
    DEFAULT: DEFAULT_RECT,
    HQ_DEFAULT: HQ_DEFAULT_RECT,
    FIRST: NUMBERED_RECT,
    SECOND: NUMBERED_RECT,
    THIRD: NUMBERED_RECT
  };
  private static var WIDE_RECT:Rectangle = new Rectangle(0, 45, 480, 270);
  private static var WIDE_TEST:Rectangle = new Rectangle(-1, 43, 482, 274);

  private var id:String;
  private var type:String;
  private var thumbnailImage:MovieClip;

  function VideoThumbnail() {
    type = HQ_DEFAULT;
  }

  public function init(videoId:String, opt_type:String, opt_crop:Boolean):Void {
    id = videoId;
    if (opt_type) {
      type = opt_type;
    }
    _alpha = 0;
    
    load(opt_crop);
  }
  
  private function load(opt_crop:Boolean):Void {
    // create a MovieClipLoader to handle the loading of the thumbnail
    var thumbnailLoader:MovieClipLoader = new MovieClipLoader();
    thumbnailImage = createEmptyMovieClip("thumbnailImage", 1);

    if (opt_crop) {
      thumbnailLoader.addListener(this);
    }
    thumbnailLoader.loadClip(IMG_URL.split('ID').join(id).
                                     split('TYPE').join(TYPE_MAP[type]),
                             thumbnailImage);
  }
  
  public function setSize(newWidth:Number, newHeight:Number):Void {
    var width:Number = SIZE_MAP[type].width;
    setScale(newWidth / width * 100);
  }
  
  public function setScale(xscale:Number, opt_yscale:Number):Void {
    if (opt_yscale == undefined) {
      opt_yscale = xscale;
    }
    _xscale = xscale;
    _yscale = opt_yscale;
  }

  private function onLoadInit ():Void {
    // TODO: Support cropping for more aspect ratios.
    var w:Number = SIZE_MAP[type].width;
    var h:Number = SIZE_MAP[type].height;
    var bmpData:BitmapData = new BitmapData(w, h); //true and 0 color allows for transparency
    bmpData.draw(thumbnailImage, new Matrix(), TabStyleFactory.offsetColors(-32));
    bmpData.floodFill(5, 1, 0x00000000);
    bmpData.floodFill(5, h - 1, 0x00000000);
    bmpData.colorTransform(new Rectangle(0, 0, w, h), TabStyleFactory.offsetColors(-256));

    var maskMc:MovieClip = createEmptyMovieClip("maskMc", 2);
    var style:TabStyleFactory = new TabStyleFactory(maskMc);
    var maskRect:Rectangle = bmpData.getColorBoundsRect(0xFF000000, 0, false);
    if (WIDE_TEST.containsRectangle(maskRect)) {
      maskRect = WIDE_RECT;
    }
    trace("Rect", maskRect);
    thumbnailImage._y -= maskRect.y;
    maskRect.y = 0;
    style.setFill(0xFF0000).drawRect(maskRect);
    setMask(maskMc);
  }

}
