/**
 * TabStyleFactory is a utility for building UI, managing colors, etc.
 *
 * Should there ever be a need for a different StyleFactory then a base class
 * could be made. I don't expect there to be more than one though.
 */

import flash.filters.BlurFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;

class util.TabStyleFactory {
  
  public static var POINT_ORIGIN:Point = new Point(0, 0);
  public static var SMOOTH:BlurFilter = new BlurFilter(1.1, 1.1, 2);
  public static var NO_COLOR_TRANSFORM:ColorTransform = new ColorTransform(4);
  
  private static var defaultBaseColor:Number;
  private static var defaultHighlightColor:Number;
  
  private var target:MovieClip;
  private var baseColor:Number;
  private var highlightColor:Number;
  
  public function TabStyleFactory(mc:MovieClip) {
    target = mc;
    baseColor = defaultBaseColor;
    highlightColor = defaultHighlightColor;
  }
  
  public static function setDefaultColors(base:Number, highlight:Number):Void {
    // FIXME: This won't work with multiple embeds in a single SWF
    defaultBaseColor = base;
    defaultHighlightColor = highlight;
  }
  
  public static function offsetColors(amount:Number):ColorTransform {
    return new ColorTransform(1, 1, 1, 1, amount, amount, amount, 0);
  }

  public function setFill(rgb:Number, opt_alpha:Number):TabStyleFactory {
    target.beginFill(rgb, opt_alpha);
    return this;
  }

  public function drawRect(rect:Rectangle):TabStyleFactory {
    return drawDimensions(rect.x, rect.y, rect.width, rect.height);
  }
  
  public function drawDimensions(x:Number,
                                 y:Number,
                                 width:Number,
                                 height:Number):TabStyleFactory {
    target.moveTo(x, y);
    target.lineTo(x + width, y);
    target.lineTo(x + width, y + height);
    target.lineTo(x, y + height);
    target.lineTo(x, y);
    return this; 
  }

}
