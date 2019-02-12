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
      return '1,2,3,4,5,6,7,8,9';
    }

    return types.join(',');
  }
}