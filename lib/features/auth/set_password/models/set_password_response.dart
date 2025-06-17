class SetPasswordResponse {
  factory SetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return SetPasswordResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: json['data'] as List<dynamic>,
    );
  }

  SetPasswordResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });
  final int statusCode;
  final String message;
  final List<dynamic> data;
}
