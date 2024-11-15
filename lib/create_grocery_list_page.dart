import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:cotask/custom_widgets/grocery.dart';
import 'package:cotask/providers/global_var_provider.dart';
import 'package:cotask/providers/gorcery_provider.dart';
import 'package:cotask/custom_widgets/custom_textfield.dart';

class GroceryListPage extends StatefulWidget {
  const GroceryListPage({super.key});

  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  final List<TextEditingController> _controllers = [];
  final TextEditingController _listNameController =
      TextEditingController(); // 新增的用于获取grocery list名称的TextController

  @override
  void initState() {
    super.initState();
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

  void addNewTask() {
    // 获取grocery list的名称
    final listName = _listNameController.text.isNotEmpty
        ? _listNameController.text
        : "New Grocery List"; // 如果用户未输入名称，则提供默认名称

    // 收集所有非空的输入项
    final inputGrocery = _controllers
        .where((controller) => controller.text.isNotEmpty)
        .map((controller) => controller.text)
        .toSet();

    if (inputGrocery.isEmpty) {
      // 如果没有任何输入项，提示用户输入
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one item needed')),
      );
      return;
    }

    // 创建一个新的 Grocery 对象
    final newGrocery = Grocery(
      id: DateTime.now().millisecondsSinceEpoch, // 使用时间戳作为唯一ID
      name: listName, // 将用户输入的名称赋值给name
      ownerName: 'Unassigned Task',
      inputGrocery: inputGrocery,
      credit: 60, // 默认信用值
      isCompleted: false,
    );

    // 将新 Grocery 添加到 provider 中
    Provider.of<GroceryProvider>(context, listen: false)
        .addGroceryList(newGrocery);

    Provider.of<NotificationProvider>(context, listen: false).showDot();

    // 清空输入框
    for (var controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();

    _listNameController.clear(); // 清空list name输入框
    _addNewItem(); // 只添加一个新的空白输入框

    // 显示成功提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grocery list added to schedule')),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _listNameController.dispose(); // 释放list name控制器
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
                  'assets/burgur.svg',
                ),
              ),
            ),
            title: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  'Grocery List',
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        text: 'Enter task name',
                        controller: _listNameController,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 30),
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
                                    _addNewItem(); // Automatically add new row only if it's the last one
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
          Positioned(
            bottom: screenHeight * 0.12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add the new task logic here
                    addNewTask();

                    // Update NavigationProvider's index to 1
                    final navigationProvider =
                        Provider.of<NavigationProvider>(context, listen: false);
                    navigationProvider.setCurrentIndex(0);
                  },
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
