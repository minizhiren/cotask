import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/providers/gorcery_provider.dart';
import 'package:cotask/providers/global_var_provider.dart';
import 'package:cotask/providers/transfer_provider.dart'; // 新增 TransferProvider
import 'package:cotask/custom_widgets/task.dart';
import 'package:cotask/custom_widgets/grocery.dart';
import 'package:cotask/custom_widgets/transfer.dart'; // 新增 TransferContainer

class SingleDailyTask extends StatelessWidget {
  final List<String> predefinedListNames = ['Unassigned Task', 'Me', 'Lucas'];
  final ScrollController _scrollController = ScrollController();

  SingleDailyTask({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDate = Provider.of<DateProvider>(context).selectedDate;
    final year = selectedDate.year;
    final month = selectedDate.month;
    final day = selectedDate.day;
    final selectedWeekday = selectedDate.weekday;

    return Consumer4<TaskProvider, GroceryProvider, TransferProvider,
        NotificationProvider>(
      builder: (context, taskProvider, groceryProvider, transferProvider,
          notificationProvider, child) {
        Map<String, List<dynamic>> groupedItems = {
          for (var listName in predefinedListNames) listName: []
        };

        // 处理 Task 项目
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
            groupedItems[task.ownerName]?.add(task);
          }
        }

        // 处理 Grocery 项目
        for (var grocery in groceryProvider.groceryLists) {
          print(grocery.name);
          if (!grocery.isCompleted) {
            groupedItems[grocery.ownerName]?.add(grocery);
          }
        }

        // 处理 Transfer 项目
        for (var transfer in transferProvider.transferLists) {
          print(transfer.name);
          if (transfer.status != TransferStatus.completed) {
            print(transfer.name);
            print(transfer.ownerName);
            print(transfer.bill);
            groupedItems[transfer.ownerName]?.add(transfer);
          }
        }

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
                        print('trigerd');
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
                      } else if (item is Transfer) {
                        // 新增 Transfer 处理
                        print('trigerd');
                        return DragAndDropItem(
                          child: TransferContainer(
                            transfer: item,
                            onCompleted: () {
                              // Toggle the status based on current status
                              TransferStatus newStatus;
                              print('go to pending');
                              if (item.status == TransferStatus.uncompleted) {
                                print('go to pending');
                                newStatus = TransferStatus.pending;
                              } else if (item.status ==
                                  TransferStatus.pending) {
                                newStatus = TransferStatus.readyToComplete;
                                print('go to read');
                              } else if (item.status ==
                                  TransferStatus.readyToComplete) {
                                newStatus = TransferStatus.completed;
                              } else {
                                newStatus = TransferStatus
                                    .uncompleted; // Reset if already completed
                              }

                              final updatedTransfer =
                                  item.copyWith(status: newStatus);
                              transferProvider.updateTransfer(updatedTransfer);
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
          scrollController: _scrollController,
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
            } else if (movedItem is Transfer) {
              // 新增 Transfer 处理
              movedItem = movedItem.copyWith(listName: targetListName);
              transferProvider.updateTransfer(movedItem);
            }

            // 触发通知
            notificationProvider.showDot();
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
