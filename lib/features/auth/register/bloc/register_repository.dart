import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emcus_ipgsm_app/core/config/api_config.dart';
import 'package:emcus_ipgsm_app/core/endpoints/auth_endpoints.dart';
import 'package:emcus_ipgsm_app/core/utils/api_logger.dart';
import 'package:emcus_ipgsm_app/features/auth/register/models/register_response.dart';

class RegisterRepository {
  RegisterRepository({required http.Client client}) : _client = client;
  final http.Client _client;

  Future<RegisterResponse> register({
    required String fullName,
    required String companyName,
    required String email,
    required String password,
  }) async {
    final url = AuthEndpoints.register;
    final headers = ApiConfig.defaultHeaders;
    final body = {
      'username': fullName,
      'companyName': companyName,
      'email': email,
      'groupName': 'users',
      'password': password,
    };

    try {
      // Log request
      ApiLogger.logRequest(
        method: 'POST',
        url: url,
        headers: headers,
        body: body,
      );

      final response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      // Log response
      ApiLogger.logResponse(
        statusCode: response.statusCode,
        headers: response.headers,
        body: responseData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(responseData);
      } else {
        final error =
            responseData['message'] ??
            'Failed to register: ${response.statusCode}';
        ApiLogger.logError(error);
        throw Exception(error);
      }
    } on http.ClientException catch (e) {
      ApiLogger.logError(e);
      throw Exception('Network error occurred: ${e.message}');
    } catch (e) {
      ApiLogger.logError(e);
      throw Exception('An unexpected error occurred: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
