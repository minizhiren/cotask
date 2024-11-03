import 'package:flutter/material.dart';
import 'package:cotask/custom_widgets/task.dart';

class TaskProvider with ChangeNotifier {
  // 使用 Map 存储任务列表，键为列名，值为 Task 对象的列表
  Map<String, List<Task>> taskColumns = {
    'Unassigned Task': [
      Task(
        id: 1,
        name: 'Task 1',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 1)),
        isRecurring: false,
        selectedDays: {'Mon', 'Wed', 'Fri'},
        isDeletable: true,
      ),
    ],
    'Me': [
      Task(
        id: 4,
        name: 'Task 4',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 3)),
        isRecurring: true,
        selectedDays: {'Mon', 'Wed', 'Fri'},
        isDeletable: true,
      ),
      Task(
        id: 5,
        name: 'Task 5',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 5)),
        isRecurring: false,
        selectedDays: {'Mon', 'Wed', 'Fri'},
        isDeletable: true,
      ),
    ],
    'Lucas': [
      Task(
        id: 6,
        name: 'Task 6',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 7)),
        isRecurring: false,
        selectedDays: {'Mon', 'Wed', 'Fri'},
        isDeletable: true,
      ),
    ],
  };

  // 添加任务到指定列
  void addTask(Task task, String column) {
    taskColumns.putIfAbsent(column, () => []);
    taskColumns[column]?.add(task);
    notifyListeners();
  }

  // 从指定列移除任务
  void removeTask(Task task, String column) {
    if (task.isDeletable && (taskColumns[column]?.remove(task) ?? false)) {
      notifyListeners();
    }
  }

  // 更新任务信息
  void updateTask(Task updatedTask, String column) {
    final taskList = taskColumns[column];
    if (taskList != null) {
      final index = taskList.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        taskList[index] = updatedTask;
        notifyListeners();
      }
    }
  }
}
