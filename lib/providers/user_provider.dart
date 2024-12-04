import 'package:flutter/material.dart';

class User {
  int id;
  String name;
  double credit;
  Set<DateTime> busyDays; // 改为 busyDays，存储忙碌的日期

  User({
    required this.id,
    required this.name,
    required this.credit,
    required this.busyDays,
  });

  // Method to toggle a date in busyDays
  void toggleBusyDay(DateTime date) {
    if (busyDays.contains(date)) {
      busyDays.remove(date);
    } else {
      busyDays.add(date);
    }
  }
}

class UserProvider with ChangeNotifier {
  // Private list to store users
  final List<User> _userList = [
    User(id: 0, name: 'Unassigned Task', credit: 100.0, busyDays: {}),
    User(id: 1, name: 'Me', credit: 200.0, busyDays: {DateTime(2024, 12, 5)}),
    User(id: 2, name: 'Lucas', credit: 100.0, busyDays: {
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
    }),
  ];

  // Getter to access the user list
  List<User> get userList => _userList;

  // Add a new user
  void addUser(User user) {
    _userList.add(user);
    notifyListeners();
  }

  // Remove a user by ID
  void removeUser(int id) {
    _userList.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  void updateUserBusyDates(String userName, Set<DateTime> newBusyDates) {
    final user = userList.firstWhere(
      (user) => user.name == userName,
    );
    if (user != null) {
      user.busyDays = newBusyDates;
      print('after update funciton');
      print(user.name);
      print(user.busyDays);
      print(newBusyDates);

      notifyListeners(); // Notify listeners of the update
    }
  }

  // Update a user by ID
  void updateUser(User updatedUser) {
    final index = _userList.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _userList[index] = updatedUser;
      notifyListeners();
    }
  }

  // Toggle a busy day for a user by ID
  void toggleUserBusyDay(int id, DateTime date) {
    final index = _userList.indexWhere((user) => user.id == id);
    if (index != -1) {
      _userList[index].toggleBusyDay(date);
      notifyListeners();
    }
  }

  // Get a user by name
  User? findUserByName(String name) {
    return userList.firstWhere(
      (user) => user.name == name,
    );
  }

  // Set busy days for a user by name
  void setUserBusyDays(String userName, Set<DateTime> newBusyDays) {
    final user = userList.firstWhere((user) => user.name == userName);
    user.busyDays = newBusyDays;
    notifyListeners();
  }

  // Add credit to a user
  void addCreditToUser(User user, int credit) {
    user.credit += credit;
    notifyListeners();
    print(user.credit);
    print('----------------------------------------------');
  }
}
