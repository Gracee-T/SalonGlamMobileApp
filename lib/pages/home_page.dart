import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salon_glam/routes/routes.dart';
import 'package:salon_glam/widgets/custom_app_bar.dart';

// Define a class to represent a service
class Service {
  final String imagePath;
  final String name;
  final String route;

  Service({required this.imagePath, required this.name, required this.route});
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Home',
      bodyContent: _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  Future<List<Service>> fetchServices() async {
    // Fetch services from Firestore
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('categories') // Collection name where services are stored
        .get();

    // Map the retrieved documents to a list of Service objects
    return snapshot.docs.map((doc) {
      return Service(
        imagePath: doc['imageUrl'], // Assuming your document has these fields
        name: doc['name'],
        route: doc['route'],
      );
    }).toList();
  }

  Future<List<String>> fetchRecommendedImages() async {
    // Fetch recommended images from Firestore
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('RecommendedImages') // Collection for recommended images
        .get();

    // Map the retrieved documents to a list of image paths
    return snapshot.docs.map((doc) => doc['imagePath'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Make the page scrollable
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          // Container at the top with rounded borders
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              color: Color.fromARGB(255, 118, 139, 243),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transform Your Look',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'with Salon Glam',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                'Need to select a Service and Product First.'),
                          ));
                          Navigator.of(context)
                              .pushNamed(RouteManager.servicesPage);
                        },
                        style: ElevatedButton.styleFrom(),
                        child: const Text('Book'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          // Categories heading
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16), // Space between heading and categories
          // Categories
          FutureBuilder<List<Service>>(
            future: fetchServices(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final services = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: services.map((service) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(service.route);
                            },
                            child: Container(
                              width: 60, // Decreased image size
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(service.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 50),
          // Recommended for You
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<String>>(
            future: fetchRecommendedImages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final recommendedImages = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.builder(
                        shrinkWrap: true, // To make GridView work in a column
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recommendedImages.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Column of 3 pictures
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8, // Adjust as needed
                        ),
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(recommendedImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
