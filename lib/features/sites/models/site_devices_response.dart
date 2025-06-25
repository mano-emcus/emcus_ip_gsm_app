class SiteDevice {
  SiteDevice({
    required this.id,
    required this.deviceAddress,
    required this.zoneAddress,
    required this.company,
    required this.createdAt,
  });

  factory SiteDevice.fromJson(Map<String, dynamic> json) {
    return SiteDevice(
      id: json['id'] as int,
      deviceAddress: json['deviceAddress'] as int,
      zoneAddress: json['zoneAddress'] as int,
      company: json['company'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  final int id;
  final int deviceAddress;
  final int zoneAddress;
  final String company;
  final String createdAt;
}

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
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SiteDevice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final int statusCode;
  final String message;
  final List<SiteDevice> data;
} 