import 'package:emcus_ipgsm_app/features/logs/models/log_entry.dart';

class SiteLogsResponse {
  SiteLogsResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SiteLogsResponse.fromJson(Map<String, dynamic> json) {
    return SiteLogsResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: SiteLogsData.fromJson(json['data']),
    );
  }

  final int statusCode;
  final String message;
  final SiteLogsData data;
}

class SiteLogsData {
  SiteLogsData({
    required this.fireCount,
    required this.faultCount,
    required this.allCount,
    required this.fire,
    required this.fault,
    required this.all,
  });

  factory SiteLogsData.fromJson(Map<String, dynamic> json) {
    return SiteLogsData(
      fireCount: json['fireCount'] as int,
      faultCount: json['faultCount'] as int,
      allCount: json['allCount'] as int,
      fire: (json['fire'] as List?)?.map((item) => LogEntry.fromJson(item as Map<String, dynamic>)).toList() ?? [],
      fault: (json['fault'] as List?)?.map((item) => LogEntry.fromJson(item as Map<String, dynamic>)).toList() ?? [],
      all: (json['all'] as List?)?.map((item) => LogEntry.fromJson(item as Map<String, dynamic>)).toList() ?? [],
    );
  }

  final int fireCount;
  final int faultCount;
  final int allCount;
  final List<LogEntry> fire;
  final List<LogEntry> fault;
  final List<LogEntry> all;
} 