class Haircut {
  final String id; // Add ID for Firestore document
  final String name;
  final String imagePath;
  final double price;

  Haircut({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
  });

  // Factory method to create a Hairstyle object from Firestore data
  factory Haircut.fromFirestore(Map<String, dynamic> data, String id) {
    return Haircut(
      id: id,
      name: data['name'] as String? ??
          'Unnamed Hairstyle', // Default value if null
      price:
          (data['price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if null
      imagePath: data['imageUrl'] as String? ??
          'https://firebasestorage.googleapis.com/v0/b/glam-478d7.appspot.com/o/IMG-20240928-WA0022.jpg?alt=media', // Default image path if null
    );
  }
}
