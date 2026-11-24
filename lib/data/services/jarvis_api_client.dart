import 'package:dio/dio.dart';

class BackendConfig {
  String baseUrl;
  bool useMock;
  Duration connectTimeout;
  Duration receiveTimeout;

  BackendConfig({
    this.baseUrl = 'http://localhost:8080',
    this.useMock = true, // Defaults to mock until Phase 5 backend is ready
    this.connectTimeout = const Duration(seconds: 8),
    this.receiveTimeout = const Duration(seconds: 15),
  });
}

class JarvisApiClient {
  final BackendConfig config;
  late final Dio _dio;

  JarvisApiClient({BackendConfig? config})
    : config = config ?? BackendConfig() {
    _dio = Dio(
      BaseOptions(
        baseUrl: this.config.baseUrl,
        connectTimeout: this.config.connectTimeout,
        receiveTimeout: this.config.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Client': 'JARVIS-Flutter-v1',
        },
      ),
    );
  }

  void updateBaseUrl(String newUrl) {
    config.baseUrl = newUrl;
    _dio.options.baseUrl = newUrl;
  }

  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/api/health');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Dio get dio => _dio;
}
