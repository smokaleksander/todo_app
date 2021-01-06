import './project.dart';
import './task.dart';

final DUMMY_PROJECTS = [
  Project(id: 'c1', title: 'Italian'),
  Project(id: 'c2', title: 'Q uick & Easy'),
  Project(id: 'c3', title: 'Hamburgers'),
];

final DUMMY_TASKS = [
  Task(id: 't1', title: 'task1', projectId: 'c1'),
  Task(id: 't2', title: 'task2', projectId: 'c1'),
  Task(id: 't3', title: 'task3', projectId: 'c1'),
  Task(id: 't4', title: 'task4', projectId: 'c2'),
  Task(id: 't4', title: 'task5', projectId: 'c2'),
  Task(id: 't6', title: 'task6', projectId: 'c3'),
  Task(id: 't7', title: 'task7', projectId: 'c3'),
  Task(id: 't8', title: 'task8'),
  Task(id: 't9', title: 'task9'),
];
