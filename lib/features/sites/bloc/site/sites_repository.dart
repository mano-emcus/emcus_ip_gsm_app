import 'dart:convert';
import 'dart:io';
import 'package:emcus_ipgsm_app/core/config/api_config.dart';
import 'package:emcus_ipgsm_app/core/endpoints/auth_endpoints.dart';
import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/core/utils/api_logger.dart';
import 'package:emcus_ipgsm_app/features/sites/models/sites_response.dart';
import 'package:http/http.dart' as http;

class SitesRepository {
  SitesRepository({AuthManager? authManager, required http.Client client})
    : _authManager = authManager ?? AuthManager(),
      _client = client;
  
  final AuthManager _authManager;
  final http.Client _client;

  Future<SitesResponse> fetchSites() async {
    try {
      // Get the stored ID token for authorization
      final idToken = await _authManager.getCurrentIdToken();

      if (idToken == null || idToken.isEmpty) {
        throw AuthenticationException('No valid authentication token found');
      }

      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $idToken',
      };

      ApiLogger.logRequest(
        method: 'GET',
        url: AuthEndpoints.sites,
        headers: headers,
        body: null,
      );

      final response = await _client.get(
        Uri.parse(AuthEndpoints.sites),
        headers: headers,
      );

      ApiLogger.logResponse(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return SitesResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        // Token is expired or invalid, clear tokens
        await _authManager.logoutSilent();
        throw AuthenticationException('Authentication failed. Please sign in again.');
      } else {
        throw Exception('Failed to fetch sites: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch sites: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}

class AuthenticationException implements Exception {
  AuthenticationException(this.message);
  final String message;

  @override
  String toString() => 'AuthenticationException: $message';
}