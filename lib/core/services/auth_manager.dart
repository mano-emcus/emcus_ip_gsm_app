import 'package:emcus_ipgsm_app/core/services/token_storage_service.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:flutter/material.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  AuthManager._internal();

  final TokenStorageService _tokenStorageService = TokenStorageService();

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    return await _tokenStorageService.isSignedIn();
  }

  /// Get the current user's ID token
  Future<String?> getCurrentIdToken() async {
    return await _tokenStorageService.getValidIdToken();
  }

  /// Get the current user's access token
  Future<String?> getCurrentAccessToken() async {
    return await _tokenStorageService.getAccessToken();
  }

  /// Get the current user's refresh token
  Future<String?> getCurrentRefreshToken() async {
    return await _tokenStorageService.getRefreshToken();
  }

  /// Logout the current user and navigate to sign-in screen
  Future<void> logout(BuildContext context) async {
    try {
      // Clear all stored tokens
      await _tokenStorageService.clearTokens();
      
      // Navigate to sign-in screen and remove all previous routes
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SignInScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      // Handle any errors that might occur during logout
      debugPrint('Error during logout: $e');
      // You could also show a snackbar or dialog here if needed
    }
  }

  /// Logout without navigation (useful for background operations)
  Future<void> logoutSilent() async {
    try {
      await _tokenStorageService.clearTokens();
    } catch (e) {
      debugPrint('Error during silent logout: $e');
    }
  }

  /// Store authentication tokens
  Future<void> storeAuthTokens({
    required String idToken,
    required String accessToken,
    required String refreshToken,
  }) async {
    await _tokenStorageService.storeTokens(
      idToken: idToken,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
} 