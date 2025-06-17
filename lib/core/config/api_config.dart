class ApiConfig {
  // Base URLs for different environments
  static const String _devBaseUrl = 'https://ipgsm.emcus.co.in/api';
  static const String _stagingBaseUrl = 'https://ipgsm.emcus.co.in/api';
  static const String _prodBaseUrl = 'https://ipgsm.emcus.co.in/api';

  // Current environment - change this based on your environment
  static const Environment _currentEnvironment = Environment.dev;

  // Get the base URL based on current environment
  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return _devBaseUrl;
      case Environment.staging:
        return _stagingBaseUrl;
      case Environment.prod:
        return _prodBaseUrl;
    }
  }

  // API Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // API Timeout settings
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}

enum Environment {
  dev,
  staging,
  prod,
} 