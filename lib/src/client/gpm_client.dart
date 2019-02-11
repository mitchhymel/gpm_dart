import 'package:http/http.dart';
import 'dart:convert';

import 'package:gpm_dart/src/models/models.dart';
import 'package:gpm_dart/src/client/utils.dart';
import 'package:gpm_dart/src/client/gpm_oauth_client.dart';
import 'package:gpm_dart/src/client/gpm_constants.dart';

class GooglePlayMusicClient {

  final GooglePlayMusicOAuthClient _oauthClient;
  Client _client;

  GooglePlayMusicClient._private(this._oauthClient);

  /**
   * Returns a [GooglePlayMusicClient] instance which will use a
   * [GooglePlayMusicOAuthClient] and store OAuth credentials in a file
   * at [path].
   *
   * You should almost always use this as a constructor.
   */
  static GooglePlayMusicClient fromPath(String path) {
    return new GooglePlayMusicClient._private(new GooglePlayMusicOAuthClient(path));
  }

  /**
   * Returns a [GooglePlayMusicClient] instance which will use the provided
   * [GooglePlayMusicOAuthClient] for requests.
   *
   * Only use this constructor if you need to use a custom
   * [GooglePlayMusicOAuthClient] for some reason (e.g. mocking requests
   * for testing).
   */
  static GooglePlayMusicClient fromOAuthClient(GooglePlayMusicOAuthClient client) {
    return new GooglePlayMusicClient._private(client);
  }

  /**
   * Wrapper around this client's [_oauthClient] getAuthorizationUrl
   */
  Uri getAuthorizationUrl() {
    return this._oauthClient.getAuthorizationUrl();
  }

  /**
   * Wrapper around this client's [_oauthClient] handleAuthorizationCode
   */
  Future<bool> handleAuthorizationCode(String code,
      {bool saveCredentialsToFile=false}) async {
    _client = await this._oauthClient.handleAuthorizationCode(
        code,
        saveCredentialsToFile
    );

    // TODO: better info on login errors

    return _client != null;
  }

  /**
   * Wrapper around this client's [_oauthClient] tryLoginFromCachedCredentials
   */
  Future<bool> tryLoginFromCachedCredentials() async {
    _client = await this._oauthClient.tryLoginFromCachedCredentials();
    return _client != null;
  }



  Future<Response> config() async {
    return _makeGetRequest(GooglePlayMusicEndpoints.CONFIG);
  }

  Future<Response> devices() async {
    return _makeGetRequest(GooglePlayMusicEndpoints.DEVICE_MANAGEMENT);
  }

  Future<Response> track(String trackId) {
    return _makeGetRequest(GooglePlayMusicEndpoints.TRACK, extraParams: {
      'nid': trackId
    });
  }

  Future<Response> artist(String artistId,
      {bool includeAlbums=true, int maxTopTracks=5, int maxRelatedArtists=5}) {
    return _makeGetRequest(GooglePlayMusicEndpoints.ARTIST, extraParams: {
      'nid': artistId,
      'include-albums': includeAlbums,
      'num-top-tracks': maxTopTracks,
      'num-related-artists': maxRelatedArtists
    });
  }

  Future<Response> album(String albumId, {bool includeTracks=true}) {
    return _makeGetRequest(GooglePlayMusicEndpoints.ALBUM, extraParams: {
      'nid': albumId,
      'include-tracks': includeTracks
    });
  }

  Future<Response> search(String query, {
      List<GooglePlayMusicSearchEntryType> types,
      int maxResults=50
  }) {
    return _makeGetRequest(GooglePlayMusicEndpoints.SEARCH, extraParams: {
      'q': query,
      'ct': GooglePlayMusicSearchEntryType.getSearchEntryTypeParamFromList(types),
      'max-results': maxResults,
    });
  }


  Future<Response> library({int maxResults=0, String startToken}) async {
    return _makePostRequest(GooglePlayMusicEndpoints.TRACKS, body: {
      'max-results': '$maxResults',
      'start-token': startToken,
    });
  }

  Future<Response> playlist({int maxResults=0, String startToken}) {
    return _makePostRequest(GooglePlayMusicEndpoints.PLAYLIST_FEED, body: {
      'max-results': maxResults,
      'start-token': startToken,
    });
  }

  Future<Response> playlistEntries({int maxResults=0, String startToken}) {
    return _makePostRequest(GooglePlayMusicEndpoints.PLAYLIST_ENTRY_FEED, body: {
      'max-results': maxResults,
      'start-token': startToken,
    });
  }

  Future<Response> createPlaylist(String name, {
    String description,
    bool isPublic=false,
  }) {

    return _makePostRequest(GooglePlayMusicEndpoints.PLAYLIST_BATCH, body: {
      'mutations': [{
          'create': {
            'name': name,
            'deleted': false,
            'creationTimestamp': '-1',
            'lastModifiedTimestamp': '0',
            'type': 'USER_GENERATED',
            'shareState': isPublic ? 'PUBLIC' : 'PRIVATE',
            'description': description
          }
      }]
    });
  }

  Future<Response> deletePlaylist(String playlistId) {
    return _makePostRequest(GooglePlayMusicEndpoints.PLAYLIST_BATCH, body: {
      'mutations': [{
        'delete': playlistId
      }]
    });
  }


  Future<Response> stream(String deviceId, String trackId,
      {String quality='hi'}) {

    Map<String,String> params ={
      'opt': quality,
      'pt': 'e',
      'net': 'mob',
    };

    if (Utils.trackIsAllAccess(trackId)) {
      params['mjck'] = trackId;
    }
    else {
      params['songid'] = trackId;
    }

    Map<String,String> saltAndSig = Utils.getSaltAndSign(trackId);
    params.addAll(saltAndSig);

    Uri uri = Uri.https(
      GooglePlayMusicEndpoints.SJ_URL_BASE,
      GooglePlayMusicEndpoints.STREAM_TRACK_PATH,
      params
    );

    String deviceIdToSend = Utils.getDeviceIdForStream(deviceId);
    Map<String,String> headers = {
      'X-Device-ID': deviceIdToSend
    };

    return _client.get(uri.toString(),
      headers: headers
    );
  }



  // Typed methods
  Future<IncrementalResponse<Track>> libraryTyped({int maxResults=0, String startToken}) async {
    Response resp = await library(maxResults: maxResults, startToken: startToken);

    IncrementalResponse<Track> tracks = IncrementalResponse<Track>.fromJson(jsonDecode(resp.body));
    return tracks;
  }



  Uri _getSkyJamUri(String endpoint, {Map extraParams}) {
    Map<String,String> params = {
      'dv': '0',
      'alt': 'json',
      'hl': 'en_US', // TODO: support other languages?
      'tier': 'aa' // TODO: support 'aa' or 'fr'
    };

    if (extraParams != null) {
      params.addAll(extraParams);
    }

    return Uri.https(
        GooglePlayMusicEndpoints.SJ_URL_BASE,
        '${GooglePlayMusicEndpoints.SJ_URL_PATH}/$endpoint',
        params
    );
  }

  Future<Response> _makeGetRequest(String endpoint, {Map extraParams}) async {
    Uri uri = _getSkyJamUri(endpoint, extraParams: extraParams);
    return _client.get(uri.toString());
  }

  Future<Response> _makePostRequest(String endpoint, {Map body}) async {
    Uri uri = _getSkyJamUri(endpoint);
    return _client.post(uri.toString(),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body)
    );
  }
}