import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:salon_glam/models/haircut_model.dart'; // Import the hairstyle model
import 'package:salon_glam/pages/product_details_page.dart';
import 'package:salon_glam/widgets/custom_app_bar.dart';

class HaircutPage extends StatelessWidget {
  const HaircutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Haircut', // Title for the app bar
      bodyContent: _HaircutBody(), // Body content as a separate widget
    );
  }
}

class _HaircutBody extends StatelessWidget {
  const _HaircutBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Added scroll functionality
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Centered Heading
            const Center(
              child: Text(
                'Haircut',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            // Firestore stream builder to get the list of hairstyles
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('haircutPage')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Haircuts available.'));
                }

                final haircuts = snapshot.data!.docs
                    .map((doc) => Haircut.fromFirestore(
                        doc.data() as Map<String, dynamic>, doc.id))
                    .toList();

                return GridView.builder(
                  shrinkWrap:
                      true, // Allow the grid to take only the space it needs
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 3 columns
                    crossAxisSpacing: 20.0, // Space between columns
                    mainAxisSpacing: 50.0, // Space between rows
                  ),
                  itemCount: haircuts.length,
                  itemBuilder: (context, index) {
                    final haircut = haircuts[index];
                    return _buildServiceItem(context, haircut);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to build a service item with click functionality
  Widget _buildServiceItem(BuildContext context, Haircut haircut) {
    return GestureDetector(
      onTap: () {
        //Navigate to service details page with the service name and price
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              serviceName: haircut.name,
              price: haircut.price,
              id: haircut.id,
              imagePath:
                  haircut.imagePath, // Pass the image path to the details page
            ),
          ),
        );
      },
      child: Column(
        children: [
          // Rounded square image
          Container(
            width: 90.0,
            height: 90.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image:
                    NetworkImage(haircut.imagePath), // Load image from network
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 1.0),
          // Service name
          Text(
            haircut.name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 1.0), // Space between name and price
          // Service price
          Text(
            'R${haircut.price.toStringAsFixed(2)}', // Format price to 2 decimal places
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 50, 53, 233), // Color for the price
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
