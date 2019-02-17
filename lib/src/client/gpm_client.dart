import 'package:http/http.dart';
import 'dart:convert';

import 'package:gpm_dart/src/models/models.dart';
import 'package:gpm_dart/src/client/utils.dart';
import 'package:gpm_dart/src/client/gpm_oauth_client.dart';
import 'package:gpm_dart/src/client/endpoints.dart';
import 'package:gpm_dart/src/client/oauth_request_client.dart';

class GooglePlayMusicClient {

  final OAuthRequestClient _oauthClient;

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
   * [OAuthRequestClient] for requests.
   *
   * Only use this constructor if you need to use a custom
   * [OAuthRequestClient] for some reason (e.g. mocking requests
   * for testing). In most cases you should use the other constructor and
   * [GooglePlayMusicOAuthClient]
   */
  static GooglePlayMusicClient fromOAuthClient(OAuthRequestClient client) {
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
    var client = await this._oauthClient.handleAuthorizationCode(
        code,
        saveCredentialsToFile
    );

    // TODO: better info on login errors

    return client != null;
  }

  /**
   * Wrapper around this client's [_oauthClient] tryLoginFromCachedCredentials
   */
  Future<bool> tryLoginFromCachedCredentials() async {
    var client = await this._oauthClient.tryLoginFromCachedCredentials();
    return client != null;
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

  /**
   *
   * Not sure on the max value for [maxTopTracks]
   *
   * Max value for [maxRelatedArtists] appears to be 20
   */
  Future<Response> artist(String artistId,
      {bool includeAlbums=true, int maxTopTracks=5, int maxRelatedArtists=20}) {
    return _makeGetRequest(GooglePlayMusicEndpoints.ARTIST, extraParams: {
      'nid': artistId,
      'include-albums': '$includeAlbums',
      'num-top-tracks': '$maxTopTracks',
      'num-related-artists': '$maxRelatedArtists'
    });
  }

  Future<Response> album(String albumId) {
    return _makeGetRequest(GooglePlayMusicEndpoints.ALBUM, extraParams: {
      'nid': albumId,
      //TODO: tracks are always included in response
      // 'include-tracks': includeTracks.toString()
    });
  }

  Future<Response> search(String query, {
      List<GooglePlayMusicSearchEntryType> types,
      int maxResults=50
  }) {
    return _makeGetRequest(GooglePlayMusicEndpoints.SEARCH, extraParams: {
      'q': query,
      'ct': GooglePlayMusicSearchEntryType.getSearchEntryTypeParamFromList(types),
      'max-results': '$maxResults',
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
    return _makePostRequest(GooglePlayMusicEndpoints.PLAYLIST_BATCH,
        body: PlaylistMutation.bodyFromMutationList([
          new CreatePlaylistMutation(name,
            description: description,
            isPublic: isPublic
          )
        ]));
  }

  Future<Response> deletePlaylist(String playlistId) {
    return _makePostRequest(GooglePlayMusicEndpoints.PLAYLIST_BATCH,
        body: PlaylistMutation.bodyFromMutationList([
          new DeletePlaylistMutation(playlistId)
        ]));
  }

  /**
   *
   * [name], [description], [isPublic] should be left as null if you
   * don't want to change their values
   */
  Future<Response> updatePlaylist(String playlistId, {
    String name=null,
    String description=null,
    bool isPublic=null,
  }) {
    return _makePostRequest(GooglePlayMusicEndpoints.PLAYLIST_BATCH,
      body: PlaylistMutation.bodyFromMutationList([
        new UpdatePlaylistMutation(playlistId,
          name: name,
          description: description,
          isPublic: isPublic
        )
      ]));
  }

  Future<Response> addToPlaylist(String playlistId, List<Track> songs) {
    // TODO: implement
    throw Exception('not implemented');
  }

//  Future<Response> removeFromPlaylist(List<PlaylistEntry> entries) {
//    // TODO: implement
//  }


  Future<Response> stream(String deviceId, String trackId,
      {String quality='hi'}) {

    Map<String,String> params ={
      'opt': quality,
      'pt': 'e',
      'net': 'mob',
      'dv': '0',
      'alt': 'json',
      'hl': 'en_US', // TODO: support other languages?
      'tier': 'aa' // TODO: support 'aa' or 'fr'
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

    return _oauthClient.getClient().get(uri.toString(),
      headers: headers
    );
  }



  // Typed methods
  Future<IncrementalResponse<Track>> libraryTyped({int maxResults=0, String startToken}) async {
    Response resp = await library(maxResults: maxResults, startToken: startToken);

    IncrementalResponse<Track> tracks = IncrementalResponse<Track>.fromJson(jsonDecode(resp.body));
    return tracks;
  }


  // Helpers

  Uri _getSkyJamUri(String endpoint, {Map<String,String> extraParams}) {
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

  Future<Response> _makeGetRequest(String endpoint, {Map<String,String> extraParams}) async {
    Uri uri = _getSkyJamUri(endpoint, extraParams: extraParams);
    print(uri.toString());
    return _oauthClient.getClient().get(uri.toString());
  }

  Future<Response> _makePostRequest(String endpoint, {Map body}) async {
    Uri uri = _getSkyJamUri(endpoint);
    return _oauthClient.getClient().post(uri.toString(),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(body)
    );
  }
}