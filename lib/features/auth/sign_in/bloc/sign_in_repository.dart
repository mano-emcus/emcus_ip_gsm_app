import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emcus_ipgsm_app/core/config/api_config.dart';
import 'package:emcus_ipgsm_app/core/endpoints/auth_endpoints.dart';
import 'package:emcus_ipgsm_app/core/utils/api_logger.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/models/sign_in_response.dart';

class SignInRepository {
  final http.Client _client;

  SignInRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<SignInResponse> signIn({
    required String email,
    required String password,
  }) async {
    final url = AuthEndpoints.signIn;
    final headers = ApiConfig.defaultHeaders;
    final body = {
      'email': email,
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
        return SignInResponse.fromJson(responseData);
      } else {
        final error = responseData['message'] ?? 'Failed to sign in: ${response.statusCode}';
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