
class model.GData extends XML {
  private static var BASE_URL:String = "http://gdata.youtube.com";
  private static var EVENT_LOAD:String = "onLoad";

  function GData () {
    AsBroadcaster.initialize(this);
  }
  
  public var addListener:Function;
  public var broadcastMessage:Function;

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
          if (result[nodeName] instanceof Array) {
            result[nodeName].push(toObject(child));
          } else {
            result[nodeName] = [result[nodeName]];
          }
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
