import 'package:oauth2/oauth2.dart' as oauth2;
import 'dart:io';
import 'package:gpm_dart/src/client/oauth_request_client.dart';

class GooglePlayMusicOAuthClient extends OAuthRequestClient {

  static const String authorizationEndpoint = 'https://accounts.google.com/o/oauth2/v2/auth';
  static const String tokenEndpoint = 'https://www.googleapis.com/oauth2/v4/token';
  static const String revokeEndpoint = 'https://accounts.google.com/o/oauth2/revoke';
  static const String deviceEndpoint = 'https://accounts.google.com/o/oauth2/device/code';
  static const String tokenInfoEndpoint = 'https://www.googleapis.com/oauth2/v3/tokeninfo';

  static const String clientId = '228293309116.apps.googleusercontent.com';
  static const String secret = 'GL1YV0XMp0RlL7ylCV3ilFz-';
  static const String scope = 'https://www.googleapis.com/auth/skyjam';
  static const String redirectUri = 'urn:ietf:wg:oauth:2.0:oob';

  static const String accessType = 'offline';
  static const String responseType = 'code';

  final String credentialsFilePath;
  oauth2.AuthorizationCodeGrant _grant;
  oauth2.Credentials _credentials;

  GooglePlayMusicOAuthClient(this.credentialsFilePath) {
    this._grant = new oauth2.AuthorizationCodeGrant(
      clientId,
      Uri.parse(authorizationEndpoint),
      Uri.parse(tokenEndpoint),
      secret: secret,
    );
  }

  /**
   * Gets an authorization url that the user can visit and follow the steps
   * to obtain a code to login.
   */
  @override
  Uri getAuthorizationUrl() {
    return _grant.getAuthorizationUrl(
        Uri.parse(redirectUri),
        scopes: [scope]
    );
  }

  /**
   * Performs OAuth login with the provided [code]. Will write the creds to
   * a [credentialsFilePath] if [saveCredentialsToFile] is set to true.
   */
  @override
  Future<oauth2.Client> handleAuthorizationCode(String code, bool saveCredentialsToFile) async {
    oauth2.Client client = await _grant.handleAuthorizationCode(code);
    _credentials = client.credentials;

    if (saveCredentialsToFile) {
      File credsFile = new File(credentialsFilePath);
      await credsFile.writeAsString(client.credentials.toJson());
    }

    return client;
  }

  /**
   * Attempts to perform OAuth login from credentials saved at
   * [credentialsFilePath].
   */
  @override
  Future<oauth2.Client> tryLoginFromCachedCredentials() async {
    File credsFile = new File(credentialsFilePath);
    bool credsFileExists = await credsFile.exists();

    if (!credsFileExists) {
      return null;
    }

    String credsFileString = await credsFile.readAsString();
    oauth2.Credentials creds = new oauth2.Credentials.fromJson(credsFileString);
    _credentials = creds;
    return getClient();
  }

  /**
   * Returns an http client configured with proper auth headers to use
   * for http requests
   */
  @override
  oauth2.Client getClient() {
    if (_credentials == null) {
      return null;
    }

    return oauth2.Client(
        _credentials,
        identifier: clientId,
        secret: secret,
    );
  }
}