import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  static const String _tokenKey = 'id_token';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Singleton pattern
  static final TokenStorageService _instance = TokenStorageService._internal();
  factory TokenStorageService() => _instance;
  TokenStorageService._internal();

  /// Store the ID token
  Future<void> storeIdToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Store the access token
  Future<void> storeAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  /// Store the refresh token
  Future<void> storeRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  /// Store all tokens at once
  Future<void> storeTokens({
    required String idToken,
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_tokenKey, idToken),
      prefs.setString(_accessTokenKey, accessToken),
      prefs.setString(_refreshTokenKey, refreshToken),
    ]);
  }

  /// Get the ID token
  Future<String?> getIdToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get the access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Get the refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Check if user is signed in (has valid, non-expired ID token)
  Future<bool> isSignedIn() async {
    final idToken = await getIdToken();
    if (idToken == null || idToken.isEmpty) {
      return false;
    }
    return !_isTokenExpired(idToken);
  }

  /// Get a valid ID token (checks expiration)
  Future<String?> getValidIdToken() async {
    final idToken = await getIdToken();
    if (idToken == null || idToken.isEmpty) {
      return null;
    }
    
    if (_isTokenExpired(idToken)) {
      // Token is expired, clear it
      await clearTokens();
      return null;
    }
    
    return idToken;
  }

  /// Check if a JWT token is expired
  bool _isTokenExpired(String token) {
    try {
      // Split the token to get the payload
      final parts = token.split('.');
      if (parts.length != 3) return true;

      // Decode the payload (add padding if needed)
      String payload = parts[1];
      switch (payload.length % 4) {
        case 0:
          break;
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
        default:
          return true;
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> payloadMap = json.decode(decoded);

      // Check expiration
      final exp = payloadMap['exp'];
      if (exp == null) return true;

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      final now = DateTime.now();
      
      // Add a 30-second buffer to account for network delays
      return now.isAfter(expirationDate.subtract(const Duration(seconds: 30)));
    } catch (e) {
      // If we can't parse the token, consider it expired
      return true;
    }
  }

  /// Get token expiration time
  DateTime? getTokenExpiration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];
      switch (payload.length % 4) {
        case 0:
          break;
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
        default:
          return null;
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      final Map<String, dynamic> payloadMap = json.decode(decoded);

      final exp = payloadMap['exp'];
      if (exp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      return null;
    }
  }

  /// Clear all tokens (logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_tokenKey),
      prefs.remove(_accessTokenKey),
      prefs.remove(_refreshTokenKey),
    ]);
  }

  /// Clear only ID token
  Future<void> clearIdToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
} 