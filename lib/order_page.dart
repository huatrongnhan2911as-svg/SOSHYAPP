import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'checkout_page.dart'; 
import 'cart_manager.dart'; // File này chứa biến cartCount và tempCart

class OrderPage extends StatefulWidget {
  final String? currentName;
  final String? currentPrice;
  final String? currentImage;

  const OrderPage({
    super.key, 
    this.currentName, 
    this.currentPrice, 
    this.currentImage
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  
  // Hàm lấy lịch sử đơn hàng từ database
  Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse('http://172.20.10.4/soshi_api/get_orders.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      debugPrint("Lỗi kết nối: $e");
      return [];
    }
  }

  // Tính tổng tiền
  double getTotalPrice() {
    double total = 0;
    for (var item in tempCart) {
      total += (double.tryParse(item['price'].toString()) ?? 0) * item['quantity'];
    }
    return total;
  }

  // Cập nhật số lượng
  void updateQuantity(int index, int change) {
    tempCart[index]['quantity'] += change;
    if (tempCart[index]['quantity'] <= 0) {
      tempCart.removeAt(index);
    }
    // Kích hoạt thông báo thay đổi để UI tự vẽ lại
    _notifyCartChanged();
  }

  // Xoá món
  void removeItem(int index) {
    tempCart.removeAt(index);
    _notifyCartChanged();
  }

  // Hàm thông báo cho toàn app là giỏ hàng đã đổi
  void _notifyCartChanged() {
    int totalItems = 0;
    for (var item in tempCart) {
      totalItems += item['quantity'] as int;
    }
    cartCount.value = totalItems; // Khi cartCount đổi, ValueListenableBuilder sẽ chạy
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, 
        title: const Text("My Orders", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () async { setState(() {}); },
        child: ValueListenableBuilder<int>(
          valueListenable: cartCount,
          builder: (context, value, child) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  
                  if (tempCart.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text("Giỏ hàng trống rồi, Anh Ba Tàu ơi!"),
                    ))
                  else
                    _buildCartListCard(context),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Text("Order History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  FutureBuilder<List<dynamic>>(
                    future: fetchOrders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFFFF4D2D)));
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) => _buildOrderedItem(snapshot.data![index]),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildCartListCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tempCart.length,
            separatorBuilder: (context, index) => const Divider(height: 25),
            itemBuilder: (context, index) {
              final item = tempCart[index];
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(item['image'], width: 60, height: 60, fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(Icons.fastfood)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            GestureDetector(onTap: () => updateQuantity(index, -1), child: _buildActionBtn(Icons.remove)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text("${item['quantity']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            GestureDetector(onTap: () => updateQuantity(index, 1), child: _buildActionBtn(Icons.add)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        onPressed: () => removeItem(index),
                      ),
                      Text("${item['price']} VND", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ],
              );
            },
          ),
          const Divider(height: 30, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Pay", style: TextStyle(color: Colors.grey)),
              Text("${getTotalPrice()} VND", 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFFF4D2D))),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D2D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                // CHỖ NÀY ĐÃ SỬA: KHÔNG TRUYỀN THAM SỐ NỮA ĐỂ HẾT LỖI ĐỎ
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const CheckoutPage(), 
                ));
              },
              child: const Text("Place Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(5)),
      child: Icon(icon, size: 16, color: Colors.black),
    );
  }

  Widget _buildOrderedItem(dynamic order) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network("http://172.20.10.4/soshi_api/images/${order['HinhAnh'] ?? ''}", 
              width: 60, height: 60, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => const Icon(Icons.restaurant, color: Colors.orange)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order['TenMon'] ?? "Sushi Bento", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Delivery . ${order['DiaChi'] ?? 'Bình Dương'}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                Text(order['TrangThai'] ?? "Arriving", style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}