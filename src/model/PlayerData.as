
import model.Playlist;
import model.VideoData;

class model.PlayerData {

  public var playlist:Playlist;
  public var baseColor:Number = 0xCCCCCC;
  public var highlightColor:Number = 0x990000;

  function PlayerData (data:Object) {
    playlist = new Playlist(VideoData.fromIds(data.video_id.split(',')));
    baseColor = Number(data.color1) || baseColor;
    highlightColor = Number(data.color2) || highlightColor;
  }

}
