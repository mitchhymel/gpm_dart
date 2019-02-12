import 'artist_art_ref.dart';
import 'album_art_ref.dart';

class Track {
  String kind;
  String id;
  String clientId;
  String creationTimestamp;
  String lastModifiedTimestamp;
  String recentTimestamp;
  bool deleted;
  String title;
  String artist;
  String composer;
  String album;
  String albumArtist;
  int year;
  String comment;
  int trackNumber;
  String genre;
  String durationMillis;
  int beatsPerMinute;
  List<AlbumArtRef> albumArtRef;
  List<ArtistArtRef> artistArtRef;
  int playCount;
  int totalTrackCount;
  int discNumber;
  int totalDiscCount;
  String rating;
  String estimatedSize;
  String storeId;
  String albumId;
  List<String> artistId;
  String nid;

  Track(
      {this.kind,
        this.id,
        this.clientId,
        this.creationTimestamp,
        this.lastModifiedTimestamp,
        this.recentTimestamp,
        this.deleted,
        this.title,
        this.artist,
        this.composer,
        this.album,
        this.albumArtist,
        this.year,
        this.comment,
        this.trackNumber,
        this.genre,
        this.durationMillis,
        this.beatsPerMinute,
        this.albumArtRef,
        this.artistArtRef,
        this.playCount,
        this.totalTrackCount,
        this.discNumber,
        this.totalDiscCount,
        this.rating,
        this.estimatedSize,
        this.storeId,
        this.albumId,
        this.artistId,
        this.nid});

  Track.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    id = json['id'];
    clientId = json['clientId'];
    creationTimestamp = json['creationTimestamp'];
    lastModifiedTimestamp = json['lastModifiedTimestamp'];
    recentTimestamp = json['recentTimestamp'];
    deleted = json['deleted'];
    title = json['title'];
    artist = json['artist'];
    composer = json['composer'];
    album = json['album'];
    albumArtist = json['albumArtist'];
    year = json['year'];
    comment = json['comment'];
    trackNumber = json['trackNumber'];
    genre = json['genre'];
    durationMillis = json['durationMillis'];
    beatsPerMinute = json['beatsPerMinute'];
    if (json['albumArtRef'] != null) {
      albumArtRef = new List<AlbumArtRef>();
      json['albumArtRef'].forEach((v) {
        albumArtRef.add(new AlbumArtRef.fromJson(v));
      });
    }
    if (json['artistArtRef'] != null) {
      artistArtRef = new List<ArtistArtRef>();
      json['artistArtRef'].forEach((v) {
        artistArtRef.add(new ArtistArtRef.fromJson(v));
      });
    }
    playCount = json['playCount'];
    totalTrackCount = json['totalTrackCount'];
    discNumber = json['discNumber'];
    totalDiscCount = json['totalDiscCount'];
    rating = json['rating'];
    estimatedSize = json['estimatedSize'];
    storeId = json['storeId'];
    albumId = json['albumId'];
    artistId = json['artistId'].cast<String>();
    nid = json['nid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kind'] = this.kind;
    data['id'] = this.id;
    data['clientId'] = this.clientId;
    data['creationTimestamp'] = this.creationTimestamp;
    data['lastModifiedTimestamp'] = this.lastModifiedTimestamp;
    data['recentTimestamp'] = this.recentTimestamp;
    data['deleted'] = this.deleted;
    data['title'] = this.title;
    data['artist'] = this.artist;
    data['composer'] = this.composer;
    data['album'] = this.album;
    data['albumArtist'] = this.albumArtist;
    data['year'] = this.year;
    data['comment'] = this.comment;
    data['trackNumber'] = this.trackNumber;
    data['genre'] = this.genre;
    data['durationMillis'] = this.durationMillis;
    data['beatsPerMinute'] = this.beatsPerMinute;
    if (this.albumArtRef != null) {
      data['albumArtRef'] = this.albumArtRef.map((v) => v.toJson()).toList();
    }
    if (this.artistArtRef != null) {
      data['artistArtRef'] = this.artistArtRef.map((v) => v.toJson()).toList();
    }
    data['playCount'] = this.playCount;
    data['totalTrackCount'] = this.totalTrackCount;
    data['discNumber'] = this.discNumber;
    data['totalDiscCount'] = this.totalDiscCount;
    data['rating'] = this.rating;
    data['estimatedSize'] = this.estimatedSize;
    data['storeId'] = this.storeId;
    data['albumId'] = this.albumId;
    data['artistId'] = this.artistId;
    data['nid'] = this.nid;
    return data;
  }
}