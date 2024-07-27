part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, failure }

@immutable
class TaskState {
  final TaskStatus getTaskStatus;
  final List<TaskModel> todo;
  final List<TaskModel> inProgress;
  final List<TaskModel> done;

  const TaskState({
    this.getTaskStatus = TaskStatus.initial,
    this.todo = const [],
    this.inProgress = const [],
    this.done = const [],
  });

  TaskState copyWith({
    TaskStatus? getTaskStatus,
    List<TaskModel>? todo,
    List<TaskModel>? inProgress,
    List<TaskModel>? done,
  }) {
    return TaskState(
      getTaskStatus: getTaskStatus ?? this.getTaskStatus,
      todo: todo ?? this.todo,
      inProgress: inProgress ?? this.inProgress,
      done: done ?? this.done,
    );
  }
}
