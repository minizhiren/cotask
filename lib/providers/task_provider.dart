import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cotask/custom_widgets/task.dart';
import 'package:cotask/providers/user_provider.dart'; // Import UserProvider

class TaskProvider with ChangeNotifier {
  List<Task> tasks = [
    Task(
      id: 1,
      name: 'Task 1',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 45)),
      ownerName: 'Unassigned Task',
      selectedDays: {Weekday.Mon, Weekday.Wed, Weekday.Fri},
      credit: 60,
    ),
    Task(
      id: 4,
      name: 'Task 4',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 15)),
      ownerName: 'Me',
      selectedDays: {Weekday.Mon, Weekday.Tue, Weekday.Fri},
      credit: 60,
    ),
    Task(
      id: 5,
      name: 'Task 5',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 15)),
      ownerName: 'Me',
      selectedDays: {Weekday.Sat, Weekday.Wed, Weekday.Fri},
      credit: 60,
    ),
    Task(
      id: 6,
      name: 'Task 6',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 15)),
      ownerName: 'Lucas',
      selectedDays: {Weekday.Mon, Weekday.Wed, Weekday.Fri},
      credit: 60,
    ),
  ];

  // Add a task and specify its list
  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
    _printTaskDetails(task, "added");
  }

  // Remove or complete a task
  void removeTask(Task task, bool isComplete, BuildContext context) {
    if (isComplete) {
      // Find the user in UserProvider and add the task's credit
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.findUserByName(task.ownerName);
      if (user != null) {
        print('------------------------------------ will call user');
        userProvider.addCreditToUser(user, task.credit);
      }
      _printTaskDetails(task, "completed");
    } else {
      _printTaskDetails(task, "removed");
    }
    tasks.remove(task);
    print('remove action!!');
    notifyListeners();
  }

  // Update a task
  void updateTask(Task updatedTask) {
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      print('update triggered----------------------------------------');
      notifyListeners();
    }
    _printTaskDetails(updatedTask, "updated");
  }

  // Print task details for debugging
  void _printTaskDetails(Task task, String action) {
    print("Task $action:");
    print("ID: ${task.id}");
    print("Name: ${task.name}");
    print("List Name: ${task.ownerName}");
    print("Start Date: ${task.startDate}");
    print("End Date: ${task.endDate}");
    print("Selected Days: ${task.selectedDays}");
    print("Credit: ${task.credit}");
    print("Completion Status: ${task.completionStatus}");
  }
}
