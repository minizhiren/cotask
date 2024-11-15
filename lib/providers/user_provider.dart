import 'package:flutter/material.dart';

class User {
  int id;
  String name;
  double credit;
  String status;

  User({
    required this.id,
    required this.name,
    required this.credit,
    required this.status,
  });

  // Method to toggle user status
  void toggleStatus() {
    status = (status == 'Active') ? 'Inactive' : 'Active';
  }
}

class UserProvider with ChangeNotifier {
  // Private list to store users
  final List<User> _userList = [
    User(id: 0, name: 'Unassigned Task', credit: 100.0, status: 'Active'),
    User(id: 1, name: 'Me', credit: 200.0, status: 'Active'),
    User(id: 2, name: 'Lucas', credit: 100.0, status: 'InActive'),
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

  // Update a user by ID
  void updateUser(User updatedUser) {
    final index = _userList.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _userList[index] = updatedUser;
      notifyListeners();
    }
  }

  // Get a user by ID

  // Toggle the status of a user by ID
  void toggleUserStatus(int id) {
    final index = _userList.indexWhere((user) => user.id == id);
    if (index != -1) {
      _userList[index].toggleStatus();
      notifyListeners();
    }
  }

  User? findUserByName(String name) {
    return userList.firstWhere((user) => user.name == name);
  }

  void setUserStatus(String userName, String newStatus) {
    final user = userList.firstWhere((user) => user.name == userName);
    user.status = newStatus;
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
