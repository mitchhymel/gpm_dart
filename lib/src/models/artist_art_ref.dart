class ArtistArtRef {
  String kind;
  String url;
  String aspectRatio;
  bool autogen;

  ArtistArtRef({this.kind, this.url, this.aspectRatio, this.autogen});

  ArtistArtRef.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    url = json['url'];
    aspectRatio = json['aspectRatio'];
    autogen = json['autogen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['url'] = this.url;
    data['aspectRatio'] = this.aspectRatio;
    data['autogen'] = this.autogen;
    return data;
  }
}