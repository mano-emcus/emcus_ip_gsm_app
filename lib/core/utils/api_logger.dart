// ignore_for_file: avoid_print

import 'dart:convert';

class ApiLogger {
  static void logRequest({
    required String method,
    required String url,
    required Map<String, String> headers,
    required dynamic body,
  }) {
    print('\n📤 API Request:');
    print('URL: $method $url');
    print('Headers: ${jsonEncode(headers)}');
    print('Body: ${jsonEncode(body)}');
  }

  static void logResponse({
    required int statusCode,
    required Map<String, String> headers,
    required dynamic body,
  }) {
    print('\n📥 API Response:');
    print('Status Code: $statusCode');
    print('Headers: ${jsonEncode(headers)}');
    print('Body: ${jsonEncode(body)}');
  }

  static void logError(dynamic error) {
    print('\n❌ API Error:');
    print(error.toString());
  }
} 