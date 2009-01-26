/**
 * TabStyleFactory is a utility for building UI, managing colors, etc.
 *
 * Should there ever be a need for a different StyleFactory then a base class
 * could be made. I don't expect there to be more than one though.
 */

class util.TabStyleFactory {
  
  private var baseColor:Number;
  private var highlightColor:Number;
  
  public function TabStyleFactory(base:Number, highlight:Number) {
    baseColor = base;
    highlightColor = highlight;
  }
}
