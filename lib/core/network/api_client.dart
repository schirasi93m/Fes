import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:5058/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    debugPrint('[ApiClient] ایجاد شد با baseUrl: http://localhost:5058/api');
    
    // Add logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('[API] ${options.method.toUpperCase()} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('[API] Response: ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('[API] Error: ${error.requestOptions.path} - ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<ApiConnectionState> checkConnection() async {
    try {
      await _dio.get('/');
      return ApiConnectionState.connected;
    } on DioException catch (error) {
      if (error.response != null) {
        return error.response!.statusCode != null &&
                error.response!.statusCode! >= 500
            ? ApiConnectionState.serverError
            : ApiConnectionState.connected;
      }

      return ApiConnectionState.disconnected;
    } catch (_) {
      return ApiConnectionState.disconnected;
    }
  }
}

enum ApiConnectionState { checking, connected, serverError, disconnected }
