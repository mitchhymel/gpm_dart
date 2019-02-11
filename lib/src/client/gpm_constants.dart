class GooglePlayMusicEndpoints {
  static const String SJ_URL_BASE = 'mclients.googleapis.com';
  static const String SJ_URL_PATH = '/sj/v2.5';

  static const String TRACKS = 'trackfeed';
  static const String PLAYLIST_FEED = 'playlistfeed';
  static const String PLAYLIST_BATCH = 'playlistbatch';
  static const String PLAYLIST_ENTRY_FEED = 'plentryfeed';
  static const String PLAYLIST_ENTRIES_BATCH = 'plentriesbatch';
  static const String SEARCH = 'query';
  static const String TRACK = 'fetchtrack';
  static const String ALBUM = 'fetchalbum';
  static const String ARTIST = 'fetchartist';
  static const String DEVICE_MANAGEMENT = 'devicemanagementinfo';
  static const String CONFIG = 'config';

  static const String STREAM_TRACK_PATH = '/music/mplay';
}

class GooglePlayMusicSearchEntryType {

  static const GooglePlayMusicSearchEntryType TRACK =
    GooglePlayMusicSearchEntryType._private(1);
  static const GooglePlayMusicSearchEntryType ARTIST =
    GooglePlayMusicSearchEntryType._private(2);
  static const GooglePlayMusicSearchEntryType ALBUM =
    GooglePlayMusicSearchEntryType._private(3);
  static const GooglePlayMusicSearchEntryType PLAYLIST =
    GooglePlayMusicSearchEntryType._private(4);
  static const GooglePlayMusicSearchEntryType SERIES =
    GooglePlayMusicSearchEntryType._private(5);
  static const GooglePlayMusicSearchEntryType STATION =
    GooglePlayMusicSearchEntryType._private(6);
  static const GooglePlayMusicSearchEntryType SITUATION =
    GooglePlayMusicSearchEntryType._private(7);
  static const GooglePlayMusicSearchEntryType YOUTUBE =
    GooglePlayMusicSearchEntryType._private(8);
  static const GooglePlayMusicSearchEntryType PODCAST =
    GooglePlayMusicSearchEntryType._private(9);

  final int value;
  const GooglePlayMusicSearchEntryType._private(this.value);

  @override
  String toString() {
    return this.value.toString();
  }

  static String getSearchEntryTypeParamFromList(
      List<GooglePlayMusicSearchEntryType> types) {
    if (types == null || types.isEmpty) {
      return '1%2C2%2C3%2C4%2C5%2C6%2C7%2C8%2C9';
    }

    return types.join('%2C');
  }

}