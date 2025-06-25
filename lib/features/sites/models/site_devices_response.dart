class SiteDevicesResponse {
  SiteDevicesResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SiteDevicesResponse.fromJson(Map<String, dynamic> json) {
    return SiteDevicesResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List?)?.cast<dynamic>() ?? [],
    );
  }

  final int statusCode;
  final String message;
  final List<dynamic> data;
} 