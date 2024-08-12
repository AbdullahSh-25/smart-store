import 'package:audioplayers/audioplayers.dart';
import 'package:bot_toast/bot_toast.dart';
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
  bool deadlock = false;

  TaskBloc(this.remoteDataSource) : super(const TaskState()) {
    on<TaskEvent>(_onGetTasks);
    on<ChangeTaskStatus>(_onChangeTaskStatus);
  }

  Future<void> _onChangeTaskStatus(ChangeTaskStatus event, Emitter<TaskState> emit) async {
    BotToast.showLoading();
    deadlock = true;
    final response = await remoteDataSource.changeTaskStatus(id: event.taskId.toString(), status: event.taskType);
    response.fold(
      ifLeft: (left) {
        BotToast.closeAllLoading();
        deadlock = false;
        event.onFail();
      },
      ifRight: (right) {
        BotToast.closeAllLoading();
        deadlock = false;
        if (event.taskType == TaskType.inProgress) {
          taskCount--;
          // tempTask = state.todo.removeAt(event.index);
          // state.inProgress.add(tempTask.copyWith(status: TaskType.inProgress));
        }
        if (event.taskType == TaskType.done) {
          // tempTask = state.inProgress.removeAt(event.index);
          // state.done.add(tempTask.copyWith(status: TaskType.done));
        }
        event.onSuccess();
        emit(state.copyWith(
          getTaskStatus: TaskStatus.success,
          todo: state.todo,
          inProgress: state.inProgress,
          done: state.done,
        ));
      },
    );
  }

  Future<void> _onGetTasks(TaskEvent event, Emitter<TaskState> emit) async {
    if(deadlock) return;
    if (!firstLoad) {
      emit(state.copyWith(getTaskStatus: TaskStatus.loading));
      firstLoad = true;
    }
    final response = await remoteDataSource.getAllTasks();
    print('Task Count: $taskCount');
    response.fold(
      ifLeft: (left) {},
      ifRight: (right) async {
        final todo = right.where((element) => element.status == TaskType.todo).toList();
        final inProgress = right.where((element) => element.status == TaskType.inProgress).toList();
        final done = right.where((element) => element.status == TaskType.done).toList();
        emit(state.copyWith(getTaskStatus: TaskStatus.success, todo: todo, inProgress: inProgress, done: done));
        if (taskCount < right.length) {
          await AudioPlayer().play(AssetSource('audios/new_task.mp3'));
        }
        taskCount = right.length;
      },
    );
  }
}
