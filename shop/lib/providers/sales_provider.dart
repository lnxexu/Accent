import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/sale.dart';

final salesProvider = ChangeNotifierProvider((ref) => SalesNotifier());

class SalesNotifier extends ChangeNotifier {
  final List<Sale> _sales = [];

  List<Sale> get sales => _sales;

  void addSale(Sale sale) {
    _sales.add(sale);
    notifyListeners();
  }

  double getTotalSales() {
    return _sales.fold(0, (sum, sale) => sum + sale.totalPrice);
  }

  List<Sale> getSalesByDate(DateTime date) {
    return _sales
        .where((sale) =>
            sale.dateTime.year == date.year &&
            sale.dateTime.month == date.month &&
            sale.dateTime.day == date.day)
        .toList();
  }

  List<Sale> getSalesByInstrument(String instrumentId) {
    return _sales.where((sale) => sale.instrumentId == instrumentId).toList();
  }
}
