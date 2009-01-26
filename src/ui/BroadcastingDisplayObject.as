
class ui.BroadcastingDisplayObject extends MovieClip {
  
  static var EVENT_LOAD:String = "onDisplayLoad"
  static var EVENT_UPDATE:String = "onDisplayUpdate"
  
  function BroadcastingDisplayObject() {
    AsBroadcaster.initialize(this);
  }
  
  public function bind (thisObj:Object, func:Function):Function {
    return function() {
      func.apply(thisObj, arguments);
    }
  }

  public var addListener:Function;

  public var broadcastMessage:Function;

  public var removeListener:Function;
}