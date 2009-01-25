
import util.VideoData;

class util.Playlist {

  private var allData:/*VideoData*/Array;
  private var lastFilteredData:/*VideoData*/Array;
  private var filters:Object;

  function Playlist(initialData:/*VideoData*/Array, opt_filters:Object) {
    allData = initialData;
    if (!opt_filters) {
      opt_filters = {
        validOnly: true
      };
    }

    setFilter(opt_filters);
  }

  public function setFilter(newFilter:Object):Void {
    filters = newFilter;
    lastFilteredData = filter(filters);
  }

  public function getVideoData(opt_filters:Object):/*VideoData*/Array {
    if (!opt_filters) {
      // Use last set filter
      return lastFilteredData;
    } else if (filters.all) {
      return allData;
    }

    return filter(opt_filters);
  }

  public function filter(filters:Object):/*VideoData*/Array {
    var count:Number = allData.length;
    var result:/*VideoData*/Array = [];
    for (var i = 0; i < count; i++) {
      var video:VideoData = allData[i];
      if (filters.validOnly && !video.valid) {
        continue;
      }
      result.push(video);
    }
    return result;
  }

}