import 'dart:developer';
import 'package:dio/dio.dart';


class AppInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
  

    log(options.uri.toString());
    log('REQUEST[${options.method}] => '
        'PATH:${options.baseUrl}${options.path}');
    printWrapped('PARAMETERS:${options.queryParameters}');
    log('HEADER[${options.headers.toString()}] =>');
    printWrapped('DATA:${options.data ?? ''}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    log('RESPONSE[${response.statusCode}]');
    log('RESPONSE[${response.statusCode}] => PATH: ${response.data ?? ''}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('ERROR[${err.toString()}] => PATH: ${err.error}');
    return super.onError(err, handler);
  }

  void printWrapped(String text) {
    var pattern = RegExp('.{1,1000}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => log(match.group(0) ?? ''));
  }
}
