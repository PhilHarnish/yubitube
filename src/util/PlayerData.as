
import util.Playlist;
import util.VideoData;

class util.PlayerData {

  public var playlist:Playlist;

  function PlayerData (data:Object) {
    playlist = new Playlist(VideoData.fromIds(data.video_id.split(',')));
  }

}
