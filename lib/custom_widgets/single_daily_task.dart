// single_daily_task.dart
import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/custom_widgets/task.dart'; // Import Task and TaskContainer

class SingleDailyTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        List<DragAndDropList> lists =
            taskProvider.taskColumns.entries.map((entry) {
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
            children: tasks.map((task) {
              return DragAndDropItem(
                child: TaskContainer(
                  task: task,
                  listName: listName,
                  onTaskRemoved: () => taskProvider.removeTask(task, listName),
                ),
              );
            }).toList(),
          );
        }).toList();

        return DragAndDropLists(
          children: lists,
          onItemReorder:
              (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
            String sourceColumn =
                taskProvider.taskColumns.keys.elementAt(oldListIndex);
            String targetColumn =
                taskProvider.taskColumns.keys.elementAt(newListIndex);
            Task movedTask =
                taskProvider.taskColumns[sourceColumn]![oldItemIndex];

            taskProvider.removeTask(movedTask, sourceColumn);
            taskProvider.addTask(movedTask, targetColumn);
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
