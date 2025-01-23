import 'package:flutter/material.dart'; // Import the BookAppointmentPage
import 'package:provider/provider.dart';
import 'package:salon_glam/models/hairstyle_model.dart';
import 'package:salon_glam/models/product_model.dart';
import 'package:salon_glam/pages/appointment_page.dart'; // Make sure to import the BookAppointmentsPages
import 'package:salon_glam/services/selected_service_provider.dart';
import 'package:salon_glam/widgets/custom_app_bar.dart'; // Replace with your custom app bar if needed
// Ensure to import your Hairstyle model

class ProductDetailsPage extends StatefulWidget {
  final String serviceName;
  final double price;
  final String imagePath;
  final String id;

  const ProductDetailsPage({
    super.key,
    required this.serviceName,
    required this.price,
    required this.imagePath,
    required this.id, // Add this line
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: widget.serviceName,
      bodyContent: _ProductDetailsBody(
        serviceName: widget.serviceName,
        price: widget.price,
        imagePath: widget.imagePath,
        id: widget.id,
      ),
    );
  }
}

class _ProductDetailsBody extends StatelessWidget {
  final String serviceName;
  final double price;
  final String imagePath;
  final String id;

  const _ProductDetailsBody({
    required this.serviceName,
    required this.price,
    required this.imagePath,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rounded square container for the product
          Container(
            width: 200.0,
            height: 200.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Service name and price
          Text(
            serviceName,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            'R${price.toStringAsFixed(2)}', // Format price to 2 decimal places
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 50, 53, 233), // Price color
            ),
          ),
          const SizedBox(height: 40.0),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Add Button
              ElevatedButton(
                onPressed: () {
                  // Implement adding the item to the selected services list
                  Provider.of<SelectedServiceProvider>(context, listen: false)
                      .addProduct(
                    Product(
                      name: serviceName,
                      price: price,
                      imageUrl: imagePath,
                      id: id, // Pass the id here
                    ),
                  );
                  // Return to the services page
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
              // Book Button
              ElevatedButton(
                onPressed: () {
                  if (Provider.of<SelectedServiceProvider>(context,
                          listen: false)
                      .cartItems
                      .isEmpty) {
                    // Create an instance of Hairstyle
                    Hairstyle selectedHairstyle = Hairstyle(
                      name: serviceName,
                      price: price,
                      imagePath: imagePath,
                      id: id, // Pass the id here
                    );

                    // Pass the selected service details to BookAppointmentsPages
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookAppointmentsPages(
                          selectedService:
                              selectedHairstyle, // Pass the selected service
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'There is already a list of items selected. Open cart to handle them.'),
                    ));
                  }
                },
                child: const Text('Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
