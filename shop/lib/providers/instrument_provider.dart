import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/instrument.dart';
import '../data/sample_instruments.dart';

final instrumentProvider =
    ChangeNotifierProvider((ref) => InstrumentNotifier());

class InstrumentNotifier extends ChangeNotifier {
  final List<Instrument> _instruments = sampleInstruments;

  List<Instrument> get instruments => _instruments;

  List<Instrument> getInstrumentsByCategory(InstrumentCategory category) {
    return _instruments
        .where((instrument) => instrument.category == category)
        .toList();
  }

  Instrument? getInstrumentById(String id) {
    try {
      return _instruments.firstWhere((instrument) => instrument.id == id);
    } catch (e) {
      return null;
    }
  }

  void addInstrument(Instrument instrument) {
    _instruments.add(instrument);
    notifyListeners();
  }

  void updateStock(String id, int newQuantity) {
    final index = _instruments.indexWhere((instrument) => instrument.id == id);
    if (index != -1) {
      _instruments[index].stockQuantity = newQuantity;
      notifyListeners();
    }
  }

  void removeInstrument(String id) {
    _instruments.removeWhere((instrument) => instrument.id == id);
    notifyListeners();
  }

  void purchaseInstrument(String id) {
    final instrument = getInstrumentById(id);
    if (instrument != null) {
      final newQuantity = instrument.stockQuantity - 1;
      updateStock(id, newQuantity);
    }
  }
}
