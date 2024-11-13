import 'package:flutter/material.dart';
import 'package:cotask/custom_widgets/transfer.dart'; // 替换为实际的 Transfer 类路径

class TransferProvider with ChangeNotifier {
  // 定义 transferLists 字段
  List<Transfer> transferLists = [
    Transfer(
      id: 1, // Ensure every Transfer has a unique id
      name: 'Walmart Shopping',
      price: 7.32, // Total amount including tax
      ownerName: 'Me',
      status: TransferStatus.uncompleted, // Set initial status here
      bill: [
        'Apple - \$1.50',
        'Milk - \$2.30',
        'Bread - \$2.00',
        'Eggs - \$3.00',
        'Juice - \$4.50'
      ],
      payer: 'Lucas', // Example payer
    ),
    // Add more Transfer instances if needed
  ];

  // 添加一个 transfer 到列表中
  void addTransfer(Transfer transfer) {
    transferLists.add(transfer);

    notifyListeners();
  }

  // 从列表中删除一个 transfer
  void removeTransfer(Transfer transfer) {
    transferLists.remove(transfer);
    notifyListeners();
  }

  // 更新 transfer 信息
  void updateTransfer(Transfer updatedTransfer) {
    final index = transferLists.indexWhere((t) => t.id == updatedTransfer.id);
    if (index != -1) {
      transferLists[index] = updatedTransfer;
      notifyListeners();
    }
  }
}
