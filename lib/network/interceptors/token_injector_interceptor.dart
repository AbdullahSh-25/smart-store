import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:smart_store/core/constants/app_keys.dart';

class TokenInjectorInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // options.headers['Authorization'] = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.'
    //     'eyJpc3MiOiJodHRwczovL21vY2Nhc2luLWNoaWNrZW4tNTMyNTExLmhvc3RpbmdlcnNpdGUuY29tL2FwaS9hdXRoL3JlZ2lzdGVyIiwiaWF0IjoxNzIxMDc0OTY3LCJleHAiOjE3MjIyODQ1NjcsIm5iZiI6MTcyMTA3NDk2NywianRpIjoiYzZrZVI2WkNNdTZDSU8yaCIsInN1YiI6IjkiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.'
    //     'wqlsRxA9NwNKrwVvwcG8Qh2fNjM2aMo4CS4wVnl554Q';
    options.headers['Accept'] = 'application/json';
    options.headers['Authorization'] = Hive.box(AppKeys.box).get(AppKeys.token) != null ? 'Bearer ${Hive.box(AppKeys.box).get(AppKeys.token)}' : null;

    handler.next(options);
  }
}
