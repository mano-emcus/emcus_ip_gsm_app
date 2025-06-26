import 'dart:convert';
import 'dart:io';
import 'package:emcus_ipgsm_app/core/config/api_config.dart';
import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/core/utils/api_logger.dart';
import 'package:emcus_ipgsm_app/features/sites/models/site_notes_response.dart';
import 'package:http/http.dart' as http;

class SiteNoteRepository {
  SiteNoteRepository({AuthManager? authManager})
    : _authManager = authManager ?? AuthManager();
  final AuthManager _authManager;

  Future<SiteNotesResponse> fetchSiteNotes({required int siteId}) async {
    try {
      final idToken = await _authManager.getCurrentIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw Exception('No valid authentication token found');
      }
      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $idToken',
      };
      final url = 'https://ipgsm.emcus.co.in/api/sites/$siteId/notes';
      ApiLogger.logRequest(
        method: 'GET',
        url: url,
        headers: headers,
        body: null,
      );
      final response = await http.get(Uri.parse(url), headers: headers);
      ApiLogger.logResponse(
        statusCode: response.statusCode,
        headers: response.headers,
        body: response.body,
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return SiteNotesResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        await _authManager.logoutSilent();
        throw Exception('Authentication failed. Please sign in again.');
      } else {
        throw Exception('Failed to fetch site notes: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch site notes: ${e.toString()}');
    }
  }

  Future<SiteNoteCreationResponse> createSiteNote({
    required int siteId,
    required String noteTitle,
    required String noteContent,
    required String category,
  }) async {
    try {
      final idToken = await _authManager.getCurrentIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw Exception('No valid authentication token found');
      }
      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      };
      final url = 'https://ipgsm.emcus.co.in/api/sites/note';
      final body = jsonEncode({
        'siteId': siteId.toString(),
        'noteTitle': noteTitle,
        'noteContent': noteContent,
        'category': category,
      });
      ApiLogger.logRequest(
        method: 'POST',
        url: url,
        headers: headers,
        body: body,
      );
      final response = await http.post(
        Uri.parse(url),
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
        return SiteNoteCreationResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        await _authManager.logoutSilent();
        throw Exception('Authentication failed. Please sign in again.');
      } else {
        throw Exception('Failed to create site note: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to create site note: ${e.toString()}');
    }
  }
}
