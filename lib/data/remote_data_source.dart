import 'package:dart_either/dart_either.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_store/widgets/task_item.dart';

import '../core/constants/app_urls.dart';
import '../network/http_client.dart';
import '../network/interceptors/token_injector_interceptor.dart';
import 'model/task_model.dart';

class RemoteDataSource {
  final DioClient dioClient;

  const RemoteDataSource(this.dioClient);

  Future<Either<String, List<TaskModel>>> getAllTasks() async {
    final response = await dioClient.get('employees/task/get-all-tasks');
    debugPrint(response.statusCode.toString());
    debugPrint(response.data.toString());
    if (response.statusCode == 200) {
      return Right(List.from(response.data['data']).map((e) => TaskModel.fromJson(e)).toList());
    } else {
      return Left('');
    }
  }

  Future<Either<String, bool>> changeTaskStatus({required String id, required TaskType status}) async {
    final response = await dioClient.post(
      'employees/task/update-status/$id',
      queryParameters: {
        'new_status': status.name,
      },
    );
    debugPrint(response.statusCode.toString());
    debugPrint(response.data.toString());

    return const Right(true);
  }
}

class RemoteClient {
  static DioClient? _client;

  static get client => _getClient();

  static DioClient _getClient() {
    if (_client == null) {
      _client = DioClient(
        baseUrl: '${AppUrls.baseUrl}/api/',
        interceptors: [
          TokenInjectorInterceptor(),
        ],
      );
      return _client!;
    } else {
      return _client!;
    }
  }
}
