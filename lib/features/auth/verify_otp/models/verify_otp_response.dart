class VerifyOtpResponse {
  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      // data:
      //     (json['data'] as List?)
      //         ?.map(
      //           (item) => VerifyOtpData.fromJson(item as Map<String, dynamic>),
      //         )
      //         .toList() ??
      //     [],
      data: VerifyOtpData.fromJson(json['data']),
    );
  }

  VerifyOtpResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });
  final int statusCode;
  final String message;
  // final List<VerifyOtpData> data;
  final VerifyOtpData data;
}

class VerifyOtpData {
  VerifyOtpData({
    required this.message,
    // required this.response,
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) {
    return VerifyOtpData(
      message: json['message'] as String,
      // response: VerifyOtpResponseData.fromJson(
      //   json['response'] as Map<String, dynamic>,
      // ),
    );
  }
  final String message;
  // final VerifyOtpResponseData response;
}

// class VerifyOtpResponseData {
//   VerifyOtpResponseData({required this.metadata, required this.session});

//   factory VerifyOtpResponseData.fromJson(Map<String, dynamic> json) {
//     return VerifyOtpResponseData(
//       metadata: Metadata.fromJson(json['\$metadata'] as Map<String, dynamic>),
//       session: json['Session'] as String,
//     );
//   }
//   final Metadata metadata;
//   final String session;
// }

// class Metadata {
//   Metadata({
//     required this.httpStatusCode,
//     required this.requestId,
//     required this.attempts,
//     required this.totalRetryDelay,
//   });

//   factory Metadata.fromJson(Map<String, dynamic> json) {
//     return Metadata(
//       httpStatusCode: json['httpStatusCode'] as int,
//       requestId: json['requestId'] as String,
//       attempts: json['attempts'] as int,
//       totalRetryDelay: json['totalRetryDelay'] as int,
//     );
//   }
//   final int httpStatusCode;
//   final String requestId;
//   final int attempts;
//   final int totalRetryDelay;
// }
