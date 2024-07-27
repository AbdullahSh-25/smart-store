import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';


enum _StatusType { succeed, failed }

class DioLogInterceptor extends Interceptor {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  final Logger logger = Logger();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // options.headers['Authorization'] = 'Bearer ${Hive.box('userBox').get('user_info')}';

    if (kDebugMode) {
      logger.i(
        "***|| INFO Request ${options.method} ${options.path} ||***"
            "\n param : ${options.queryParameters}"
            "\n data : ${options.data}"
            "\n Header: ${encoder.convert(options.headers)}"
            "\n token: ${encoder.convert(options.headers[HttpHeaders.authorizationHeader])}"
            "\n timeout: ${options.connectTimeout ?? 0 ~/ 1000}s"
      );
    }
    // options.headers[HttpHeaders.authorizationHeader] = Hive.box('userBox').get('token_key');
    // print(Hive.box('userBox').get('token_key'));
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _StatusType statusType;
      if (response.statusCode == 200) {
        statusType = _StatusType.succeed;
      } else {
        statusType = _StatusType.failed;
      }

      if (statusType == _StatusType.failed) {
        logger.e(
            '***|| ${statusType.name.toUpperCase()} Response into -> ${response.requestOptions.uri.path} ||***');
      } else {
        logger.t(
            '***|| ${statusType.name.toUpperCase()} Response into -> ${response.requestOptions.uri.path} ||***');
      }

      logger.f(
        "***|| INFO Response Request ${response.requestOptions.uri.path} ${statusType == _StatusType.succeed ? '✊' : ''} ||***"
            "\n Status code: ${response.statusCode}"
            "\n Status message: ${response.statusMessage}"
            "\n Data: ${encoder.convert(response.data)}",
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      logger.e(
        "***|| SOMETHING WENT WRONG 💔 ||***"
            "\n error: ${err.error}"
            "\n status code: ${err.response?.statusCode}"
            "\n response: ${err.response}"
            "\n message: ${err.message}"
            "\n type: ${err.type}"
            "\n stackTrace: ${err.stackTrace}",
      );
    }
    handler.next(err);
  }
}
