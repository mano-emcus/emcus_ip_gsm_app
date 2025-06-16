import 'dart:convert';
import 'dart:io';
import 'package:emcus_ipgsm_app/core/config/api_config.dart';
import 'package:emcus_ipgsm_app/core/endpoints/auth_endpoints.dart';
import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/core/utils/api_logger.dart';
import 'package:emcus_ipgsm_app/features/logs/models/logs_response.dart';
import 'package:http/http.dart' as http;

class LogsRepository {
  final AuthManager _authManager;

  LogsRepository({AuthManager? authManager})
      : _authManager = authManager ?? AuthManager();

  Future<LogsResponse> fetchLogs() async {
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
        url: AuthEndpoints.logs,
        headers: headers,
        body: null,
      );

      final response = await http.get(
        Uri.parse(AuthEndpoints.logs),
        headers: headers,
      );

      ApiLogger.logResponse(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return LogsResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        // Token is expired or invalid, clear tokens
        await _authManager.logoutSilent();
        final errorResponse = LogsErrorResponse.fromJson(responseData);
        throw AuthenticationException(errorResponse.message);
      } else {
        throw Exception('Failed to fetch logs: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch logs: ${e.toString()}');
    }
  }
}

class AuthenticationException implements Exception {
  final String message;
  
  AuthenticationException(this.message);
  
  @override
  String toString() => 'AuthenticationException: $message';
} 