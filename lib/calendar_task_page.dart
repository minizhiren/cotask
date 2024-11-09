import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/global_var_provider.dart';
import 'package:intl/intl.dart';

class CalendarTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    final String monthName = DateFormat.MMMM().format(now).toUpperCase();

    final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final int firstWeekday = firstDayOfMonth.weekday;
    final int leadingEmptyDays = (firstWeekday % 7);

    final taskProvider = Provider.of<TaskProvider>(context);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    final tasks = taskProvider.tasks;

    final Map<int, Set<String>> taskDays = {};

    for (var task in tasks) {
      if (task.startDate.month == currentMonth &&
          task.startDate.year == currentYear) {
        for (int day = task.startDate.day; day <= task.endDate.day; day++) {
          final date = DateTime(currentYear, currentMonth, day);
          final weekdayString = DateFormat.E().format(date); // 获取星期简写

          if (task.selectedDays.isEmpty ||
              task.selectedDays.contains(weekdayString)) {
            taskDays.putIfAbsent(day, () => <String>{});
            taskDays[day]!.add(task.listName);
          }
        }
      } else {}
    }

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
              margin: const EdgeInsets.only(left: 18, bottom: 18),
              child: SvgPicture.asset('assets/burgur.svg'),
            ),
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Calendar',
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
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Text(
              monthName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
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
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
              ),
              itemCount: daysInMonth + leadingEmptyDays,
              itemBuilder: (context, index) {
                if (index < leadingEmptyDays) {
                  return Container();
                } else {
                  final day = index - leadingEmptyDays + 1;
                  final listNamesForDay = taskDays[day] ?? <String>{};
                  return GestureDetector(
                    onTap: () {
                      dateProvider.updateSelectedDate(
                        DateTime(currentYear, currentMonth, day),
                      );
                      navigationProvider.setCurrentIndex(0);
                    },
                    child: _buildDayBox(day, listNamesForDay),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBox(int day, Set<String> listNamesForDay) {
    List<Widget> taskIndicators = [];

    for (var listName in listNamesForDay) {
      print(listName);
      Color indicatorColor;
      if (listName == 'Me') {
        indicatorColor = Colors.purple;
      } else if (listName == 'Lucas') {
        indicatorColor = Colors.orange;
      } else {
        indicatorColor = Colors.grey;
      }
      taskIndicators.add(_buildTaskIndicator(indicatorColor));
    }

    return Container(
      padding: EdgeInsets.all(2.0),
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.toString(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          if (taskIndicators.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: taskIndicators,
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
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
