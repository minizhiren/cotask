import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cotask/edit_grocery_list_page.dart';
import 'package:cotask/upload_bill_page.dart';

class Grocery {
  final int id;
  final String name;
  final String ownerName;
  final int credit;
  final bool isCompleted;
  final Set<String> inputGrocery;

  Grocery({
    required this.id,
    required this.name,
    required this.ownerName,
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
      ownerName: listName ?? this.ownerName,
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

  const GroceryContainer({
    super.key,
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
          SizedBox(
            width: 30,
            child: SvgPicture.asset('assets/drag_handle.svg'),
          ),
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
          SizedBox(
            width: 30,
            child: groceryList.ownerName != 'Unassigned'
                ? GestureDetector(
                    onTap: () {
                      // Navigate to EditGroceryPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UploadBillPage(grocery: groceryList),
                        ),
                      );
                    },
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
          GestureDetector(
            onTap: () {
              // Navigate to EditGroceryPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGroceryPage(grocery: groceryList),
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
