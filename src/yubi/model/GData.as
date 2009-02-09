/**
 * Makes requests to the YouTube GData feeds.
 * request() is called which will call "onLoad" on each of it's subscribers.
 * The toObject method is provided to convert the XML data into something easier
 * to navigate.
 */

class yubi.model.GData extends XML {
  private static var BASE_URL:String = "http://gdata.youtube.com";
  private static var EVENT_LOAD:String = "onLoad";

  function GData () {
    AsBroadcaster.initialize(this);
  }
  
  public var addListener:Function;
  public var broadcastMessage:Function;

  /**
   * Given an XMLNode an easy to navigate object is returned.
   *
   * Example:
   * <root>
   *   <list><a>1</a><a>2</a><b attr="b node"></list>
   * </root>
   * Becomes:
   * {root: {list: {a: [{value:1}, {value:2}], b: {attr:"b node"}}}}
   */
  public static function toObject(xml:XMLNode):Object {
    var result = {};

    // Copy children nodes
    if (xml.hasChildNodes() && xml.firstChild.nodeType == 3) {
      // Detect children text nodes
      result.value = xml.firstChild.nodeValue;
    } else {
      var length = xml.childNodes.length;
      for (var i = 0; i < length; i++) {
        var child:XMLNode = xml.childNodes[i];
        var nodeName = child.nodeName;
        if (result[nodeName]) {
          if (!(result[nodeName] instanceof Array)) {
            result[nodeName] = [result[nodeName]];
          }
          result[nodeName].push(toObject(child));
        } else {
          result[nodeName] = toObject(child);
        }
      }
    }
    // Add attributes
    for (var key:String in xml.attributes) {
      result[key] = xml.attributes[key];
    }
    return result;
  }

  /**
   * method is an absolute path to the GData request path
   * (ex: "/feeds/api/videos/")
   * opt_arguments are additional url parameters
   * (ex: {v: 2})
   *
   * When the load completes, calls onLoad in subscribed listners.
   */
  public function request(method:String, opt_arguments:Object):Boolean {
    var args:String;
    if (opt_arguments) {
      var argsArray:/*String*/Array = [];
      for (var key:String in opt_arguments) {
        argsArray.push(key + '=' + opt_arguments[key]);
      }
      args = "?" + argsArray.join('&');
    }
    return load(BASE_URL + method + args);
  }

  public function onLoad(success:Boolean):Void {
    broadcastMessage(EVENT_LOAD, success, this);
    trace("Loaded XML data", success, toObject(this));
  }
}
