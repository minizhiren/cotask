import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}

class DateProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void updateSelectedDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}

class NotificationProvider with ChangeNotifier {
  bool _showCalendarDot = false;

  bool get showCalendarDot => _showCalendarDot;

  void showDot() {
    _showCalendarDot = true;
    notifyListeners();
  }

  void hideDot() {
    _showCalendarDot = false;
    notifyListeners();
  }
}
