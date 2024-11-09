import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/providers/global_var_provider.dart';
import 'package:cotask/custom_widgets/task.dart';

class SingleDailyTask extends StatelessWidget {
  // 定义所有列表名称，即使没有任务也会显示这些列表
  final List<String> predefinedListNames = ['Unassigned Task', 'Me', 'Lucas'];

  @override
  Widget build(BuildContext context) {
    // 获取当前选定的日期
    final selectedDate = Provider.of<DateProvider>(context).selectedDate;
    final year = selectedDate.year;
    final month = selectedDate.month;
    final day = selectedDate.day;
    final selectedWeekday = selectedDate.weekday; // 星期几（1=星期一，7=星期日）

    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        // 初始化分组任务 Map，确保每个预定义的列表都有一个空列表
        Map<String, List<Task>> groupedTasks = {
          for (var listName in predefinedListNames) listName: []
        };

        // 根据任务的 `listName` 进行分组
        for (var task in taskProvider.tasks) {
          bool isTaskCompleted =
              task.completionStatus[year]?[month]?[day] ?? false;

          // 检查选定日期是否在任务的时间范围内
          bool isWithinDateRange = selectedDate
                  .isAfter(task.startDate.subtract(Duration(days: 1))) &&
              selectedDate.isBefore(task.endDate.add(Duration(days: 1)));

          // 检查任务是否符合选定的星期几
          bool shouldShowTask = task.selectedDays.isEmpty ||
              task.selectedDays.contains({
                1: 'Mon',
                2: 'Tue',
                3: 'Wed',
                4: 'Thu',
                5: 'Fri',
                6: 'Sat',
                7: 'Sun',
              }[selectedWeekday]);

          // 仅显示在日期范围内、未完成且符合星期条件的任务
          if (isWithinDateRange && !isTaskCompleted && shouldShowTask) {
            groupedTasks[task.listName]?.add(task);
          }
        }

        // 构建 DragAndDropList
        List<DragAndDropList> lists = groupedTasks.entries.map((entry) {
          String listName = entry.key;
          List<Task> tasks = entry.value;

          return DragAndDropList(
            header: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                listName,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            children: tasks.isNotEmpty
                ? tasks.map((task) {
                    return DragAndDropItem(
                      child: TaskContainer(
                        task: task,
                        onTaskRemoved: () => taskProvider.removeTask(task),
                      ),
                    );
                  }).toList()
                : [
                    DragAndDropItem(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                            'No tasks available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  ], // 如果任务列表为空，显示提示信息
          );
        }).toList();

        return DragAndDropLists(
          children: lists,
          onItemReorder:
              (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
            var sourceListName = predefinedListNames[oldListIndex];
            var targetListName = predefinedListNames[newListIndex];
            var movedTask = groupedTasks[sourceListName]![oldItemIndex];

            // 更新任务的 listName 并在 TaskProvider 中更新任务
            movedTask = movedTask.copyWith(listName: targetListName);
            taskProvider.updateTask(movedTask);
          },
          onListReorder: (oldListIndex, newListIndex) {},
          listDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          listPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          itemDecorationWhileDragging: BoxDecoration(
            color: Colors.grey[200],
          ),
          itemDragOnLongPress: false,
          listDragOnLongPress: true,
        );
      },
    );
  }
}
