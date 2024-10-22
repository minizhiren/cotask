import 'package:flutter/material.dart';
import 'package:cotask/custom_widgets/bar_painter.dart';
import 'package:cotask/custom_widgets/single_daily_task.dart';
import 'package:intl/intl.dart';

class DailyTaskPage extends StatefulWidget {
  const DailyTaskPage({super.key});
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<DailyTaskPage> createState() => _DailyTaskPage();
}

class _DailyTaskPage extends State<DailyTaskPage> {
  int currentIndexPage = 0;

  @override
  Widget build(BuildContext context) {
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
                margin: const EdgeInsets.only(left: 18, bottom: 8),
                child: Text('logo')),
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
                      'Date:',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(DateTime.now()), // current date
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
              SingleDailyTask(
                name: 'ME',
                tasks: const [
                  'Clean the dishes',
                  'Buy Groceries',
                  'Buy Groceries',
                  'Buy Groceries'
                ],
              ),
              SingleDailyTask(
                name: 'Lucas',
                tasks: const [],
              ),
              SingleDailyTask(
                name: 'Five',
                tasks: const ['Walk dog'],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
