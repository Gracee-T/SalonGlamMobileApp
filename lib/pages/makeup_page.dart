import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:salon_glam/models/makeup_model.dart';
import 'package:salon_glam/pages/product_details_page.dart';
import 'package:salon_glam/widgets/custom_app_bar.dart';

class MakeupPage extends StatelessWidget {
  const MakeupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'MakeUp', // Title for the app bar
      bodyContent: _MakeUpBody(), // Body content as a separate widget
    );
  }
}

class _MakeUpBody extends StatelessWidget {
  const _MakeUpBody();

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
                'MakeUp',
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
                  .collection('makeUpPage')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No hairstyles available.'));
                }

                final makeups = snapshot.data!.docs
                    .map((doc) => MakeUp.fromFirestore(
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
                  itemCount: makeups.length,
                  itemBuilder: (context, index) {
                    final makeup = makeups[index];
                    return _buildServiceItem(context, makeup);
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
  Widget _buildServiceItem(BuildContext context, MakeUp makeup) {
    return GestureDetector(
      onTap: () {
        //Navigate to service details page with the service name and price
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              serviceName: makeup.name,
              price: makeup.price,
              id: makeup.id,
              imagePath:
                  makeup.imagePath, // Pass the image path to the details page
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
                    NetworkImage(makeup.imagePath), // Load image from network
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 1.0),
          // Service name
          Text(
            makeup.name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 1.0), // Space between name and price
          // Service price
          Text(
            '\$${makeup.price.toStringAsFixed(2)}', // Format price to 2 decimal places
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
