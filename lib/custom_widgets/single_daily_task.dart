import 'package:flutter/material.dart';

class SingleDailyTask extends StatefulWidget {
  final String name;
  final List<String> tasks;

  SingleDailyTask({required this.name, required this.tasks});

  @override
  _SingleDailyTaskState createState() => _SingleDailyTaskState();
}

class _SingleDailyTaskState extends State<SingleDailyTask> {
  late List<String> _tasks;

  @override
  void initState() {
    super.initState();
    // Clone the list to make sure it's mutable
    _tasks = List<String>.from(widget.tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.name,
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: _tasks.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: _tasks
                          .asMap()
                          .entries
                          .map((entry) => ListTile(
                                leading: Text(
                                  'TASK ${entry.key + 1} -', // rank of tasks
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                title: Text(
                                  entry.value,
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: Icon(Icons.more_vert),
                                onTap: () {
                                  // Show dialog when the task is tapped
                                  _showCompletionDialog(
                                      context, entry.value, entry.key);
                                },
                              ))
                          .toList(),
                    ),
                  )
                : Center(
                    child: Text(
                      'No assigned Task',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // This method shows a dialog when a task is tapped
  void _showCompletionDialog(BuildContext context, String taskName, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Task Completion'),
          content: Text('Have you completed "$taskName"?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Remove the task from the list
                setState(() {
                  _tasks.removeAt(index);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Task "$taskName" marked as complete!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
