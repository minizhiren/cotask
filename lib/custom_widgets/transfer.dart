import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cotask/bill_detail_page.dart';

enum TransferStatus { uncompleted, pending, readyToComplete, completed }

class Transfer {
  final int id;
  final String name;
  final String ownerName;
  final TransferStatus status;
  final List<String> bill;
  final String payer;
  final double price;

  Transfer({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.status,
    required this.bill,
    required this.payer,
    required this.price,
  });

  // Method to create a copy with updated values
  Transfer copyWith({
    int? id,
    String? name,
    String? listName,
    TransferStatus? status,
    List<String>? bill,
    String? payer,
    double? price,
  }) {
    return Transfer(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerName: listName ?? this.ownerName,
      status: status ?? this.status,
      bill: bill ?? this.bill,
      payer: payer ?? this.payer,
      price: price ?? this.price,
    );
  }
}

class TransferContainer extends StatelessWidget {
  final Transfer transfer;
  final VoidCallback onCompleted;

  const TransferContainer({
    super.key,
    required this.transfer,
    required this.onCompleted,
  });

  void _showPendingConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation",textAlign: TextAlign.center,),
          backgroundColor: Colors.white,
          
          content: const Text(
          "Do you want to proceed with this pending transfer?",
          textAlign: TextAlign.center,
        ),
              
              
          actions: [
            TextButton(
              // child: const Text("Cancel"),
              child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.red[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
              child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 1,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
              onPressed: () {
                Navigator.of(context).pop();
                onCompleted();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // Define icon and color based on the transfer status
    String iconPath;
    Color iconColor;

    switch (transfer.status) {
      case TransferStatus.uncompleted:
        iconPath = 'assets/send.svg';
        iconColor = Color.fromARGB(255, 115, 202, 115); // Green for uncompleted
        break;
      case TransferStatus.readyToComplete:
        iconPath = 'assets/check_circle.svg';
        iconColor = Color.fromARGB(255, 115, 202, 115); // Green for ready
        break;
      case TransferStatus.pending:
        iconPath = 'assets/pending.svg';
        iconColor = Colors.orange; // Orange for pending
        break;
      case TransferStatus.completed:
        iconPath = 'assets/completed.svg';
        iconColor = Colors.grey; // Grey for completed
        break;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: SvgPicture.asset('assets/money_tag.svg'),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transfer.name,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      decoration: transfer.status == TransferStatus.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Transfer \$${transfer.price.toStringAsFixed(2)} to ${transfer.payer}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: transfer.ownerName != 'Unassigned'
                ? GestureDetector(
                    onTap: () {
                      if (transfer.status == TransferStatus.pending) {
                        _showPendingConfirmationDialog(context);
                      } else {
                        onCompleted(); // Directly mark as complete if not pending
                      }
                    },
                    child: SvgPicture.asset(
                      iconPath,
                      color: iconColor,
                    ),
                  )
                : SizedBox.shrink(),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BillDetailPage(transfer: transfer),
                ),
              );
            },
            child: SvgPicture.asset('assets/view_detail.svg'),
          ),
        ],
      ),
    );
  }
}
