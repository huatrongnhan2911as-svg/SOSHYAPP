import 'package:flutter/material.dart';

// Biến toàn cục
List<Map<String, dynamic>> tempCart = []; 
ValueNotifier<int> cartCount = ValueNotifier(0);

void addToCart(String name, String price, String image) {
  int index = tempCart.indexWhere((item) => item['name'] == name);

  if (index != -1) {
    tempCart[index]['quantity'] += 1;
  } else {
    tempCart.add({
      'name': name,
      'price': price,
      'image': image,
      'quantity': 1,
    });
  }

  // Cập nhật tổng số lượng để Badge ở BottomNav nhảy số
  int total = 0;
  for (var item in tempCart) {
    total += item['quantity'] as int;
  }
  cartCount.value = total;
}