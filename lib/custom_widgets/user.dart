import 'package:flutter/material.dart';

class User {
  int id;
  String name;
  double credit;
  String status;

  // Constructor
  User({
    required this.id,
    required this.name,
    required this.credit,
    required this.status,
  });

  // Method to display user information
  void displayInfo() {
    print('ID: $id');
    print('Name: $name');
    print('Credit: $credit');
    print('Status: $status');
  }
}
