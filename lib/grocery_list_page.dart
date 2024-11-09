import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroceryListPage extends StatefulWidget {
  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
  List<TextEditingController> _controllers = [];
  List<Widget> _textFields = [];

  @override
  void initState() {
    super.initState();
    _addNewItem();
  }

  void _addNewItem() {
    final controller = TextEditingController();
    _controllers.add(controller);
    _textFields.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0), // 将序号下移一点
              child: Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 243, 126, 126),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${_textFields.length + 1}',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _addNewItem(); // 自动添加新行
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter grocery item',
                  contentPadding: EdgeInsets.only(bottom: 8.0), // 上移下划线
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 240, 142, 142),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10)
          ],
        ),
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
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
                  'assets/burgur.svg',
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
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 8),
        child: ListView(
          children: _textFields,
        ),
      ),
    );
  }
}
