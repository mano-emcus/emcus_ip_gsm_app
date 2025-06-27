class Gateway {
  Gateway({
    required this.id,
    required this.serialNumber,
    required this.company,
    required this.createdAt,
    required this.category,
  });

  factory Gateway.fromJson(Map<String, dynamic> json) {
    return Gateway(
      id: json['id'] as int,
      serialNumber: json['serialNumber'] as String,
      company: json['company'] as String,
      createdAt: json['createdAt'] as String,
      category: json['category'] as String,
    );
  }

  final int id;
  final String serialNumber;
  final String company;
  final String createdAt;
  final String category;
}

class GatewaysResponse {
  GatewaysResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory GatewaysResponse.fromJson(Map<String, dynamic> json) {
    return GatewaysResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Gateway.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int statusCode;
  final String message;
  final List<Gateway> data;
} 