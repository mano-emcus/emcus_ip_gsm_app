class SitesResponse {
  SitesResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SitesResponse.fromJson(Map<String, dynamic> json) {
    return SitesResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List?)
          ?.map((item) => SiteData.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
  
  final int statusCode;
  final String message;
  final List<SiteData> data;
}

class SiteData {
  SiteData({
    required this.id,
    required this.siteName,
    required this.siteLocation,
    required this.company,
    required this.users,
    required this.createdAt,
  });

  factory SiteData.fromJson(Map<String, dynamic> json) {
    return SiteData(
      id: json['id'] as int,
      siteName: json['siteName'] as String,
      siteLocation: json['siteLocation'] as String,
      company: json['company'] as String,
      users: (json['users'] as List?)?.cast<String>() ?? [],
      createdAt: json['createdAt'] as String,
    );
  }
  
  final int id;
  final String siteName;
  final String siteLocation;
  final String company;
  final List<String> users;
  final String createdAt;
} 