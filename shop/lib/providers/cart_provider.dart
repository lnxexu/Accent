// FILE: shop/lib/providers/cart_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  void addItem(Map<String, dynamic> item) {
    state = [...state, item];
  }

  void toggleItemSelection(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          {
            ...state[i],
            'selected': !state[i]['selected'],
          }
        else
          state[i],
    ];
  }

  void removeSelectedItems() {
    state = state.where((item) => item['selected'] != true).toList();
  }

  void clearCart() {
    state = [];
  }
}
