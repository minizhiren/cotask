import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cotask/providers/gorcery_provider.dart';
import 'package:cotask/custom_widgets/grocery.dart';
import 'package:cotask/custom_widgets/custom_textfield.dart';

class EditGroceryPage extends StatefulWidget {
  final Grocery grocery;

  const EditGroceryPage({super.key, required this.grocery});

  @override
  _EditGroceryPageState createState() => _EditGroceryPageState();
}

class _EditGroceryPageState extends State<EditGroceryPage> {
  final List<TextEditingController> _controllers = [];
  final TextEditingController _listNameController =
      TextEditingController(); // Controller for grocery list name

  @override
  void initState() {
    super.initState();
    _listNameController.text = widget.grocery.name; // Set initial list name
    for (var item in widget.grocery.inputGrocery) {
      _controllers.add(TextEditingController(text: item));
    }
    _addNewItem();
  }

  void _addNewItem() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeItem(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
    });
  }

  void _saveChanges() {
    final updatedInputGrocery = _controllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => controller.text)
        .toSet();

    if (updatedInputGrocery.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one item')),
      );
      return;
    }

    final updatedGrocery = widget.grocery.copyWith(
      name: _listNameController.text, // Update list name
      inputGrocery: updatedInputGrocery,
    );

    Provider.of<GroceryProvider>(context, listen: false)
        .updateGroceryList(updatedGrocery);

    Navigator.pop(context);
  }

  void _deleteTask() {
    Provider.of<GroceryProvider>(context, listen: false)
        .removeGroceryList(widget.grocery);

    Navigator.pop(context); // Go back after deleting the task
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _listNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Edit Grocery List',
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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'List Name :',
                        style: TextStyle(color: Colors.black87, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: CustomTextField(
                        text: 'Enter list name',
                        controller: _listNameController,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _controllers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 5),
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Container(
                                width: 23,
                                height: 23,
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 243, 126, 126),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextField(
                                controller: _controllers[index],
                                onSubmitted: (value) {
                                  if (value.isNotEmpty &&
                                      index == _controllers.length - 1) {
                                    _addNewItem();
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Enter grocery item',
                                  contentPadding: EdgeInsets.only(bottom: 8.0),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 240, 142, 142),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(index),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: const Alignment(
                  0.0, 0.85), // Aligns the buttons 15% above the bottom
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 170, // Adjust width as needed
                    child: ElevatedButton(
                      onPressed: _saveChanges,
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
