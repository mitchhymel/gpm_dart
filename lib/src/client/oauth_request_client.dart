import 'package:oauth2/oauth2.dart' as oauth2;

abstract class OAuthRequestClient {
  /**
   * Gets an authorization url that the user can visit and follow the steps
   * to obtain a code to login.
   */
  Uri getAuthorizationUrl();

  /**
   * Performs OAuth login with the provided [code]. Will write the creds to
   * a [credentialsFilePath] if [saveCredentialsToFile] is set to true.
   */
  Future<oauth2.Client> handleAuthorizationCode(String code, bool saveCredentialsToFile);

  /**
   * Attempts to perform OAuth login from credentials saved at
   * [credentialsFilePath].
   */
  Future<oauth2.Client> tryLoginFromCachedCredentials();

  /**
   * Returns an http client configured with proper auth headers to use
   * for http requests
   */
  oauth2.Client getClient();
}