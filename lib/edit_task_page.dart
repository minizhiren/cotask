import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'package:cotask/custom_widgets/task.dart';
import 'package:cotask/custom_widgets/custom_textfield.dart';
import 'package:intl/intl.dart';
import 'package:cotask/providers/global_var_provider.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;
  final String listName;

  const EditTaskPage({super.key, required this.task, required this.listName});

  @override
  State<EditTaskPage> createState() => _EditTaskPage();
}

class _EditTaskPage extends State<EditTaskPage> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  final Set<String> selectedDays = {};
  final TextEditingController taskNameController = TextEditingController();

  final Set<String> enabledDays = {};

  final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();

    // 初始化任务名称、开始和结束日期
    taskNameController.text = widget.task.name;
    startDate = widget.task.startDate;
    endDate = widget.task.endDate;
    selectedDays.addAll(widget.task.selectedDays);

    // 调用 _updateEnabledDays 方法以基于初始的 startDate 和 endDate 设置 enabledDays
    _updateEnabledDays();
  }

  void _deleteTask() {
    Provider.of<TaskProvider>(context, listen: false).removeTask(widget.task);
    Provider.of<NotificationProvider>(context, listen: false).showDot();
    Navigator.pop(context); // Go back after deleting the task
  }

  void editTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final updatedTask = widget.task.copyWith(
      name: taskNameController.text,
      startDate: startDate,
      endDate: endDate,
      selectedDays: selectedDays,
    );

    taskProvider.updateTask(updatedTask);
    Navigator.pop(context);
  }

  void _updateEnabledDays() {
    enabledDays.clear();
    if (endDate.difference(startDate).inDays < 7) {
      DateTime currentDate = startDate;
      while (!currentDate.isAfter(endDate)) {
        String weekday = DateFormat('EEE').format(currentDate);
        enabledDays.add(weekday);
        currentDate = currentDate.add(Duration(days: 1));
      }
    } else {
      enabledDays.addAll(daysOfWeek);
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        _updateEnabledDays();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 18, bottom: 18),
                child: SvgPicture.asset(
                  'assets/left_arrow.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Edit Task',
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
            padding: const EdgeInsets.only(
                bottom: 80), // Extra padding to prevent overlap
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Task Name:',
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      text: 'Enter task name',
                      controller: taskNameController,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text("From : "),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () =>
                              _selectDateRange(context), // 点击整个框架触发日期选择
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.black), // 图标
                                SizedBox(width: 8), // 空间
                                Text(
                                  DateFormat('MM/dd').format(startDate), // 文字
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Text("To: "),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () =>
                              _selectDateRange(context), // 点击整个框架触发日期选择
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: Colors.black), // 图标
                                SizedBox(width: 8), // 空间
                                Text(
                                  DateFormat('MM/dd').format(endDate), // 文字
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          spacing: 8.0,
                          children: daysOfWeek.map((day) {
                            final isEnabled = enabledDays.contains(day);
                            final isSelected = selectedDays.contains(day);
                            return GestureDetector(
                              onTap: isEnabled
                                  ? () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedDays.remove(day);
                                        } else {
                                          selectedDays.add(day);
                                        }
                                      });
                                    }
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isEnabled
                                      ? Colors.white
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: isEnabled
                                      ? [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: isEnabled
                                        ? (isSelected
                                            ? const Color.fromARGB(
                                                255, 250, 149, 149)
                                            : const Color.fromARGB(
                                                255, 160, 153, 153))
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              bottom: screenHeight * 0.15, // 15% from the bottom of the screen
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 170, // Adjust width as needed
                    child: ElevatedButton(
                      onPressed: editTask,
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: const Color(0xFFFA7D8A),
                      ),
                      child: const Text(
                        'Save Changes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w900,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 170, // Adjust width as needed
                    child: ElevatedButton(
                      onPressed: _deleteTask,
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: const Color(0xFFFA7D8A),
                      ),
                      child: const Text(
                        'Delete Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w900,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
