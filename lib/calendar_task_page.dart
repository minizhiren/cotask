import 'package:flutter/material.dart';

class CalendarTaskPage extends StatelessWidget {
  final List<int> taskDays = [
    3,
    5,
    7,
    12,
    14,
    19,
    23,
    25,
    28
  ]; // Days with tasks

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(106.0),
        child: Material(
          elevation: 4.0,
          child: AppBar(
            leadingWidth: 72,
            toolbarHeight: 106,
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 18, bottom: 8),
                child: Text('logo')),
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Calender',
                  style: TextStyle(
                    color: Color(0xFFF66372),
                    fontSize: 30,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Month label
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              'SEPTEMBER',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          // Days of the week header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('S', style: TextStyle(color: Colors.red, fontSize: 18)),
                Text('M', style: TextStyle(color: Colors.red, fontSize: 18)),
                Text('T', style: TextStyle(color: Colors.red, fontSize: 18)),
                Text('W', style: TextStyle(color: Colors.red, fontSize: 18)),
                Text('T', style: TextStyle(color: Colors.red, fontSize: 18)),
                Text('F', style: TextStyle(color: Colors.red, fontSize: 18)),
                Text('S', style: TextStyle(color: Colors.red, fontSize: 18)),
              ],
            ),
          ),
          // Calendar Grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: 30, // Number of days in the month
              itemBuilder: (context, index) {
                final day = index + 1;
                return _buildDayBox(day, taskDays.contains(day));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBox(int day, bool hasTask) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          // Day number
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              day.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          // Task indicators (if any tasks on that day)
          if (hasTask)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTaskIndicator(Colors.orange), // Task color indicator
                  SizedBox(width: 4),
                  _buildTaskIndicator(Colors.purple),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskIndicator(Color color) {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
