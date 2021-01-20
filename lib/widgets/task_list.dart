import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro_app/models/task_provider.dart';
import 'package:pomodoro_app/models/task.dart';
import 'package:pomodoro_app/widgets/task_item.dart';

class TaskList extends StatelessWidget {
  final bool showToDo;
  final String projectId;
  TaskList(this.showToDo, [this.projectId = 'empty']);

  @override
  Widget build(BuildContext context) {
    List<Task> tasks;
    //provider implementation
    final tasksData = Provider.of<TaskProvider>(context);
    if (projectId == 'empty') {
      tasks = showToDo ? tasksData.toDoTasks : tasksData.doneTasks;
    } else {
      // tasks = tasksData
      //     .findbyProjectId(projectId)
      //     .where((ts) => ts.isDone != showToDo)
      //     .toList();
    }
    //actual widget ui build
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: tasks[index],
        child: TaskItem(),
      ),
    );
  }
}
