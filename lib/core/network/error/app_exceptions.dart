import 'dart:developer';
import 'package:dio/dio.dart';
import '../api_base_helper.dart';
import 'const_code_error.dart';

class AppCoreException implements Exception {
  int code;
  String message;
  String method;
  String prefix;
  dynamic type; //tipo  de clase del error(usado en Dio)

  AppCoreException(
      {required this.code,
      required this.message,
      required this.method,
      required this.prefix,
      this.type});

  @override
  String toString() {
    return '$code:$prefix $message----->$method';
  }

  String messageError() {
    log(_messageException());
    log(toString());

    if (type != null && type is DioException) {
      return dioExceptions(type);
    }

    if (code == CodeCoreConstants.internalServerException ||
        code == CodeCoreConstants.undefined ||
        code == CodeCoreConstants.fetchDataException) {
     
      return "S.current.appError";
    }

    return message;
  }

  String _messageException() {
    if (type != null && type is DioException) {
      return '$prefix:${dioExceptions(type)}';
    }
    return '$prefix $message';
  }
}

class GenericException extends AppCoreException {
  GenericException(String message,
      {dynamic type = GenericException,
      int code = CodeCoreConstants.genericException,
      String prefix = 'GenericException :',
      required String method})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: type,
            method: method);
}

class ObjectException extends AppCoreException {
  ObjectException(
      {required Object error,
      required String method,
      String prefix = 'ObjectException :'})
      : super(
            code: CodeCoreConstants.undefined,
            prefix: prefix,
            message: error.toString(),
            type: error,
            method: method);
}

class NetworkConnectionException extends AppCoreException {
  NetworkConnectionException(
      {String message = '',
      int code = CodeCoreConstants.networkConnectionException,
      String prefix = 'Internet :',
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: "S.current.exceptionNetwork",
            type: NetworkConnectionException,
            method: method);
}

class FetchDataException extends AppCoreException {
  FetchDataException(
      {required String message,
      int code = CodeCoreConstants.fetchDataException,
      String prefix = 'Error During Communication:',
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: FetchDataException,
            method: method);
}

class BadRequestException extends AppCoreException {
  BadRequestException(
      {required String message,
      int code = CodeCoreConstants.badRequestException,
      String prefix = 'Invalid Request:',
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: BadRequestException,
            method: method);
}

class UnauthorizedException extends AppCoreException {
  UnauthorizedException(
      {required String message,
      int code = CodeCoreConstants.unauthorizedException,
      String prefix = 'Unauthorized:',
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: UnauthorizedException,
            method: method);
}

class NotFoundException extends AppCoreException {
  NotFoundException(
      {required String message,
      int code = CodeCoreConstants.notFoundException,
      String prefix = 'Not found:',
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: NotFoundException,
            method: method);
}

class InternalServerException extends AppCoreException {
  InternalServerException(
      {required String message,
      int code = CodeCoreConstants.internalServerException,
      String prefix = 'Internal Server Error: ',
      String method = ''})
      : super(
          code: code,
          prefix: prefix,
          message: message,
          type: InternalServerException,
          method: method,
        );
}

class InvalidInputException extends AppCoreException {
  InvalidInputException(
      {required String message,
      int code = CodeCoreConstants.invalidInputException,
      String prefix = 'Oh no:',
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: InvalidInputException,
            method: method);
}

class FirebaseCustomException extends AppCoreException {
  FirebaseCustomException(
      {required String message,
      int code = CodeCoreConstants.firebase,
      String prefix = '',
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: FirebaseCustomException,
            method: method);
}

class GeoPermissionException extends AppCoreException {
  GeoPermissionException(
      {required String message,
      int code = CodeCoreConstants.geoPermisssion,
      String prefix = 'GeoPermission',
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: GeoPermissionException,
            method: method);
}

class DioCustomException extends AppCoreException {
  DioCustomException(
      {required String message,
      int code = CodeCoreConstants.dioError,
      String prefix = 'Dio:',
      required DioException type,
      String method = ''})
      : super(
            code: code,
            prefix: prefix,
            message: message,
            type: type,
            method: method);
}
