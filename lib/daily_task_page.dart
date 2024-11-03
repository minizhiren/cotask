import 'package:flutter/material.dart';
import 'package:cotask/custom_widgets/single_daily_task.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
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
    taskProvider.removeTask(task, columnName);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TaskProvider>(context);

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
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      ' ',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(DateTime.now()),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 204, 128, 128),
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                height: 800,
                child: SingleDailyTask(),
              ),
              const SizedBox(height: 20),
              // 添加按钮到 ListView 的底部
            ],
          ),
        ],
      ),
    );
  }
}
