import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'package:cotask/custom_widgets/task.dart';
import 'package:cotask/custom_widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPage();
}

class _CreateTaskPage extends State<CreateTaskPage> {
  bool isRecurring = false;

  final daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ]; // Full abbreviations for days
  final selectedDays = <String>{};

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // Text editing controller for task name
  final TextEditingController taskNameController = TextEditingController();

  // Function to add a new task
  void addNewTask() {
    // Fetching the task provider
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // Creating a new task with all parameters
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      name: taskNameController.text.isNotEmpty
          ? taskNameController.text
          : "New Task",
      startDate: startDate,
      endDate: endDate,
      isRecurring: isRecurring,
      selectedDays: isRecurring
          ? selectedDays
          : <String>{}, // Using selected days for recurring events
      isDeletable: true,
    );

    // Adding the task to the "Unassigned Task" column
    taskProvider.addTask(newTask, 'Unassigned Task');
  }

  // Function to select date range
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
                  'Create Task',
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
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Task Name :',
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: CustomTextField(
                      text: 'Enter task name',
                      controller: taskNameController, // Add controller
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
                        Text("From : "),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: isRecurring,
                          onChanged: (value) {
                            setState(() {
                              isRecurring = value!;
                            });
                          },
                        ),
                        Text("Recurring event"),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
              Center(
                child: ElevatedButton(
                  onPressed: addNewTask,
                  child: Text('Add New Task'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
