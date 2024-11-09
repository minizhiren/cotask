import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'package:cotask/custom_widgets/task.dart';
import 'package:cotask/custom_widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

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

  final daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ]; // Full abbreviations for days

  @override
  void initState() {
    super.initState();
    taskNameController.text = widget.task.name;
    startDate = widget.task.startDate;
    endDate = widget.task.endDate;
    selectedDays.addAll(widget.task.selectedDays);
  }

  void editTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final updatedTask = widget.task.copyWith(
      name: taskNameController.text,
      startDate: startDate,
      endDate: endDate,
      selectedDays: selectedDays,
    );

    // Update task in the specific list
    taskProvider.updateTask(updatedTask);
    Navigator.pop(context);
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
      });
    }
  }

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
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 18, bottom: 18),
                child: SvgPicture.asset(
                  'assets/left_arrow.svg',
                  width: 24, // Adjust the width as needed
                  height: 24, // Adjust the height as needed
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
            children: [
              SizedBox(height: 50),
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
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("From: "),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDateRange(context),
                        ),
                        Text("${DateFormat('MM/dd').format(startDate)}"),
                        SizedBox(width: 20),
                        Text("To: "),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDateRange(context),
                        ),
                        Text("${DateFormat('MM/dd').format(endDate)}"),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          children: daysOfWeek.map((day) {
                            final isSelected = selectedDays.contains(day);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedDays.remove(day);
                                  } else {
                                    selectedDays.add(day);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: isSelected
                                      ? Color.fromARGB(149, 238, 136, 146)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                    150, 250, 125, 137)
                                                .withOpacity(0.4),
                                            spreadRadius: 2,
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
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
              SizedBox(
                height: 100,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                    onPressed: editTask,
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: const Color(0xFFFA7D8A),
                    ),
                    child: const Text(
                      'Create Task',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w900,
                        height: 0,
                      ),
                    )),
                SizedBox(
                  width: 30,
                )
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
