import 'track.dart';

class Data<T> {
  List<T> items;

  Data({this.items});

  dynamic TfromJson(dynamic json) {
    if (json['kind'] == 'sj#track') {
      return Track.fromJson(json);
    }

    return json;
  }

  Map<String, dynamic> jsonFromT(dynamic obj) {
    if (T is Track) {
      return (obj as Track).toJson();
    }

    return obj;
  }



  Data.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<T>();
      json['items'].forEach((v) {
        items.add(TfromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => jsonFromT(v)).toList();
    }
    return data;
  }
}

class IncrementalResponse<T> {

  String kind;
  String nextPageToken;
  Data data;

  IncrementalResponse({this.kind, this.nextPageToken, this.data});

  IncrementalResponse.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    nextPageToken = json['nextPageToken'];
    data = json['data'] != null ? new Data<T>.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['nextPageToken'] = this.nextPageToken;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}