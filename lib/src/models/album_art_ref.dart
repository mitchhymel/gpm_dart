class AlbumArtRef {
  String kind;
  String url;

  AlbumArtRef({this.kind, this.url});

  AlbumArtRef.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['url'] = this.url;
    return data;
  }
}