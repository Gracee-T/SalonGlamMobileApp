import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_glam/widgets/custom_app_bar.dart';

class Service {
  final String name;
  final String imageUrl;
  final String route;

  Service({required this.name, required this.imageUrl, required this.route});
}

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  Future<List<Service>> fetchServices() async {
    // Fetch services from Firestore 'categories' collection
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('categories') // Collection name
        .get();

    // Map the documents to a list of Service objects
    return snapshot.docs.map((doc) {
      return Service(
        name: doc['name'], // Field for category name
        imageUrl: doc['imageUrl'], // Field for image URL
        route: doc['route'], // Field for navigation route
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Services',
      bodyContent: _ServicesBody(),
    );
  }
}

class _ServicesBody extends StatelessWidget {
  const _ServicesBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Align children to the center
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Services', // Heading for the Services section
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none, // No underline here
                  ),
                ),
                SizedBox(height: 2), // Space between heading and underline
                Text(
                  '____________________', // Underline representation
                  style: TextStyle(
                    fontSize: 18,
                    decoration:
                        TextDecoration.underline, // Underline the heading
                    decorationThickness: 2, // Thickness of the underline
                    decorationColor: Colors.black, // Color of the underline
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Service>>(
            future: fetchServices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No services available'));
              } else {
                final services = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable scrolling for the GridView
                  shrinkWrap: true, // Use only the space it needs
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Display 2 services per row
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the specified route when tapped
                        Navigator.of(context).pushNamed(service.route);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(service
                                      .imageUrl), // Load image from Firestore URL
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.name, // Display the category name
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<Service>> fetchServices() async {
    // Fetch categories from Firestore
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('categories') // Firestore collection
        .get();

    // Map Firestore documents to Service objects
    return snapshot.docs.map((doc) {
      return Service(
        name: doc['name'],
        imageUrl: doc['imageUrl'],
        route: doc['route'],
      );
    }).toList();
  }
}
