import 'dart:convert';
import 'dart:io';
import 'package:emcus_ipgsm_app/core/config/api_config.dart';
import 'package:emcus_ipgsm_app/core/endpoints/auth_endpoints.dart';
import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/core/utils/api_logger.dart';
import 'package:emcus_ipgsm_app/features/notes/models/notes_response.dart';
import 'package:http/http.dart' as http;

class NotesRepository {
  NotesRepository({AuthManager? authManager})
    : _authManager = authManager ?? AuthManager();
  final AuthManager _authManager;

  Future<NotesResponse> fetchNotes() async {
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
        url: AuthEndpoints.notes,
        headers: headers,
        body: null,
      );

      final response = await http.get(
        Uri.parse(AuthEndpoints.notes),
        headers: headers,
      );

      ApiLogger.logResponse(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return NotesResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        // Token is expired or invalid, clear tokens
        await _authManager.logoutSilent();
        final errorResponse = NotesErrorResponse.fromJson(responseData);
        throw AuthenticationException(errorResponse.message);
      } else {
        throw Exception('Failed to fetch notes: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to fetch notes: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createNote({
    required String noteTitle,
    required String noteContent,
  }) async {
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

      final body = jsonEncode({
        'noteTitle': noteTitle,
        'noteContent': noteContent,
      });

      ApiLogger.logRequest(
        method: 'POST',
        url: AuthEndpoints.notes,
        headers: headers,
        body: body,
      );

      final response = await http.post(
        Uri.parse(AuthEndpoints.notes),
        headers: headers,
        body: body,
      );

      ApiLogger.logResponse(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check if the API returned success based on statusCode in response body
        if (responseData['statusCode'] == 1) {
          return responseData;
        } else {
          final errorMessage = responseData['message'] ?? 'Failed to create note';
          throw Exception(errorMessage);
        }
      } else if (response.statusCode == 401) {
        // Token is expired or invalid, clear tokens
        await _authManager.logoutSilent();
        throw AuthenticationException('Authentication failed. Please sign in again.');
      } else {
        final errorMessage = responseData['message'] ?? 'Failed to create note';
        throw Exception(errorMessage);
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      throw Exception('Failed to create note: ${e.toString()}');
    }
  }
}

class AuthenticationException implements Exception {
  AuthenticationException(this.message);
  final String message;

  @override
  String toString() => 'AuthenticationException: $message';
} 