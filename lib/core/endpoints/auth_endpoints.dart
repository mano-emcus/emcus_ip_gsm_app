import 'package:emcus_ipgsm_app/core/config/api_config.dart';

class AuthEndpoints {
  static String get register => '${ApiConfig.baseUrl}/auth/user/register';
  static String get verifyCode => '${ApiConfig.baseUrl}/auth/verify-code';
  static String get updatePassword => '${ApiConfig.baseUrl}/auth/user/updatePassword';
  static String get signIn => '${ApiConfig.baseUrl}/auth/signin';
  static String get logs => '${ApiConfig.baseUrl}/logs';
  static String get notes => '${ApiConfig.baseUrl}/notes';
  static String get sites => '${ApiConfig.baseUrl}/sites';
  // Add other auth endpoints here as needed
  // static String get login => '${ApiConfig.baseUrl}/auth/login';
  // static String get verifyOtp => '${ApiConfig.baseUrl}/auth/verify-otp';
  // etc.
} 