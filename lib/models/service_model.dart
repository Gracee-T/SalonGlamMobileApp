import 'package:cloud_firestore/cloud_firestore.dart';

// Category Model
class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  // Method to create a Category object from Firestore snapshot
  factory Category.fromDocument(DocumentSnapshot doc) {
    return Category(
      id: doc.id,
      name: doc['name'],
      image: doc['image'],
    );
  }
}

// Service Model
class Service {
  final String id;
  final String name;
  final String image;
  final double price;

  Service(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});

  // Method to create a Service object from Firestore snapshot
  factory Service.fromDocument(DocumentSnapshot doc) {
    return Service(
      id: doc.id,
      name: doc['name'],
      image: doc['image'],
      price: doc['price'],
    );
  }
}

// Method to retrieve all categories from Firestore
Future<List<Category>> getCategories() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('categories').get();
  return snapshot.docs.map((doc) => Category.fromDocument(doc)).toList();
}

// Method to retrieve services based on a categoryId
Future<List<Service>> getServices(String categoryId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('categories')
      .where('categoryId', isEqualTo: categoryId)
      .get();
  return snapshot.docs.map((doc) => Service.fromDocument(doc)).toList();
}
