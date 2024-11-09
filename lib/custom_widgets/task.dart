// task.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cotask/edit_task_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/providers/global_var_provider.dart';

class Task {
  final int id;
  final String name;
  final String listName;
  final DateTime startDate;
  final DateTime endDate;
  final Set<String> selectedDays;
  final int credit;
  final Map<int, Map<int, Map<int, bool>>> completionStatus;

  Task({
    required this.id,
    required this.name,
    required this.listName,
    required this.startDate,
    required this.endDate,
    required this.selectedDays,
    required this.credit,
    Map<int, Map<int, Map<int, bool>>>? completionStatus,
  }) : completionStatus = completionStatus ??
            _initializeCompletionStatus(startDate, endDate, selectedDays);

  // 更新任务完成状态的方法
  Task copyWith({
    int? id,
    String? name,
    String? listName,
    DateTime? startDate,
    DateTime? endDate,
    Set<String>? selectedDays,
    int? credit,
    Map<int, Map<int, Map<int, bool>>>? completionStatus,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      listName: listName ?? this.listName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedDays: selectedDays ?? this.selectedDays,
      credit: credit ?? this.credit,
      completionStatus: completionStatus ?? this.completionStatus,
    );
  }

  // Helper function to initialize completionStatus
  static Map<int, Map<int, Map<int, bool>>> _initializeCompletionStatus(
      DateTime startDate, DateTime endDate, Set<String> selectedDays) {
    final Map<int, Map<int, Map<int, bool>>> status = {};

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      String weekday =
          DateFormat('EEE').format(currentDate); // 获取星期的简写（例如 'Mon', 'Tue' 等）

      if (selectedDays.isEmpty || selectedDays.contains(weekday)) {
        int year = currentDate.year;
        int month = currentDate.month;
        int day = currentDate.day;

        status.putIfAbsent(year, () => {});
        status[year]!.putIfAbsent(month, () => {});
        status[year]![month]![day] = false; // 将状态设置为未完成
      }

      // 移动到下一天
      currentDate = currentDate.add(Duration(days: 1));
    }

    return status;
  }
}

void updateTaskCompletion(Task task, DateTime date, bool isCompleted,
    TaskProvider taskProvider, String listName) {
  final year = date.year;
  final month = date.month;
  final day = date.day;

  // 复制当前任务的完成状态
  final updatedTaskCompletion =
      Map<int, Map<int, Map<int, bool>>>.from(task.completionStatus);

  // 确保 year、month、day 的 Map 层次结构存在
  updatedTaskCompletion.putIfAbsent(year, () => {});
  updatedTaskCompletion[year]!.putIfAbsent(month, () => {});
  updatedTaskCompletion[year]![month]![day] = isCompleted;

  // 使用 copyWith 更新任务
  final updatedTask = task.copyWith(completionStatus: updatedTaskCompletion);

  // 更新到 TaskProvider
  taskProvider.updateTask(updatedTask);
}

class TaskContainer extends StatelessWidget {
  final Task task;
  final VoidCallback onTaskRemoved;

  TaskContainer({
    required this.task,
    required this.onTaskRemoved,
  });

  @override
  Widget build(BuildContext context) {
    // 获取选中的日期
    final selectedDate = Provider.of<DateProvider>(context).selectedDate;
    final year = selectedDate.year;
    final month = selectedDate.month;
    final day = selectedDate.day;

    // 判断任务是否在选定日期已完成
    bool isTaskCompleted = task.completionStatus[year]?[month]?[day] ?? false;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: SvgPicture.asset('assets/drag_handle.svg'),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              task.name,
              style: TextStyle(color: Colors.black87, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 30,
            child: task.listName != 'Unassigned Task' && !isTaskCompleted
                ? GestureDetector(
                    onTap: () {
                      // 点击标记任务为完成
                      updateTaskCompletion(
                        task,
                        selectedDate,
                        true,
                        Provider.of<TaskProvider>(context, listen: false),
                        task.listName, // 直接从 task 中获取 listName
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/check_circle.svg',
                      color: Color.fromARGB(255, 115, 202, 115),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskPage(
                    task: task,
                    listName: task.listName, // 直接从 task 中获取 listName
                  ),
                ),
              );
            },
            child: SvgPicture.asset('assets/three_dot.svg'),
          ),
        ],
      ),
    );
  }
}
