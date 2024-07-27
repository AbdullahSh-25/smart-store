part of 'task_bloc.dart';

@immutable
abstract class TaskEvent {}

class GetTasks extends TaskEvent {}

class ChangeTaskStatus extends TaskEvent {
  final int taskId;
  final TaskType taskType;
  final VoidCallback onSuccess;
  final VoidCallback onFail;

  ChangeTaskStatus({
    required this.taskId,
    required this.taskType,
    required this.onSuccess,
    required this.onFail,
  });
}
