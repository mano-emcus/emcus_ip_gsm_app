import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';

class LogsResponse {
  final int statusCode;
  final String message;
  final List<LogEntry> data;

  LogsResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory LogsResponse.fromJson(Map<String, dynamic> json) {
    return LogsResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => LogEntry.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class LogsErrorResponse {
  final String message;
  final String error;
  final int statusCode;

  LogsErrorResponse({
    required this.message,
    required this.error,
    required this.statusCode,
  });

  factory LogsErrorResponse.fromJson(Map<String, dynamic> json) {
    return LogsErrorResponse(
      message: json['message'] as String,
      error: json['error'] as String,
      statusCode: json['statusCode'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'error': error,
      'statusCode': statusCode,
    };
  }
} 