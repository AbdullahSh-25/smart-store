import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_store/core/utils/functions.dart';
import 'package:smart_store/data/remote_data_source.dart';
import 'package:smart_store/generated/assets.dart';
import 'package:smart_store/state/task_bloc/task_bloc.dart';

import '../data/model/task_model.dart';
import '../widgets/task_item.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TaskBloc bloc;

  @override
  void initState() {
    bloc = TaskBloc(RemoteDataSource(RemoteClient.client));
    Timer.periodic(const Duration(seconds: 3), (timer) {
      bloc.add(GetTasks());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'مهامي',
            ),
            centerTitle: false,
            elevation: 2,
          ),
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      switch (state.getTaskStatus) {
                        case TaskStatus.initial:
                        case TaskStatus.loading:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case TaskStatus.failure:
                          return const Center(
                            child: Text('حدث خطأ ما'),
                          );
                        case TaskStatus.success:
                          print(state.todo.length);
                          return Column(
                            children: [
                              const Align(
                                alignment: Alignment.center,
                                child: TabBar(
                                  padding: EdgeInsets.all(4),
                                  tabs: [
                                    Tab(text: 'قيد الانتظار'),
                                    Tab(text: 'قيد التنفيذ'),
                                    Tab(text: 'منتهية'),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    TaskList(
                                      tasks: state.todo,
                                      taskType: TaskType.todo,
                                      onTaskTap: (task,i) {
                                        context.read<TaskBloc>().add(
                                              ChangeTaskStatus(
                                                taskId: task.id,
                                                index: i,
                                                taskType: TaskType.inProgress,
                                                onSuccess: () {},
                                                onFail: () {},
                                              ),
                                            );
                                      },
                                    ),
                                    TaskList(
                                      tasks: state.inProgress,
                                      taskType: TaskType.inProgress,
                                      onTaskTap: (task,i) {
                                        context.read<TaskBloc>().add(
                                              ChangeTaskStatus(
                                                taskId: task.id,
                                                index: i,
                                                taskType: TaskType.done,
                                                onSuccess: () {},
                                                onFail: () {},
                                              ),
                                            );
                                      },
                                    ),
                                    TaskList(
                                      tasks: state.done,
                                      taskType: TaskType.done,
                                      onTaskTap: (task,i) {
                                        context.read<TaskBloc>().add(
                                              ChangeTaskStatus(
                                                taskId: task.id,
                                                index: i,
                                                taskType: TaskType.inProgress,
                                                onSuccess: () {},
                                                onFail: () {},
                                              ),
                                            );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final void Function(TaskModel,int) onTaskTap;
  final TaskType taskType;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onTaskTap,
    required this.taskType,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isNotEmpty) {
      return ListView.separated(
        itemCount: tasks.length,
        padding: const EdgeInsets.only(top: 16),
        itemBuilder: (context, i) {
          final task = tasks[i];
          return TaskItem(
            onTap: () {
              onTaskTap(task,i);
            },
            name: task.title,
            description: task.body,
            taskType: taskType,
          );
        },
        separatorBuilder: (context, i) {
          return const SizedBox(height: 8);
        },
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(Assets.svgNoItems),
          const SizedBox(height: 16),
          Text(
            onTaskType(
              taskType: taskType,
              todo: 'لا يوجد مهام مسندة إليك',
              inProgress: 'لا يوجد مهام قيد التنفيذ',
              done: 'لم تقم بإكمال مهمة بعد',
            ),
            style: const TextStyle(fontSize: 24),
          ),
        ],
      );
    }
  }
}
