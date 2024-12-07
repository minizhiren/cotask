import 'package:cotask/custom_widgets/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/global_var_provider.dart';
import 'package:intl/intl.dart';

class CalendarTaskPage extends StatefulWidget {
  const CalendarTaskPage({super.key});

  @override
  State<CalendarTaskPage> createState() => _CalendarTaskPageState();
}

class _CalendarTaskPageState extends State<CalendarTaskPage> {
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentDate =
          DateTime(_currentDate.year, _currentDate.month + offset, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int currentMonth = _currentDate.month;
    final int currentYear = _currentDate.year;

    final String monthName =
        DateFormat.MMMM().format(_currentDate).toUpperCase();

    final firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    final daysInMonth = DateTime(currentYear, currentMonth + 1, 0).day;
    final int firstWeekday = firstDayOfMonth.weekday;
    final int leadingEmptyDays = (firstWeekday % 7);

    final taskProvider = Provider.of<TaskProvider>(context);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    final tasks = taskProvider.tasks;

    final Map<int, List<Color>> taskDotsByDay = {};

    // Generate dots for each task on a given day
    for (var task in tasks) {
      if (task.ownerName != 'Lucas') {
        DateTime taskDate = task.startDate;

        while (!taskDate.isAfter(task.endDate)) {
          if (taskDate.month == currentMonth && taskDate.year == currentYear) {
            final weekdayEnum = Weekday.values[
                taskDate.weekday - 1]; // `DateTime.weekday` 是从 1（周一）到 7（周日）

            if (task.selectedDays.isEmpty ||
                task.selectedDays.contains(weekdayEnum)) {
              int day = taskDate.day;
              taskDotsByDay.putIfAbsent(day, () => []);

              // Assign color based on person assigned to the task
              Color indicatorColor;
              if (task.ownerName == 'Me') {
                indicatorColor = Colors.purple;
              } else if (task.ownerName == 'Lucas') {
                indicatorColor = Colors.orange;
              } else {
                indicatorColor = Colors.grey;
              }

              // Add a dot for each task on the same day
              taskDotsByDay[day]!.add(indicatorColor);  
            }
          }
          taskDate = taskDate.add(Duration(days: 1));
        }
      }
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  "$monthName $currentYear",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                childAspectRatio: 0.8, // Increase height for more space
              ),
              itemCount: daysInMonth + leadingEmptyDays,
              itemBuilder: (context, index) {
                if (index < leadingEmptyDays) {
                  return Container();
                } else {
                  final day = index - leadingEmptyDays + 1;
                  final dotsForDay = taskDotsByDay[day] ?? [];
                  return GestureDetector(
                    onTap: () {
                      dateProvider.updateSelectedDate(
                        DateTime(currentYear, currentMonth, day),
                      );
                      navigationProvider.setCurrentIndex(0);
                    },
                    child: _buildDayBox(day, dotsForDay),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayBox(int day, List<Color> dotsForDay) {
    return Container(
      padding: EdgeInsets.all(2.0),
      margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.toString(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          if (dotsForDay.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Wrap(
                spacing: 1,
                runSpacing: 1.0,
                children: dotsForDay
                    .map((color) => _buildTaskIndicator(color))
                    .toList(),
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
