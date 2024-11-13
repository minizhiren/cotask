// task.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cotask/edit_task_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/providers/global_var_provider.dart';

enum Weekday { Mon, Tue, Wed, Thu, Fri, Sat, Sun }

class Task {
  final int id;
  final String name;
  final String ownerName;
  final DateTime startDate;
  final DateTime endDate;
  final Set<Weekday> selectedDays; // Change here to use Weekday enum
  final int credit;
  final Map<int, Map<int, Map<int, bool>>> completionStatus;

  Task({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.startDate,
    required this.endDate,
    required this.selectedDays,
    required this.credit,
    Map<int, Map<int, Map<int, bool>>>? completionStatus,
  }) : completionStatus = completionStatus ??
            _initializeCompletionStatus(startDate, endDate, selectedDays);

  // Updated copyWith method to use Weekday enum for selectedDays
  Task copyWith({
    int? id,
    String? name,
    String? ownerName,
    DateTime? startDate,
    DateTime? endDate,
    Set<Weekday>? selectedDays, // Change here
    int? credit,
    Map<int, Map<int, Map<int, bool>>>? completionStatus,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerName: ownerName ?? this.ownerName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedDays: selectedDays ?? this.selectedDays,
      credit: credit ?? this.credit,
      completionStatus: completionStatus ?? this.completionStatus,
    );
  }

  static Map<int, Map<int, Map<int, bool>>> _initializeCompletionStatus(
      DateTime startDate, DateTime endDate, Set<Weekday> selectedDays) {
    final Map<int, Map<int, Map<int, bool>>> status = {};

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      Weekday weekday =
          Weekday.values[currentDate.weekday - 1]; // Map weekday to enum

      if (selectedDays.isEmpty || selectedDays.contains(weekday)) {
        int year = currentDate.year;
        int month = currentDate.month;
        int day = currentDate.day;

        status.putIfAbsent(year, () => {});
        status[year]!.putIfAbsent(month, () => {});
        status[year]![month]![day] = false; // Set status as incomplete
      }

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

  const TaskContainer({
    super.key,
    required this.task,
    required this.onTaskRemoved,
  });

  @override
  Widget build(BuildContext context) {
    // Retrieve the selected date
    final selectedDate = Provider.of<DateProvider>(context).selectedDate;
    final year = selectedDate.year;
    final month = selectedDate.month;
    final day = selectedDate.day;

    // Check if the task is completed for the selected date
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
      child: Flex(
        direction: Axis.horizontal,
        children: [
          SizedBox(
            width: 30,
            child: SvgPicture.asset('assets/drag_handle.svg'),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                task.name,
                style: TextStyle(color: Colors.black87, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 30, // 调整高度以适应较大的格子
              padding: const EdgeInsets.symmetric(vertical: 4), // 添加上下内边距
              // decoration: BoxDecoration(
              //   border:
              //       Border.all(color: Colors.grey.shade300, width: 1), // 浅灰色边框
              //   borderRadius: BorderRadius.circular(10),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 添加等间距
                children: [
                  for (var day in [
                    Weekday.Mon,
                    Weekday.Tue,
                    Weekday.Wed,
                    Weekday.Thu,
                    Weekday.Fri,
                    Weekday.Sat,
                    Weekday.Sun
                  ])
                    Container(
                      width: 13, // 设置固定宽度
                      height: 13, // 设置固定高度
                      decoration: BoxDecoration(
                        color: task.selectedDays.contains(day)
                            ? const Color.fromARGB(255, 236, 127, 163)
                            : const Color.fromARGB(255, 228, 219, 219),
                        borderRadius: BorderRadius.circular(3), // 增加每个格子的圆角
                        boxShadow: task.selectedDays.contains(day)
                            ? [
                                BoxShadow(
                                    color: Colors.pink.shade100,
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ]
                            : [], // 添加高亮的阴影效果
                      ),
                      alignment: Alignment.center,
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 30,
            child: task.ownerName != 'Unassigned Task' && !isTaskCompleted
                ? GestureDetector(
                    onTap: () {
                      // Mark task as complete for selected date
                      updateTaskCompletion(
                        task,
                        selectedDate,
                        true,
                        Provider.of<TaskProvider>(context, listen: false),
                        task.ownerName,
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
                    listName: task.ownerName,
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
