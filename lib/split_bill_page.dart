import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cotask/custom_widgets/custom_textfield.dart';

class SplitBillPage extends StatefulWidget {
  final String initialListName;

  const SplitBillPage({super.key, required this.initialListName});

  @override
  _SplitBillPageState createState() => _SplitBillPageState();
}

class _SplitBillPageState extends State<SplitBillPage> {
  late TextEditingController _listNameController;
  bool _isReceiptUploaded = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  String _selectedSplitMethod = 'Choose Split Way'; // 默认的分单方式
  String _selectedPayer = 'Select Payer'; // 默认的付款人

  final List<String> _splitMethods = ['Proportional', 'Equal Split'];
  final List<String> _payers = [
    'Select Payer',
    'Me',
    'Lucas',
  ]; // 添加默认项

  final double _taxRate = 0.1;
  final List<Map<String, dynamic>> _sampleItems = [
    {'name': 'Apple', 'price': 1.5, 'selected': false},
    {'name': 'Milk', 'price': 2.3, 'selected': false},
    {'name': 'Bread', 'price': 2.0, 'selected': false},
    {'name': 'Eggs', 'price': 3.0, 'selected': false},
    {'name': 'Juice', 'price': 4.5, 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    _listNameController = TextEditingController(text: widget.initialListName);
  }

  double _calculateSubtotal() {
    return _sampleItems
        .where((item) => item['selected'] == true)
        .fold(0, (sum, item) => sum + (item['price'] as double));
  }

  double _calculateTotalPrice() {
    double subtotal = _calculateSubtotal();
    return subtotal + (subtotal * _taxRate);
  }

  void _chooseSplitWay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Split Way'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _splitMethods.map((method) {
            return ListTile(
              title: Text(method),
              selected: _selectedSplitMethod == method,
              onTap: () {
                setState(() {
                  _selectedSplitMethod = method;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listNameController.dispose();
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
                  'Upload Receipt',
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Receipt name:',
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: CustomTextField(
                  text: 'Enter receipt name',
                  controller: _listNameController,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _selectedPayer,
            items: _payers
                .map((payer) => DropdownMenuItem(
                      value: payer,
                      child: Text(payer),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedPayer = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sampleItems.length,
            itemBuilder: (context, index) {
              final item = _sampleItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          '\$${item['price'].toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Checkbox(
                          value: item['selected'],
                          onChanged: (value) {
                            setState(() {
                              item['selected'] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _chooseSplitWay,
            child: Text(_selectedSplitMethod),
          ),
          const SizedBox(height: 30),
          const Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
