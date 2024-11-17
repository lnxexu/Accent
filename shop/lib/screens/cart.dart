import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/cart_provider.dart';
import 'delivery_receipt.dart';

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    double total = cartItems
        .where((item) => item['selected'] == true)
        .fold(0.0, (sum, item) => sum + item['price']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Checkbox(
                    value: item['selected'] ?? false,
                    onChanged: (bool? value) {
                      cartNotifier.toggleItemSelection(index);
                    },
                  ),
                  title: Text(item['name']),
                  subtitle: Text('\$${item['price']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: total > 0
                      ? () {
                          cartNotifier.removeSelectedItems();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DeliveryReceiptScreen(total: total),
                            ),
                            (Route<dynamic> route) => route.isFirst,
                          );
                        }
                      : null,
                  child: Text('Buy Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
