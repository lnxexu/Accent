import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:share/share.dart'; // Import the share package
import '/models/instrument.dart';
import '/models/sale.dart';
import '/providers/instrument_provider.dart';
import '/providers/sales_provider.dart';
import 'full_screen.dart'; // Import the new screen
import 'cart.dart';
import '/providers/cart_provider.dart'; // Import the cart provider

class InstrumentDetailScreen extends ConsumerWidget {
  final Instrument instrument;

  const InstrumentDetailScreen({
    Key? key,
    required this.instrument,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
              final shareText =
                  'Check out this instrument: ${instrument.name} for \$${instrument.price.toStringAsFixed(2)}';
              // Share.share(shareText); // Uncomment this line after adding the share package
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the cart screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(), // Implement CartScreen
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the instrument image
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      imageUrl: instrument.imageUrl,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15), // Rounded corners
                child: Image.asset(
                  instrument.imageUrl, // Use AssetImage if it's in assets
                  fit: BoxFit
                      .contain, // Ensure the image fits within the container
                  height: 200, // Set a height for better layout
                  width: double.infinity, // Full width
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              instrument.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${instrument.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            if (instrument.category == InstrumentCategory.string) ...[
              Text(
                'Select Color:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildColorOption(Colors.red),
                  _buildColorOption(const Color.fromARGB(255, 255, 255, 255)),
                  _buildColorOption(Colors.black),
                ],
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              instrument.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Stock Quantity: ${instrument.stockQuantity}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: instrument.stockQuantity > 0
                  ? () => _showSaleDialog(context, ref)
                  : null,
              child: const Text('Buy Now'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: instrument.stockQuantity > 0
                  ? () => _addToCart(context, ref)
                  : null,
              child: const Text('Add to Cart'),
            ),

            const Divider(),
            Text(
              'Customer Reviews',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildReview('John Doe', 'Great instrument, highly recommend!', 5),
            _buildReview('Jane Smith', 'Good quality, but a bit expensive.', 4),
            _buildReview(
                'Alice Johnson', 'Not satisfied with the sound quality.', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        // Handle color selection
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildReview(String name, String review, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(review),
        ],
      ),
    );
  }

  void _showSaleDialog(BuildContext context, WidgetRef ref) {
    final quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make Sale'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Text('Available: ${instrument.stockQuantity}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text) ?? 0;
              if (quantity > 0 && quantity <= instrument.stockQuantity) {
                final sale = Sale(
                  id: DateTime.now().toString(),
                  instrumentId: instrument.id,
                  quantity: quantity,
                  totalPrice: instrument.price * quantity,
                  dateTime: DateTime.now(),
                );

                ref.read(salesProvider.notifier).addSale(sale);
                ref.read(instrumentProvider.notifier).updateStock(
                    instrument.id, instrument.stockQuantity - quantity);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sale completed successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid quantity')),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext context, WidgetRef ref) {
    ref.read(cartProvider.notifier).addItem({
      'name': instrument.name,
      'price': instrument.price,
      'selected': false,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  }
}
