import 'package:flutter/material.dart';
import '../models/gear_item.dart';

class GearProvider with ChangeNotifier {
  List<GearItem> _items = [];
  bool _isParsing = false;

  List<GearItem> get items => _items;
  bool get isParsing => _isParsing;

  // Mock parsing a PDF
  Future<void> parsePdfAndGenerateList(String fileName) async {
    _isParsing = true;
    notifyListeners();

    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock data that "AI" would extract from a mountaineering PDF
    _items = [
      GearItem(id: '1', name: 'Mountaineering Boots (B3)', category: 'Footwear'),
      GearItem(id: '2', name: 'Crampons (C2/C3)', category: 'Footwear'),
      GearItem(id: '3', name: 'Ice Axe (Technical)', category: 'Technical'),
      GearItem(id: '4', name: 'Harness', category: 'Technical'),
      GearItem(id: '5', name: 'Helmet', category: 'Technical'),
      GearItem(id: '6', name: 'Carabiners (4 Locking)', category: 'Technical'),
      GearItem(id: '7', name: 'Belay Device', category: 'Technical'),
      GearItem(id: '8', name: 'Down Jacket (800 fill)', category: 'Clothing'),
      GearItem(id: '9', name: 'Hardshell Jacket (Gore-Tex)', category: 'Clothing'),
      GearItem(id: '10', name: 'Hardshell Pants', category: 'Clothing'),
      GearItem(id: '11', name: 'Base Layers (Top/Bottom)', category: 'Clothing'),
      GearItem(id: '12', name: 'Glacier Glasses', category: 'Accessories'),
      GearItem(id: '13', name: 'Headlamp + Batteries', category: 'Accessories'),
      GearItem(id: '14', name: 'Backpack (50L+)', category: 'Packs'),
    ];

    _isParsing = false;
    notifyListeners();
  }

  void toggleItemCheck(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isChecked = !_items[index].isChecked;
      notifyListeners();
    }
  }

  // Fixed: Changed assignee type to String? to allow null values
  void assignItem(String id, String? assignee) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].assignedTo = assignee;
      notifyListeners();
    }
  }
  
  void clearList() {
    _items = [];
    notifyListeners();
  }
}
