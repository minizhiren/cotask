// task.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cotask/edit_task_page.dart';

class Task {
  final int id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final bool isRecurring;
  final Set<String> selectedDays;
  final bool isCompleted;
  final bool isDeletable;
  final int credit;

  Task({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.isRecurring = false,
    this.selectedDays = const {},
    this.isCompleted = false,
    this.isDeletable = true,
    this.credit = 60,
  });

  // edit task attribute
  Task copyWith({
    int? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    bool? isRecurring,
    Set<String>? selectedDays,
    bool? isCompleted,
    bool? isDeletable,
    int? credit,
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
      credit: credit ?? this.credit,
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
                    onTap: onTaskRemoved,
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
                    listName: listName,
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
