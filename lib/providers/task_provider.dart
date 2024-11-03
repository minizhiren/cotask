import 'package:flutter/material.dart';

class TaskItem {
  final String name;
  final int id;

  TaskItem(this.name, this.id);
}

class TaskProvider with ChangeNotifier {
  // 每个列的任务列表，列名作为键
  Map<String, List<TaskItem>> taskColumns = {
    'Unassigned Task': [
      TaskItem('Task 1', 1),
    ],
    'Me': [
      TaskItem('Task 4', 4),
      TaskItem('Task 5', 5),
    ],
    'Lucas': [
      TaskItem('Task 6', 6),
    ],
  };

  // 添加任务到指定的列
  void addTask(TaskItem task, String column) {
    taskColumns[column]?.add(task);
    notifyListeners();
  }

  // 从指定的列中移除任务
  void removeTask(TaskItem task, String column) {
    taskColumns[column]?.remove(task);
    notifyListeners();
  }
}
