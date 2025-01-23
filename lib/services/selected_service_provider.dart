import 'package:flutter/material.dart';
import 'package:salon_glam/models/product_model.dart';

class SelectedServiceProvider with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addProduct(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  double get totalAmount {
    return _cartItems.fold(0.0, (total, item) => total + item.price);
  }
}
