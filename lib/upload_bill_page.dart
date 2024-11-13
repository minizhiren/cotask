import 'dart:io';
import 'package:cotask/custom_widgets/grocery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cotask/custom_widgets/custom_textfield.dart';
import 'package:cotask/providers/transfer_provider.dart';
import 'package:cotask/custom_widgets/transfer.dart';
import 'package:cotask/providers/gorcery_provider.dart';

class UploadBillPage extends StatefulWidget {
  final Grocery grocery;

  const UploadBillPage({super.key, required this.grocery});

  @override
  _UploadBillPageState createState() => _UploadBillPageState();
}

class _UploadBillPageState extends State<UploadBillPage> {
  late TextEditingController _listNameController;
  bool _isReceiptUploaded = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final double _taxRate = 0.1;
  final List<Map<String, dynamic>> _sampleItems = [
    {'name': 'Apple', 'price': 1.5},
    {'name': 'Milk', 'price': 2.3},
    {'name': 'Bread', 'price': 2.0},
    {'name': 'Eggs', 'price': 3.0},
    {'name': 'Juice', 'price': 4.5},
  ];

  final List<String> _payers = [
    'UNASSIGN',
    'Me',
    'Lucas',
  ];
  String _selectedPayer = 'UNASSIGN';

  @override
  void initState() {
    super.initState();
    _listNameController = TextEditingController(text: widget.grocery.name);
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  double _calculateSubtotal() {
    return _sampleItems.fold(0, (sum, item) => sum + (item['price'] as double));
  }

  double _calculateTotalPrice() {
    double subtotal = _calculateSubtotal();
    return subtotal + (subtotal * _taxRate);
  }

  void _createTransfers(Grocery grocery) {
    if (_selectedPayer == 'UNASSIGN') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid payer.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final totalAmount = _calculateTotalPrice();
    final receiptName = _listNameController.text;

    // Generate transfer objects for each user except the selected payer
    for (var payer in _payers) {
      if (payer != _selectedPayer) {
        final transfer = Transfer(
          id: DateTime.now().millisecondsSinceEpoch,
          name: receiptName,
          ownerName: payer,
          status: TransferStatus.uncompleted,
          bill: _sampleItems
              .map((item) =>
                  '${item['name']} - \$${item['price'].toStringAsFixed(2)}')
              .toList(),
          payer: _selectedPayer,
          price: totalAmount / (_payers.length - 1), // Split amount equally
        );

        // Add the transfer to the TransferProvider
        Provider.of<TransferProvider>(context, listen: false)
            .addTransfer(transfer);
      }
    }

    // Mark the passed grocery as completed
    final groceryProvider =
        Provider.of<GroceryProvider>(context, listen: false);
    final updatedGrocery = grocery.copyWith(isCompleted: true);
    groceryProvider.updateGroceryList(updatedGrocery);

    // Show confirmation and navigate back or to another page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Transfers created and grocery marked as completed.')),
    );
    Navigator.pop(context);
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
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Text(
                        'Tap to upload an image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          if (_isReceiptUploaded) ...[
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
                      Text(
                        '\$${item['price'].toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal:',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '\$${_calculateSubtotal().toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tax (10%):',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '\$${(_calculateSubtotal() * _taxRate).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ] else
            const Center(
              child: Text(
                'Press CONFIRM to display a sample receipt.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          const SizedBox(height: 30),
          const Text(
            'Payer:',
            style: TextStyle(color: Colors.black87, fontSize: 18),
          ),
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
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isReceiptUploaded
                  ? () => _createTransfers(
                      widget.grocery) // Pass the grocery parameter here
                  : () {
                      setState(() {
                        _isReceiptUploaded = true;
                      });
                    },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color(0xFFFA7D8A),
              ),
              child: Text(
                _isReceiptUploaded ? 'SPLIT' : 'CONFIRM',
                textAlign: TextAlign.center,
                style: const TextStyle(
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
      ),
    );
  }
}
