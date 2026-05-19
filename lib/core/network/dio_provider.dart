// core/network/dio_provider.dart
import 'package:asa_server_eye/core/utils/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
      headers: {
        Headers.acceptHeader: 'application/json',
      },
    ),
  );

  dio.interceptors.add(_AppLoggerInterceptor());
  return dio;
});

class _AppLoggerInterceptor extends Interceptor {
  static const _tag = 'Dio';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(_tag, 'REQUEST ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    AppLogger.debug(
      _tag,
      'RESPONSE ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      _tag,
      'ERROR ${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err,
    );
    handler.next(err);
  }
}
