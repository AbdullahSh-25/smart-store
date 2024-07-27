import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/task_model.dart';
import '../../data/remote_data_source.dart';
import '../../widgets/task_item.dart';

part 'task_event.dart';

part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final RemoteDataSource remoteDataSource;
  bool firstLoad = false;
  int taskCount = 0;

  TaskBloc(this.remoteDataSource) : super(const TaskState()) {
    on<TaskEvent>(_onGetTasks);
    on<ChangeTaskStatus>(_onChangeTaskStatus);
  }

  Future<void> _onChangeTaskStatus(ChangeTaskStatus event, Emitter<TaskState> emit) async {
    final response = await remoteDataSource.changeTaskStatus(id: event.taskId.toString(), status: event.taskType);
    response.fold(
      ifLeft: (left) {
        event.onFail();
      },
      ifRight: (right) {
        event.onSuccess();
        emit(state.copyWith(getTaskStatus: TaskStatus.success));
      },
    );
  }

  Future<void> _onGetTasks(TaskEvent event, Emitter<TaskState> emit) async {
    if (!firstLoad) {
      emit(state.copyWith(getTaskStatus: TaskStatus.loading));
      firstLoad = true;
    }
    final response = await remoteDataSource.getAllTasks();

    response.fold(
      ifLeft: (left) {},
      ifRight: (right) async {
        final todo = right.where((element) => element.status == TaskType.todo).toList();
        final inProgress = right.where((element) => element.status == TaskType.inProgress).toList();
        final done = right.where((element) => element.status == TaskType.done).toList();
        if (taskCount < right.length) {
          await AudioPlayer().play(AssetSource('audios/new_task.mp3'));
        }
        taskCount = right.length;
        emit(state.copyWith(getTaskStatus: TaskStatus.success, todo: todo, inProgress: inProgress, done: done));
      },
    );
  }
}
