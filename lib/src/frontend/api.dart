import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:amazon_cognito_identity_dart_2/cognito.dart' as cognito;

import 'all.dart';

/// The timeout handler definition used by the [BaseAppApi].
typedef ApiTimeoutHandler<TResponse> = FutureOr<TResponse?> Function()?;

/// The base API implementation for making live and mocked web requests.
class BaseAppApi<TConfig extends BaseClientConfig> {
  BaseAppApi({
    required this.config,
    required this.httpClient,
  }) {
    timeout = Duration(seconds: config.timeoutSeconds);
    if (config.cognitoEnabled) {
      cognitoClient = cognito.Client(
        client: httpClient,
        endpoint: config.cognitoEndpoint,
      );
      userPool = cognito.CognitoUserPool(
        config.cognitoUserPoolId,
        config.cognitoClientId,
        clientSecret: config.cognitoClientSecret,
        endpoint: config.cognitoEndpoint,
        customClient: cognitoClient,
      );
    } else {
      _user = null;
      userPool = null;
      cognitoClient = null;
    }
  }

  /// The configured request timeout [Duration].
  late final Duration timeout;

  /// The [TConfig] instance from the registry.
  final TConfig config;

  /// The [http.Client] used for making requests.
  /// This can be used for custom HTTP calls by a derived API.
  final http.Client httpClient;

  /// The [cognito.Client] wrapping the [httpClient] for Cognito requests.
  /// This can be used in custom Cognito calls by a derived API.
  late final cognito.Client? cognitoClient;

  /// The [cognito.CognitoUserPool] using the [cognitoClient] and underlying
  /// [httpClient] for authentication. This can be used in custom Cognito
  /// calls by a derived API.
  late final cognito.CognitoUserPool? userPool;

  /// Stores the actively authenticated [cognito.CognitoUser], if any.
  cognito.CognitoUser? _user;

  /// Accesses the actively authenticated [cognito.CognitoUser], if any.
  cognito.CognitoUser? get user => _user;

  /// Stores the active authentication JWT for an authenticated user, if any.
  String? _authToken;

  /// The underlying concrete implementation for making requests.
  ///
  /// This method uses [ApiRequest] to execute the [request] and get a
  /// [TResponse] from the [url] according to the [config]. The response will
  /// is created by the [fromJson] deserializer. The authentication token is
  /// injected by `this` API instance when the [login] and [logout] methods are
  /// used for authenticating.
  Future<TResponse?> makeRequest<TResponse extends ResponseBase,
      TRequest extends RequestBase>({
    required String url,
    required TRequest request,
    required TConfig config,
    required JsonDeserializer<TResponse> fromJson,
    ApiTimeoutHandler<TResponse> onTimeout,
  }) {
    return ApiRequest<TRequest, TResponse>(
        request: request,
        httpClient: httpClient,
        resolveUrl: config.resolveUrl,
        requestConfig: ApiRequestConfig(
          url: config.resolveUrl(url),
          authToken: _authToken,
          fromJson: fromJson,
        )).getResponse().timeout(timeout, onTimeout: onTimeout);
  }

  /// Builds the URL for a hosted signin experience.
  String hostedLoginUrl() {
    if (!config.cognitoEnabled) {
      throw StateError('Cannot use login URL with Cognito disabled.');
    }

    return "https://${config.cognitoEndpoint}/oauth2/authorize?redirect_uri="
        "myapp://&response_type=CODE&client_id=${config.cognitoClientId}&scope="
        "email%20openid%20profile%20aws.cognito.signin.user.admin";
  }

  /// Attempts to extract the authorization code from the provided [url].
  /// Returns the code, if found, otherwise `null`.
  String? hostedCodeCapture(String url) {
    if (!config.cognitoEnabled) {
      throw StateError('Cannot capture code with Cognito disabled.');
    }

    if (url.startsWith("myapp://?code=")) {
      return url.substring("myapp://?code=".length);
    }
    return null;
  }

  /// Completes the hosted signin process with the [hostedCode] and sets the API [user].
  Future<void> hostedCodeLogin(String hostedCode) async {
    if (!config.cognitoEnabled) {
      throw StateError('Cannot login with Cognito disabled.');
    }

    final endpoint = Uri.parse(config.cognitoEndpoint!);
    final url = endpoint.resolve("/oauth2/token?"
        "grant_type=authorization_code&client_id=${config.cognitoClientId}&"
        "code=$hostedCode&redirect_uri=myapp://");

    final response = await httpClient.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );
    if (response.statusCode != 200) {
      throw HttpError.fromResponse(response);
    }

    final tokenData = jsonDecode(response.body) as Map<String, dynamic>;

    final idToken = cognito.CognitoIdToken(
      tokenData['id_token'] as String?,
    );
    final accessToken = cognito.CognitoAccessToken(
      tokenData['access_token'] as String?,
    );
    final refreshToken = cognito.CognitoRefreshToken(
      tokenData['refresh_token'] as String?,
    );
    final session = cognito.CognitoUserSession(
      idToken,
      accessToken,
      refreshToken: refreshToken,
    );
    final user = cognito.CognitoUser(
      null,
      userPool!,
      signInUserSession: session,
    );

    // NOTE: in order to get the email from the list of user attributes, make sure you select email in the list of
    // attributes in Cognito and map it to the email field in the identity provider.
    final attributes = (await user.getUserAttributes()) ?? [];
    for (cognito.CognitoUserAttribute attribute in attributes) {
      if (attribute.getName() == "email") {
        user.username = attribute.getValue();
        break;
      }
    }

    final jwt = session.getAccessToken().getJwtToken();
    if (jwt != null) {
      _authToken = jwt;
    }

    _user = user;
  }

  /// Attempts to authenticate a user by [username] and [password] against the
  /// [userPool]. If successful, the [user] instance is holds the authenticated
  /// user. The user JWT is held internally and attached to request through the
  /// [makeRequest] implementation.
  Future<bool> login(String username, String password) async {
    if (!config.cognitoEnabled) {
      throw StateError('Cannot login with Cognito disabled.');
    }

    _user = cognito.CognitoUser(username, userPool!);
    final session = await user!.authenticateUser(cognito.AuthenticationDetails(
      username: username,
      password: password,
    ));
    final jwt = session?.getAccessToken().getJwtToken();

    if (jwt != null) {
      _authToken = jwt;
      return true;
    }

    return false;
  }

  /// Logs out and releases the [user], and destroys the underlying JWT.
  Future<void> logout() async {
    if (!config.cognitoEnabled) {
      throw StateError('Cannot logout with Cognito disabled.');
    }

    if (_user != null) {
      await _user!.signOut();
      _user = null;
    }
    if (_authToken != null) {
      _authToken = null;
    }
  }
}
