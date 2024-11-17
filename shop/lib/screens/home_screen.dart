import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/instrument_provider.dart';
import 'instrument_detail_screen.dart';
import 'cart.dart'; // Import the cart screen

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the instrument provider to get the list of instruments
    final instruments = ref.watch(instrumentProvider).instruments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop', style: TextStyle(fontFamily: 'IntegralCF')),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            //pop all the screens and navigate to the login screen
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
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
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.65, // Aspect ratio of each grid item
        ),
        itemCount: instruments.length, // Number of items in the grid
        itemBuilder: (context, index) {
          final instrument = instruments[index]; // Get the instrument

          return GestureDetector(
            onTap: () {
              // Navigate to the InstrumentDetailScreen when tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      InstrumentDetailScreen(instrument: instrument),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
              elevation: 6, // Shadow effect
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.asset(
                        instrument.imageUrl, // Load image from asset
                        fit: BoxFit.cover, // Cover the entire container
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instrument.name, // Display instrument name
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2, // Limit to 2 lines
                          overflow: TextOverflow
                              .ellipsis, // Handle overflow with ellipsis
                        ),
                        const SizedBox(height: 6),
                        Text(
                          instrument.brand, // Display instrument brand
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${instrument.price.toString()}', // Display instrument price
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
