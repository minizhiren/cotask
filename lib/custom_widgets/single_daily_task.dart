import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/providers/gorcery_provider.dart';
import 'package:cotask/providers/global_var_provider.dart';
import 'package:cotask/custom_widgets/task.dart';
import 'package:cotask/custom_widgets/grocery.dart';

class SingleDailyTask extends StatelessWidget {
  // Define all list names, even if empty, for both tasks and groceries
  final List<String> predefinedListNames = ['Unassigned Task', 'Me', 'Lucas'];
  final ScrollController _scrollController =
      ScrollController(); // ScrollController added

  @override
  Widget build(BuildContext context) {
    // Get selected date
    final selectedDate = Provider.of<DateProvider>(context).selectedDate;
    final year = selectedDate.year;
    final month = selectedDate.month;
    final day = selectedDate.day;
    final selectedWeekday = selectedDate.weekday; // 1=Monday, ..., 7=Sunday

    return Consumer2<TaskProvider, GroceryProvider>(
      builder: (context, taskProvider, groceryProvider, child) {
        // Initialize grouped items (tasks and groceries) Map, ensuring each predefined list has an empty list
        Map<String, List<dynamic>> groupedItems = {
          for (var listName in predefinedListNames) listName: []
        };

        // Group tasks by `listName`
        for (var task in taskProvider.tasks) {
          bool isTaskCompleted =
              task.completionStatus[year]?[month]?[day] ?? false;
          bool isWithinDateRange = selectedDate
                  .isAfter(task.startDate.subtract(Duration(days: 1))) &&
              selectedDate.isBefore(task.endDate.add(Duration(days: 1)));
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

          if (isWithinDateRange && !isTaskCompleted && shouldShowTask) {
            groupedItems[task.listName]?.add(task);
          }
        }

        // Group groceries by `listName`
        for (var grocery in groceryProvider.groceryLists) {
          if (!grocery.isCompleted) {
            groupedItems[grocery.listName]?.add(grocery);
          }
        }

        // Build DragAndDropLists
        List<DragAndDropList> lists = groupedItems.entries.map((entry) {
          String listName = entry.key;
          List<dynamic> items = entry.value;

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
            children: items.isNotEmpty
                ? items
                    .map((item) {
                      if (item is Task) {
                        return DragAndDropItem(
                          child: TaskContainer(
                            task: item,
                            onTaskRemoved: () => taskProvider.removeTask(item),
                          ),
                        );
                      } else if (item is Grocery) {
                        return DragAndDropItem(
                          child: GroceryContainer(
                            groceryList: item,
                            onGroceryRemoved: () =>
                                groceryProvider.removeGroceryList(item),
                            onCompleted: () {
                              final updatedItem =
                                  item.copyWith(isCompleted: !item.isCompleted);
                              groceryProvider.updateGroceryList(updatedItem);
                            },
                          ),
                        );
                      }
                      return null;
                    })
                    .whereType<DragAndDropItem>()
                    .toList()
                : [
                    DragAndDropItem(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                            'No items available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  ],
          );
        }).toList();

        return DragAndDropLists(
          children: lists,
          scrollController: _scrollController, // Assign the ScrollController
          onItemReorder:
              (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
            var sourceListName = predefinedListNames[oldListIndex];
            var targetListName = predefinedListNames[newListIndex];
            var movedItem = groupedItems[sourceListName]![oldItemIndex];

            if (movedItem is Task) {
              movedItem = movedItem.copyWith(listName: targetListName);
              taskProvider.updateTask(movedItem);
            } else if (movedItem is Grocery) {
              movedItem = movedItem.copyWith(listName: targetListName);
              groceryProvider.updateGroceryList(movedItem);
            }
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
