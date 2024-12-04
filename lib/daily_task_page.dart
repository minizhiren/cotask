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
  // Task removal logic
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
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFF66372),
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.findUserByName('Me');
    final Set<DateTime> initialBusyDays = user?.busyDays ?? {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Set<DateTime> tempSelectedDates = {...initialBusyDays};

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Text(
                "Select Busy Dates",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9, // Dialog宽度
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 提示用户的说明文本
                    const Text(
                      "Tap to select/deselect up to 7 days",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    // 使用SizedBox对GridView进行约束
                    SizedBox(
                      height: 300, // 约束高度
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7, // 每行显示7天（周一到周日）
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: 42, // 假设每月最多6周
                        itemBuilder: (context, index) {
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          final firstDate =
                              DateTime(today.year, today.month, 1);
                          final date = firstDate.add(Duration(days: index));

                          if (date.isBefore(today)) {
                            return const SizedBox(); // 不允许选择今天之前的日期
                          }

                          final isSelected = tempSelectedDates.contains(date);

                          return GestureDetector(
                            onTap: () {
                              setStateDialog(() {
                                if (isSelected) {
                                  tempSelectedDates.remove(date);
                                } else if (tempSelectedDates.length >= 7) {
                                  // 显示警告
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "You can select up to 7 days only."),
                                    ),
                                  );
                                } else {
                                  tempSelectedDates.add(date);
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${date.day}",
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 关闭弹窗，不保存
                  },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // 更新用户的busyDays数据
                    userProvider.updateUserBusyDates('Me', tempSelectedDates);

                    Navigator.of(context).pop(); // 关闭弹窗并保存
                  },
                  child: const Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = Provider.of<DateProvider>(context).selectedDate;
    final userProvider = Provider.of<UserProvider>(context);
    final busyDays = userProvider.findUserByName('Me')?.busyDays ?? {};
    final isBusy = busyDays.contains(selectedDate);

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
                    // GestureDetector(
                    //   onTap: _toggleBusyStatus,
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 8, horizontal: 20),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(12),
                    //       gradient: LinearGradient(
                    //         colors: isBusy
                    //             ? [
                    //                 const Color.fromARGB(255, 236, 206, 69),
                    //                 const Color.fromARGB(255, 233, 221, 112)
                    //               ]
                    //             : [
                    //                 Colors.green.shade600,
                    //                 Colors.green.shade400
                    //               ],
                    //         begin: Alignment.topLeft,
                    //         end: Alignment.bottomRight,
                    //       ),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: isBusy
                    //               ? Colors.yellow.shade200
                    //               : Colors.green.shade200,
                    //           blurRadius: 10,
                    //           offset: const Offset(0, 4),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           isBusy ? 'Busy' : 'Available',
                    //           style: const TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.bold,
                    //             fontFamily: 'Quicksand',
                    //           ),
                    //         ),
                    //         const SizedBox(width: 8),
                    //         const Icon(
                    //           Icons.access_time_filled,
                    //           color: Colors.white,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: _toggleBusyStatus,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white, // 设置背景为白色
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 居中对齐
                          children: [
                            Text(
                              isBusy ? 'Busy' : 'Available',
                              style: const TextStyle(
                                color: Colors.black, // 修改文字为黑色
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.access_time_filled,
                              color: isBusy
                                  ? const Color.fromARGB(255, 240, 224, 3)
                                  : Color.fromARGB(255, 115, 202, 115),
                            ),
                          ],
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFFF66372),
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
