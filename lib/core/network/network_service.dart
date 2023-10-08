import 'package:dio/dio.dart';
import 'app_interceptors.dart';
import 'error/app_exceptions.dart';

class NetworkService {
  late Dio dioNetwork;
  late String urlApi;
  NetworkService({required String url, Interceptor? element}) {
    if (url.isEmpty) {
      throw GenericException('url is empty', method: 'initDio');
    }

    element ??= AppInterceptors();

    urlApi = url;
    dioNetwork = Dio(BaseOptions(
      baseUrl: url,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      validateStatus: (_) => true,
    ));
    dioNetwork.interceptors.add(element);
  }

  Future<Response> postRequest(String path, bodyRequest) async {
    var response = await dioNetwork.post(
      path,
      data: bodyRequest,
    );
    return response;
  }

  Future<Response> postFormDataRequest(String path, bodyRequest,
      {Map<String, dynamic>? headers}) async {
    var dio = Dio(BaseOptions(
        baseUrl: urlApi,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (_) => true,
        headers: headers));
    dio.interceptors.add(AppInterceptors());

    var response = await dio.post(
      path,
      data: bodyRequest,
    );
    return response;
  }

  Future<Response> putRequest(
    String path,
    bodyRequest,
  ) async {
    var response = await dioNetwork.put(
      path,
      data: bodyRequest,
    );
    return response;
  }

  Future<Response> getRequest(
    String path, {
    Map<String, dynamic>? params,
  }) async {
    var response = await dioNetwork.get(path, queryParameters: params);
    return response;
  }

  Future<Response> patchRequest(String path,
      {bodyRequest = '', Map<String, dynamic>? params}) async {
    var response = await dioNetwork.patch(path,
        queryParameters: params, data: bodyRequest);
    return response;
  }

  Future<Response> deleteRequest(String path,
      {dynamic bodyRequest, Map<String, dynamic>? params}) async {
    var response = await dioNetwork.delete(path,
        queryParameters: params, data: bodyRequest);
    return response;
  }
}
