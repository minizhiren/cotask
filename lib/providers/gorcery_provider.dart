import 'package:flutter/material.dart';
import 'package:cotask/custom_widgets/grocery.dart';

class GroceryProvider with ChangeNotifier {
  // Define the groceryLists field
  List<Grocery> groceryLists = [
    Grocery(
      id: 1,
      name: 'Groceries 1',
      ownerName: 'Unassigned Task',
      inputGrocery: {'water', 'coke', 'pepsi'},
      credit: 60,
      isCompleted: false,
    ),
    // Grocery(
    //   id: 2,
    //   name: 'Groceries 2',
    //   listName: 'Unassigned Task',
    //   inputGrocery: {'coke', 'rice', 'food'},
    //   credit: 60,
    //   isCompleted: false,
    // ),
  ];

  // Add a grocery list
  void addGroceryList(Grocery groceryList) {
    groceryLists.add(groceryList);
    notifyListeners();
  }

  // Remove a grocery list
  void removeGroceryList(Grocery groceryList) {
    groceryLists.remove(groceryList);
    notifyListeners();
  }

  // Update a grocery list
  void updateGroceryList(Grocery updatedGrocery) {
    final index = groceryLists.indexWhere((g) => g.id == updatedGrocery.id);
    if (index != -1) {
      groceryLists[index] = updatedGrocery;
      notifyListeners();
    }
  }
}
