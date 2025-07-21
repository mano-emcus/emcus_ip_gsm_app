class SignInResponse {

  SignInResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: SignInData.fromJson(json['data']),
    );
  }
  final int statusCode;
  final String message;
  final SignInData data;
}

class SignInData {

  SignInData({
    required this.accessToken,
    required this.expiresIn,
    required this.idToken,
    // required this.refreshToken,
    required this.tokenType,
  });

  factory SignInData.fromJson(Map<String, dynamic> json) {
    return SignInData(
      accessToken: json['AccessToken'] as String,
      expiresIn: json['ExpiresIn'] as int,
      idToken: json['IdToken'] as String,
      // refreshToken: json['RefreshToken'] as String,
      tokenType: json['TokenType'] as String,
    );
  }
  final String accessToken;
  final int expiresIn;
  final String idToken;
  // final String refreshToken;
  final String tokenType;
} 