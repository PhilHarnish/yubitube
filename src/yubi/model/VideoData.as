
import yubi.model.GData;

class yubi.model.VideoData {
  private static var FEED_METHOD:String = "/feeds/api/videos/";
  private static var FEED_ARGUMENTS:Object = {v: 2};
  
  private static var catalog:Object;

  public var videoId:String;
  public var valid:Boolean;
  public var metadataRequested:Boolean;
  public var author:String;
  public var title:String;
  public var description:String;

  function VideoData(id:String) {
    super();
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

  public static function fromXMLObject(xml:XMLNode):VideoData {
    var data:Object = GData.toObject(xml).entry;
    var media:Object = data['media:group'];
    var video:VideoData = fromId(media['yt:videoid'].value);
    video.author = data.author.name.value;
    video.title = media['media:title'].value;
    video.description = media['media:title'].description;
    return video;
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

    return result;
  }
  
  public function fetchMetadata():Boolean {
    if (metadataRequested) {
      return false;
    }
    metadataRequested = true;
    var gdata:GData = new GData();
    gdata.addListener(this);
    return gdata.request(FEED_METHOD + this.videoId, FEED_ARGUMENTS);
  }

  public function onLoad(success:Boolean, xml:XMLNode):Void {
    // Purge all that wasted space... I really really hate XML!
    fromXMLObject(xml);
    delete xml;
    trace("Loaded data!", success, this);
  }
}