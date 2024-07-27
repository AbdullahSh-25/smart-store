import 'package:flutter/material.dart';

enum TaskType {
  todo('todo'),
  inProgress('in_progress'),
  done('done');

  const TaskType(this.name);

  final String name;
}

class TaskItem extends StatefulWidget {
  final String name;
  final String description;
  final TaskType taskType;
  final VoidCallback onTap;

  const TaskItem({
    super.key,
    required this.name,
    required this.description,
    required this.taskType,
    required this.onTap,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x33000000),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: onTaskType(
                todo: Colors.amber,
                inProgress: Colors.blueAccent,
                done: Colors.green,
              ),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          onTaskType(
                            todo: const Icon(
                              Icons.access_time_outlined,
                              color: Colors.amber,
                              size: 30,
                            ),
                            inProgress: const Icon(
                              Icons.timelapse_rounded,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                            done: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                            child: Text(
                              widget.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                        child: Text(
                          widget.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.taskType != TaskType.done)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.onTap,
                            style: ElevatedButton.styleFrom(
                              surfaceTintColor: onTaskType(
                                todo: Colors.amber,
                                inProgress: Colors.blueAccent,
                                done: Colors.green,
                              ),
                            ),
                            child: Text(
                              onTaskType(todo: 'قبول', inProgress: 'إنهاء', done: ''),
                              style: TextStyle(
                                color: onTaskType(
                                  todo: Colors.orange,
                                  inProgress: Colors.blueAccent,
                                  done: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  T onTaskType<T>({required T todo, required T inProgress, required T done}) {
    switch (widget.taskType) {
      case TaskType.todo:
        return todo;
      case TaskType.inProgress:
        return inProgress;
      case TaskType.done:
        return done;
    }
  }
}
