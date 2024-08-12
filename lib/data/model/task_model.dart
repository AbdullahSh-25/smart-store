// 'id' => $this->id,
// 'title' => $this->title,
// 'body' => $this->body,
// 'user' => new UserResource($this->user),
// 'corridor' => new CorridorResource($this->corridor),
// 'priority' => $this->priority,
// 'status' => $this->status,
// 'created_at' => $this->created_at,

// 'id' => $this->id,
// 'label' => $this->label,
// 'created_at' => $this->created_at,

// ['todo', 'in_progress', 'done']

import 'package:smart_store/widgets/task_item.dart';

class TaskModel {
  final int id;
  final String title;
  final String body;
  final Corridor? corridor;
  final int priority;
  final TaskType status;

  const TaskModel({
    required this.id,
    required this.title,
    required this.body,
    required this.corridor,
    required this.priority,
    required this.status,
  });

  TaskModel copyWith({
    int? id,
    String? title,
    String? body,
    Corridor? corridor,
    int? priority,
    TaskType? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      corridor: corridor ?? this.corridor,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      corridor: json['corridor'] != null ? Corridor.fromJson(json['corridor']) : null,
      priority: json['priority'],
      status: json['status'] == 'todo' ? TaskType.todo : (json['status'] == 'in_progress' ? TaskType.inProgress : TaskType.done),
    );
  }
}

class Corridor {
  final int id;
  final String label;

  const Corridor({
    required this.id,
    required this.label,
  });

  factory Corridor.fromJson(Map<String, dynamic> json) {
    return Corridor(
      id: json['id'],
      label: json['label'],
    );
  }
}
