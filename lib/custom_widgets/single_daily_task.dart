import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/custom_widgets/task.dart';

class SingleDailyTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        // wdiget from web, Drag and Drop List
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
          onListReorder: (oldListIndex, newListIndex) {
            // if needed, it will handle list reorder
          },
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
          listDragOnLongPress:
              true, // task or list will be graggle iff long press
        );
      },
    );
  }
}

class TaskContainer extends StatelessWidget {
  final Task task;
  final String listName;
  final VoidCallback onTaskRemoved;

  TaskContainer(
      {required this.task,
      required this.listName,
      required this.onTaskRemoved});

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
            child: listName != 'Unassigned Task' && !task.isCompleted
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
          SvgPicture.asset('assets/three_dot.svg'),
        ],
      ),
    );
  }
}
