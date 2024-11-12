import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/global_var_provider.dart';
import 'package:cotask/custom_widgets/task.dart';
import 'package:cotask/custom_widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPage();
}

class _CreateTaskPage extends State<CreateTaskPage> {
  final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final selectedDays = <String>{};

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  final TextEditingController taskNameController = TextEditingController();

  // Dropdown options for "Assign to"
  final List<String> assignOptions = ['Unassigned Task', 'Me', 'Lucas'];
  String selectedAssignOption = 'Unassigned Task';

  void addNewTask() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    // Create the new task
    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      name: taskNameController.text.isNotEmpty
          ? taskNameController.text
          : "New Task",
      startDate: startDate,
      endDate: endDate,
      selectedDays: selectedDays,
      ownerName: selectedAssignOption,
      credit: 60,
    );

    // Add the task to the provider
    taskProvider.addTask(newTask);
    Provider.of<NotificationProvider>(context, listen: false).showDot();

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added to schedule')),
    );

    // Reset the form to its default values
    setState(() {
      taskNameController.clear(); // Clear the task name
      selectedDays.clear(); // Clear selected days
      selectedAssignOption = 'Unassigned Task'; // Reset dropdown
      startDate = DateTime.now(); // Reset date to now
      endDate = DateTime.now(); // Reset end date to now
    });
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
                  'Create Task',
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
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Task Name :',
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Assign to:',
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10.0),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0x3FFA7D8A),
                              width: 3.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(150, 250, 125, 137),
                              width: 3.0,
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: Color.fromARGB(86, 50, 50, 50),
                            fontSize: 16,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.w700,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        isExpanded: true,
                        value: selectedAssignOption,
                        items: assignOptions
                            .map((option) => DropdownMenuItem<String>(
                                  value: option,
                                  child: Center(
                                    child: Text(
                                      option,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedAssignOption = value!;
                          });
                        },
                        alignment: Alignment.center,
                      ),
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
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDateRange(context),
                        ),
                        Text(DateFormat('MM/dd').format(startDate)),
                        const SizedBox(width: 20),
                        const Text("To: "),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDateRange(context),
                        ),
                        Text(DateFormat('MM/dd').format(endDate)),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: isSelected
                                      ? const Color.fromARGB(149, 238, 136, 146)
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
              const SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: screenHeight * 0.12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: addNewTask,
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xFFFA7D8A),
                  ),
                  child: const Text(
                    'Add to Schedule',
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
                const SizedBox(width: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
