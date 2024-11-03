import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Task {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRecurring;
  final Set<String> selectedDays;
  final bool isCompleted;
  final bool isDeletable;

  Task({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.isRecurring = false,
    this.selectedDays = const {},
    this.isCompleted = false,
    this.isDeletable = true, // 默认值设置为 true
  });

  // 复制并更新方法，用于任务属性的修改
  Task copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    bool? isRecurring,
    Set<String>? selectedDays,
    bool? isCompleted,
    bool? isDeletable,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isRecurring: isRecurring ?? this.isRecurring,
      selectedDays: selectedDays ?? this.selectedDays,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeletable: isDeletable ?? this.isDeletable,
    );
  }
}

class TaskContainer extends StatelessWidget {
  final Task task;
  final String listName;
  final VoidCallback onTaskRemoved;

  TaskContainer({
    required this.task,
    required this.listName,
    required this.onTaskRemoved,
  });

  @override
  Widget build(BuildContext context) {
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
            child: task.isDeletable &&
                    listName != 'Unassigned Task' &&
                    !task.isCompleted
                ? GestureDetector(
                    onTap: onTaskRemoved, // 点击图标时触发删除回调
                    child: SvgPicture.asset(
                      'assets/check_circle.svg',
                      color: Color.fromARGB(255, 115, 202, 115),
                    ),
                  )
                : SizedBox.shrink(), // 如果不能删除则隐藏删除按钮
          ),
          SizedBox(width: 10),
          SvgPicture.asset('assets/three_dot.svg'),
        ],
      ),
    );
  }
}
