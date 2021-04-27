import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = new FlutterSecureStorage();

  getStoredValue(String storedValue) async {
    return await _storage.read(key: storedValue);
  }

  getTokenType() async {
    return await _storage.read(key: 'tokenType');
  }

  getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  getIdToken() async {
    return await _storage.read(key: 'idToken');
  }

  getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  void saveToken({accessToken, refreshToken, tokenType, idToken}) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(key: 'tokenType', value: tokenType);
    await _storage.write(key: 'idToken', value: idToken);
  }

  void clearToken() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'tokenType');
    await _storage.delete(key: 'idToken');
  }
}
