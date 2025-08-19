import 'dart:convert';
import 'dart:io';
import 'package:emcus_ipgsm_app/core/config/api_config.dart';
import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:emcus_ipgsm_app/core/utils/api_logger.dart';
import 'package:emcus_ipgsm_app/features/sites/models/site_devices_response.dart';
import 'package:http/http.dart' as http;

class SiteDevicesRepository {
  SiteDevicesRepository({AuthManager? authManager})
    : _authManager = authManager ?? AuthManager();
  final AuthManager _authManager;

  Future<GatewaysResponse> fetchSiteGateways({required int siteId}) async {
    try {
      final idToken = await _authManager.getCurrentIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw Exception('No valid authentication token found');
      }
      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $idToken',
      };
      // final url = 'https://ipgsm.emcus.co.in/api/sites/$siteId/gateways';
      final url = 'http://kiddeapi.emcus.co.in/api/sites/$siteId/gateways';
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
        return GatewaysResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        await _authManager.logoutSilent();
        throw Exception('Authentication failed. Please sign in again.');
      } else {
        throw Exception(
          'Failed to fetch site gateways: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to fetch site gateways: ${e.toString()}');
    }
  }
}
