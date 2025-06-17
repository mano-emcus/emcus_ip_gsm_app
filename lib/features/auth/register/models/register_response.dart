class RegisterResponse {

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => RegisterData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  RegisterResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });
  final int statusCode;
  final String message;
  final List<RegisterData> data;
}

class RegisterData {

  RegisterData({
    required this.message,
    required this.response,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      message: json['message'] as String,
      response: RegisterResponseData.fromJson(json['response'] as Map<String, dynamic>),
    );
  }
  final String message;
  final RegisterResponseData response;
}

class RegisterResponseData {

  RegisterResponseData({
    required this.metadata,
    required this.codeDeliveryDetails,
    required this.session,
    required this.userConfirmed,
    required this.userSub,
  });

  factory RegisterResponseData.fromJson(Map<String, dynamic> json) {
    return RegisterResponseData(
      metadata: Metadata.fromJson(json['\$metadata'] as Map<String, dynamic>),
      codeDeliveryDetails: CodeDeliveryDetails.fromJson(json['CodeDeliveryDetails'] as Map<String, dynamic>),
      session: json['Session'] as String,
      userConfirmed: json['UserConfirmed'] as bool,
      userSub: json['UserSub'] as String,
    );
  }
  final Metadata metadata;
  final CodeDeliveryDetails codeDeliveryDetails;
  final String session;
  final bool userConfirmed;
  final String userSub;
}

class Metadata {

  Metadata({
    required this.httpStatusCode,
    required this.requestId,
    required this.attempts,
    required this.totalRetryDelay,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      httpStatusCode: json['httpStatusCode'] as int,
      requestId: json['requestId'] as String,
      attempts: json['attempts'] as int,
      totalRetryDelay: json['totalRetryDelay'] as int,
    );
  }
  final int httpStatusCode;
  final String requestId;
  final int attempts;
  final int totalRetryDelay;
}

class CodeDeliveryDetails {

  CodeDeliveryDetails({
    required this.attributeName,
    required this.deliveryMedium,
    required this.destination,
  });

  factory CodeDeliveryDetails.fromJson(Map<String, dynamic> json) {
    return CodeDeliveryDetails(
      attributeName: json['AttributeName'] as String,
      deliveryMedium: json['DeliveryMedium'] as String,
      destination: json['Destination'] as String,
    );
  }
  final String attributeName;
  final String deliveryMedium;
  final String destination;
} 