import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cotask/edit_task_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/task_provider.dart';
import 'package:cotask/providers/global_var_provider.dart';

class Grocery {
  final int id;
  final String name;
  final String listName;
  final int credit;
  final bool isCompleted;
  final Set<String> inputGrocery;

  Grocery({
    required this.id,
    required this.name,
    required this.listName,
    required this.credit,
    required this.isCompleted,
    required this.inputGrocery,
  });

  // Method to create a copy with updated values
  Grocery copyWith({
    int? id,
    String? name,
    String? listName,
    int? credit,
    bool? isCompleted,
    Set<String>? inputGrocery,
  }) {
    return Grocery(
      id: id ?? this.id,
      name: name ?? this.name,
      listName: listName ?? this.listName,
      credit: credit ?? this.credit,
      isCompleted: isCompleted ?? this.isCompleted,
      inputGrocery: inputGrocery ?? this.inputGrocery,
    );
  }
}

class GroceryContainer extends StatelessWidget {
  final Grocery groceryList;
  final VoidCallback onGroceryRemoved;
  final VoidCallback onCompleted;

  GroceryContainer({
    required this.groceryList,
    required this.onGroceryRemoved,
    required this.onCompleted,
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
          // Drag handle
          SizedBox(
            width: 30,
            child: SvgPicture.asset('assets/drag_handle.svg'),
          ),
          // Grocery item name
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                groceryList.name,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  decoration: groceryList.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // Mark as completed checkbox
          SizedBox(
            width: 30,
            child: groceryList.listName != 'Unassigned'
                ? GestureDetector(
                    onTap: onCompleted,
                    child: SvgPicture.asset(
                      'assets/check_circle.svg',
                      color: groceryList.isCompleted
                          ? Colors.green
                          : Color.fromARGB(255, 115, 202, 115),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(width: 10),
          // Edit or options menu
          GestureDetector(
            onTap: () {
              // Navigate to edit page or open options
              // Implement the edit functionality here
            },
            child: SvgPicture.asset('assets/three_dot.svg'),
          ),
        ],
      ),
    );
  }
}
