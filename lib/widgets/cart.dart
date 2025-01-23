import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_glam/models/hairstyle_model.dart';
import 'package:salon_glam/pages/appointment_page.dart';
import 'package:salon_glam/services/selected_service_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedServiceProvider =
        Provider.of<SelectedServiceProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedServiceProvider.cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                      selectedServiceProvider.cartItems[index].imageUrl),
                  title: Text(selectedServiceProvider.cartItems[index].name),
                  subtitle: Text(
                      'R${selectedServiceProvider.cartItems[index].price}'),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            selectedServiceProvider.removeProduct(
                                selectedServiceProvider.cartItems[index]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_checkout),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => BookAppointmentsPages(
                                  selectedService: Hairstyle(
                                      id: selectedServiceProvider
                                          .cartItems[index].id,
                                      name: selectedServiceProvider
                                          .cartItems[index].name,
                                      imagePath: selectedServiceProvider
                                          .cartItems[index].imageUrl,
                                      price: selectedServiceProvider
                                          .cartItems[index]
                                          .price), // Pass the selected service
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${selectedServiceProvider.totalAmount}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
