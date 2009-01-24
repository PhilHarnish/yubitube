
class ui.BroadcastingDisplayObject extends MovieClip {
  function BroadcastingDisplayObject() {
    AsBroadcaster.initialize(this);
  }

  public var addListener:Function;

  public var broadcastMessage:Function;

  public var removeListener:Function;
}