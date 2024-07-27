import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_flutter_transformer2/dio_flutter_transformer2.dart';

import 'interceptors/log_interceptor.dart';
import 'network_exception.dart';

/// A callback that returns a Dio response, presumably from a Dio method
/// it has called which performs an HTTP request, such as `dio.get()`,
/// `dio.post()`, etc.
typedef HttpLibraryMethod<T> = Future<Response<T>> Function();

class DioClient with DioMixin implements Dio {
  ///this is locale for testing purpose
  DioClient({required this.baseUrl, List<Interceptor>? interceptors}) {
    httpClientAdapter = IOHttpClientAdapter();
    transformer = FlutterTransformer();
    options = BaseOptions();
    options
      ..baseUrl = baseUrl
      ..headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'lang': "en",
      };
    if (interceptors != null) {
      this.interceptors.addAll([...interceptors, DioLogInterceptor()]);
    } else {
      this.interceptors.addAll([DioLogInterceptor()]);
    }
  }

  final String baseUrl;

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _mapException(
      () => super.get(
        path,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        data: data,
      ),
    );
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _mapException(
      () => super.post(
        path,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _mapException(
      () => super.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _mapException(
      () => super.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  Future<Response<T>> _mapException<T>(HttpLibraryMethod<T> method) async {
    try {
      return await method();
    } on DioException catch (exception) {
      if (exception.response?.statusCode.toString().matchAsPrefix('5') != null) {
        throw NetworkException(
          reason: NetworkExceptionReason.serverError,
          exception: exception,
        );
      }
      switch (exception.type) {
        case DioExceptionType.cancel:
          throw NetworkException(
            reason: NetworkExceptionReason.canceled,
            exception: exception,
          );
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          throw NetworkException(
            reason: NetworkExceptionReason.timedOut,
            exception: exception,
          );
        case DioExceptionType.badResponse:
          final response = exception.response;
          if (response == null || response is! Response<T>) {
            throw NetworkException(exception: exception, reason: NetworkExceptionReason.responseError);
          }
        case DioExceptionType.unknown:
        default:
          if (exception.error is SocketException) {
            throw NetworkException(
              reason: NetworkExceptionReason.noInternet,
              exception: exception,
            );
          }
      }
      throw NetworkException(exception: exception, reason: NetworkExceptionReason.unknown);
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      throw NetworkException(exception: Exception(), reason: NetworkExceptionReason.unknown);
    }
  }

// Future<Response<T>> _mapException<T>(
//     HttpLibraryMethod<T> method, {
//       ResponseExceptionMapper? mapper,
//     }) async {
//   try {
//     ///add your function
//     return await method();
//   } on DioException catch (exception) {
//     if (exception.response?.statusCode.toString().matchAsPrefix('5') != null) {
//       throw AppNetworkException(
//         reason: AppNetworkExceptionReason.serverError,
//         exception: exception,
//         message: handleMessage(exception.response?.data),
//       );
//     }
//     switch (exception.type) {
//       case DioExceptionType.cancel:
//         throw AppNetworkException(
//           reason: AppNetworkExceptionReason.canceled,
//           exception: exception,
//           message: handleMessage(exception.response?.data),
//         );
//       case DioExceptionType.connectionTimeout:
//       case DioExceptionType.receiveTimeout:
//       case DioExceptionType.sendTimeout:
//         throw AppNetworkException(
//           reason: AppNetworkExceptionReason.timedOut,
//           exception: exception,
//           message: handleMessage(exception.response?.data),
//         );
//       case DioExceptionType.badResponse:
//       // For DioErrorType.response, we are guaranteed to have a
//       // response object present on the exception.
//         final response = exception.response;
//         if (response == null || response is! Response<T>) {
//           // This should never happen, judging by the current source code
//           // for Dio.
//           throw AppNetworkResponseException(
//             exception: exception,
//             message: handleMessage(exception.response?.data),
//           );
//         }
//
//         throw mapper?.call(response, exception) ??
//             AppNetworkResponseException(
//               exception: exception,
//               statusCode: response.statusCode,
//               data: response.data,
//               message: handleMessage(exception.response?.data),
//             );
//       case DioExceptionType.unknown:
//       default:
//         if (exception.error is SocketException) {
//           throw AppNetworkException(
//             reason: AppNetworkExceptionReason.noInternet,
//             message: handleMessage(exception.response?.data),
//             exception: exception,
//           );
//         }
//         throw AppException.unknown(exception: exception, message: handleMessage(exception.response?.data));
//     }
//   } catch (e, s) {
//     log(e.toString(), stackTrace: s);
//     throw AppException.unknown(exception: e is Exception ? e : Exception('Unknown exception occurred'), message: e.toString());
//   }
// }
//
// String handleMessage(dynamic exceptionResponse) => (exceptionResponse is Map && exceptionResponse['Message'] != null)
//     ? (exceptionResponse['Message'] ?? " Some thing happen")
//     : 'Something happen '; //todo click to submit error
}
