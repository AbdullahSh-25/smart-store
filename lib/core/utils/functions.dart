import '../../widgets/task_item.dart';

T onTaskType<T>({required TaskType taskType, required T todo, required T inProgress, required T done}) {
  switch (taskType) {
    case TaskType.todo:
      return todo;
    case TaskType.inProgress:
      return inProgress;
    case TaskType.done:
      return done;
  }
}
