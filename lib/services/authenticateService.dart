import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/config/secure_storage.dart';

class AuthenticateService{
  final _storage = new SecureStorage();
  static String token = "";

  String getToken(){
    return token;
  }

  _urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _saveToken(TokenResponse newToken) async {
    print("NEW TOKEN");
    token = newToken.accessToken;
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(token).forEach((match) => print(match.group(0)));
    SecureStorage().saveToken(
        accessToken: newToken.accessToken,
        refreshToken: newToken.refreshToken,
        tokenType: newToken.tokenType,
        idToken: newToken.idToken.toCompactSerialization());
  }

  Future<bool> authenticate() async {
    var isLoggedSuccessfully = false;
    //get values from securestorage and create a client
    var authorizationEndPoint = "https://keycloak.mignon.chat/auth/realms/posthoop";
    var clientId = "api";
    var redirectUriPort = "4200";

    Credential credential;
    bool refreshFail = false;
    bool accessTokenSaved = await _storage.getAccessToken() != null;
    //if there is an access token saved in the secure storage try to get a new token using the refresh token
    if (accessTokenSaved) {
      print("login using saved token");
      final tt = await _storage.getTokenType();
      final rt = await _storage.getRefreshToken();
      final it = await _storage.getIdToken();

      var issuer = await Issuer.discover(Uri.parse(authorizationEndPoint));
      var client = new Client(issuer, clientId);
      credential = client.createCredential(
        accessToken: null, // force use refresh to get new token
        tokenType: tt,
        refreshToken: rt,
        idToken: it,
      );

      credential.validateToken(validateClaims: true, validateExpiry: true);
      try {
        _saveToken(await credential.getTokenResponse());
        isLoggedSuccessfully = true;
      } catch (e) {
        print("Error during login (refresh) " + e.toString());
        refreshFail = true;
      }
    }
    if (!accessTokenSaved || refreshFail) {
      print("No access Token find");
      var issuer = await Issuer.discover(Uri.parse(authorizationEndPoint));
      var client = new Client(issuer, clientId);
      //auth from browser
      var authenticator = Authenticator(
        client,
        scopes: List<String>.of(['openid', 'profile', 'offline_access']),
        port: int.parse(redirectUriPort),
        urlLancher: _urlLauncher,
      );
      credential = await authenticator.authorize();
      closeWebView();
      //save Token
      _saveToken(await credential.getTokenResponse());
      isLoggedSuccessfully = true;
    }

    customGetTokenResponse() async {
      var token = await credential.getTokenResponse();
      print("called getTokenResponse, token expiration:" +
          token.expiresAt.toIso8601String());

      await _saveToken(token);
      return token;
    }

    return isLoggedSuccessfully;

    //call getTokenResponseFn before each http request to get a new token if old one is expired
    //var http = HttpFunctions()..getTokenResponseFn = customGetTokenResponse;

    //final response = await http.get('api/users/UserInfo'); // this call is authenticated
    //_userInfo = models.UserInfo.fromJson(response);
    //_userInfo =
    //   _userInfo.copyWith(id: response['userId'], mail: response['email']);
    //notifyListeners();
  }

  void logout() {
    //SecureStorage().clearToken().then((_) => notifyListeners());
    token = "";
    _storage.clearToken();
  }

}