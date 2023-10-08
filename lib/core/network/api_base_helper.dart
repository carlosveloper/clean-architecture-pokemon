import 'package:dio/dio.dart';
import 'error/app_exceptions.dart';

Response<dynamic> returnResponse(
  Response<dynamic> response, {
  List<String> listKeyMessage = const ['message', 'error', "errors"],
}) {
  var responseJson = response.data ?? '';
  var message = '';

  message = responseJson.toString();
  if (responseJson is Map) {
    for (var key in listKeyMessage) {
      var valor = responseJson[key];
      if (valor is String) {
        message = valor;
        break;
      }
      if (responseJson[key] != null) {
        if (responseJson[key] is Map<String, dynamic>) {
          if (responseJson[key]['userMessage'] != null &&
              responseJson[key]['userMessage'].toString().isNotEmpty) {
            message = responseJson[key]['userMessage'];
            break;
          }

          if (responseJson[key]['message'] != null &&
              responseJson[key]['message'].toString().isNotEmpty) {
            message = responseJson[key]['message'];
            break;
          }
        } else if (responseJson[key] is List<dynamic>) {
          var list = responseJson[key] as List<dynamic>;
          if (list.isNotEmpty) {
            message = responseJson[key][0]['msg'] ?? '';
            if (message.isEmpty) {
              message = responseJson[key].toString();
            }
            break;
          }
        }

        message = responseJson[key].toString();
      }
    }
  }
  switch (response.statusCode) {
    case 200:
    case 201:
      return response;
    case 400:
      throw BadRequestException(message: message);
    case 401:
    case 403:
      throw UnauthorizedException(message: message);
    case 404:
      throw NotFoundException(message: message);
    case 409:
    case 422:
      throw InvalidInputException(message: message);
    case 500:
    case 501:
    case 502:
    case 503:
    case 504:
      throw InternalServerException(message: message);
    default:
      throw FetchDataException(
          message:
              "S.current.exceptionFetchData(response.statusCode.toString())");
  }
}

String dioExceptions(DioException dioError) {
  var message = '';

  switch (dioError.type) {
    case DioExceptionType.cancel:
      message = "S.current.dioCancel";
      break;
    case DioExceptionType.badCertificate:
      message == "S.current.badCertificate";
      break;
    case DioExceptionType.connectionTimeout:
      message = "S.current.connectionTimeout";
      break;
    case DioExceptionType.receiveTimeout:
      message = "S.current.receiveTimeout";
      break;
    case DioExceptionType.badResponse:
      try {
        returnResponse(dioError.response!);
      } catch (e) {
        message = e.toString();
      }
      break;

    case DioExceptionType.sendTimeout:
      message = "S.current.sendTimeout";
      break;

    default:
      message = "S.current.somethingWrong";
      break;
  }
  return message;
}
