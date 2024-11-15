import 'package:cotask/providers/global_var_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'providers/task_provider.dart';
import 'providers/user_provider.dart';
import 'package:cotask/custom_widgets/single_daily_task.dart';
import 'package:cotask/custom_widgets/task.dart';

class DailyTaskPage extends StatefulWidget {
  const DailyTaskPage({super.key});

  @override
  State<DailyTaskPage> createState() => _DailyTaskPage();
}

class _DailyTaskPage extends State<DailyTaskPage> {
  int currentIndexPage = 0;
  bool isBusy = false; // 将 isBusy 提升为类的状态字段

  // 任务移除方法
  void onTaskRemoved(Task task, String columnName) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.removeTask(task, true, context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate =
        Provider.of<DateProvider>(context, listen: false).selectedDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFF66372),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF66372),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      Provider.of<DateProvider>(context, listen: false)
          .updateSelectedDate(picked);
    }
  }

  void _toggleBusyStatus() {
    if (isBusy) {
      // Show a confirmation dialog when in Busy state, asking to switch to Available state
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm"),
            content: Text("Do you want to change status to Available?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isBusy = false; // Set local state if needed
                  });

                  Provider.of<UserProvider>(context, listen: false)
                      .setUserStatus('Me', 'Active');

                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text("Confirm"),
              ),
            ],
          );
        },
      );
    } else {
      // When in Available state, show dialog to enter Busy state with a selected duration
      int selectedDays = 1; // Default to 1 day

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Text(
                  "Select Busy Duration",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "How many days would you like to set as Busy?",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blue,
                          inactiveTrackColor: Colors.grey,
                          thumbColor: Colors.blueAccent,
                          overlayColor: Colors.blue.withOpacity(0.2),
                          valueIndicatorColor: Colors.blue,
                        ),
                        child: Slider(
                          value: selectedDays.toDouble(),
                          min: 1,
                          max: 7,
                          divisions: 6,
                          label: "$selectedDays days",
                          onChanged: (value) {
                            setStateDialog(() {
                              selectedDays = value.toInt();
                            });
                          },
                        ),
                      ),
                      Text(
                        "$selectedDays ${selectedDays == 1 ? 'day' : 'days'} selected",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isBusy = true; // Set local state if needed
                      });

                      // Update 'Me' status to 'Inactive' in UserProvider
                      Provider.of<UserProvider>(context, listen: false)
                          .setUserStatus('Me', 'InActive');

                      Navigator.of(context).pop(); // Close dialog
                    },
                    child: Text("Confirm"),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = Provider.of<DateProvider>(context).selectedDate;

    return Scaffold(
      backgroundColor: Colors.white,
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
                  'Daily Task',
                  style: TextStyle(
                    color: Color(0xFFF66372),
                    fontSize: 30,
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Busy 状态选择
                    GestureDetector(
                      onTap: _toggleBusyStatus,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: isBusy
                                ? [
                                    const Color.fromARGB(255, 236, 206, 69),
                                    const Color.fromARGB(255, 233, 221, 112)
                                  ]
                                : [
                                    Colors.green.shade600,
                                    Colors.green.shade400
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isBusy
                                  ? Colors.yellow.shade200
                                  : Colors.green.shade200,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              isBusy ? 'Busy' : 'Available',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.access_time_filled,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 日历选择按钮
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xFFF66372),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(selectedDate),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 245, 136, 147),
                                fontSize: 18,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Color.fromARGB(255, 245, 136, 147),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 1000,
                child: SingleDailyTask(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
