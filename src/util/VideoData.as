
class util.VideoData {
  private static var catalog:Object;

  public var videoId:String;
  public var valid:Boolean;

  function VideoData(id:String) {
    videoId = id;

    valid = (videoId.length >= 11);

    if (catalog[id] && catalog[id] != this) {
      trace("warning", "Duplicate video data object created", this);
    } else {
      if (!catalog) {
        catalog = {};
      }
      catalog[id] = this;
    }
  }

  public static function fromId(id:String):VideoData {
    if (!catalog[id]) {
      return new VideoData(id);
    }

    return catalog[id];
  }
  
  public static function fromIds(ids:/*String*/Array):/*VideoData*/Array {
    var count:Number = ids.length;
    var result:/*VideoData*/Array = [];
    for (var i = 0; i < count; i++) {
      result.push(fromId(ids[i]));
    }
    trace(catalog, result);
    return result;
  }
  
}