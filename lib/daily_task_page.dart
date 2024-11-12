import 'package:cotask/providers/global_var_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'providers/task_provider.dart';
import 'package:cotask/custom_widgets/single_daily_task.dart';
import 'package:cotask/custom_widgets/task.dart';

class DailyTaskPage extends StatefulWidget {
  const DailyTaskPage({super.key});

  @override
  State<DailyTaskPage> createState() => _DailyTaskPage();
}

class _DailyTaskPage extends State<DailyTaskPage> {
  int currentIndexPage = 0;

  // 任务移除方法
  void onTaskRemoved(Task task, String columnName) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.removeTask(task);
  }

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate =
        Provider.of<DateProvider>(context, listen: false).selectedDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // 设置为当前选中的日期
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFF66372), // 设置主色调
              onPrimary: Colors.white, // 选中日期的文字颜色
              onSurface: Colors.black, // 普通日期的文字颜色
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFF66372), // 设置确定按钮颜色
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
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Daily Task',
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
      body: Stack(
        children: <Widget>[
          ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
