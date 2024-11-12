import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cotask/custom_widgets/transfer.dart';

class BillDetailPage extends StatefulWidget {
  final Transfer transfer;

  const BillDetailPage({super.key, required this.transfer});

  @override
  _BillDetailPageState createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  late TextEditingController _listNameController;

  @override
  void initState() {
    super.initState();
    _listNameController = TextEditingController(text: widget.transfer.name);
  }

  double _calculateSubtotal() {
    return widget.transfer.bill.fold(0, (sum, item) {
      // Split each item to get the price part, assuming the format "Name - $Price"
      final parts = item.split('-');
      if (parts.length > 1) {
        final priceString = parts[1].trim().replaceAll('\$', '');
        return sum + double.parse(priceString);
      } else {
        return sum;
      }
    });
  }

  double _calculateTotalPrice() {
    double subtotal = _calculateSubtotal();
    return subtotal + (subtotal * 0.1); // Assuming 10% tax rate
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
                  'Receipt Details',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Receipt name: ${widget.transfer.name}',
                  style: const TextStyle(color: Colors.black87, fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),

          // Display list of bill items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.transfer.bill.length,
            itemBuilder: (context, index) {
              final item = widget.transfer.bill[index];
              final parts = item.split('-');
              final itemName = parts[0].trim();
              final itemPrice = parts.length > 1 ? parts[1].trim() : '';

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      itemPrice,
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
                '\$${(_calculateSubtotal() * 0.1).toStringAsFixed(2)}',
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Display selected payer
          Row(
            children: [
              const Text(
                'Payer:',
                style: TextStyle(color: Colors.black87, fontSize: 18),
              ),
              const SizedBox(width: 10),
              Text(
                widget.transfer.payer,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor: const Color(0xFFFA7D8A),
              ),
              child: const Text(
                'CONFIRM',
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
      ),
    );
  }
}
