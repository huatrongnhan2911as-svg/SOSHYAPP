import 'package:flutter/material.dart';
import 'cart_manager.dart'; // Đảm bảo file này chứa tempCart và cartCount
import 'payment_page.dart'; // File này phải có tham số totalFromOrder

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  
  // Tính tiền hàng (Subtotal)
  double getSubtotal() {
    double total = 0;
    for (var item in tempCart) {
      total += (double.tryParse(item['price'].toString()) ?? 0) * item['quantity'];
    }
    return total;
  }

  // Tăng/Giảm số lượng món
  void updateQuantity(int index, int change) {
    setState(() {
      tempCart[index]['quantity'] += change;
      if (tempCart[index]['quantity'] <= 0) {
        tempCart.removeAt(index);
      }
      _syncGlobalCart();
    });
  }

  // Xoá món khỏi giỏ
  void removeItem(int index) {
    setState(() {
      tempCart.removeAt(index);
      _syncGlobalCart();
    });
  }

  // Đồng bộ số lượng ra ngoài icon giỏ hàng
  void _syncGlobalCart() {
    int total = 0;
    for (var item in tempCart) {
      total += item['quantity'] as int;
    }
    cartCount.value = total;
  }

  @override
  Widget build(BuildContext context) {
    double subtotal = getSubtotal();
    double deliveryFee = tempCart.isEmpty ? 0 : 15000;
    double discount = tempCart.isEmpty ? 0 : 5000;
    double totalPay = subtotal + deliveryFee - discount; // Đây là biến tổng cuối cùng

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Checkout", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            if (tempCart.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Text("Giỏ hàng trống rồi Anh Ba Tàu ơi!"),
              ))
            else
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tempCart.length,
                  separatorBuilder: (context, index) => const Divider(height: 30),
                  itemBuilder: (context, index) {
                    final item = tempCart[index];
                    return Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['image'], width: 65, height: 65, fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.fastfood, size: 40),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  _buildQtyBtn(Icons.remove, () => updateQuantity(index, -1)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text("${item['quantity']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  _buildQtyBtn(Icons.add, () => updateQuantity(index, 1)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                              onPressed: () => removeItem(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(height: 10),
                            Text("${item['price']} VND", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 25),
            _buildOptionTile(Icons.location_on_outlined, "Delivery to: Lái Thiêu, Thuận An"),
            const SizedBox(height: 10),
            _buildOptionTile(Icons.confirmation_number_outlined, "20% OFF Applied", isPromo: true),
            const SizedBox(height: 30),
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriceRow("Subtotal", "${subtotal.toInt()} VND"),
            _buildPriceRow("Delivery Fee", "${deliveryFee.toInt()} VND"),
            _buildPriceRow("Discount", "-${discount.toInt()} VND"),
            const Divider(height: 20),
            _buildPriceRow("Total Pay", "${totalPay.toInt()} VND", isTotal: true),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D2D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: tempCart.isEmpty ? null : () {
                  // ĐÃ SỬA: Truyền biến totalPay sang trang PaymentPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(totalFromOrder: totalPay),
                    ),
                  );
                },
                child: const Text("Confirm Order", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String text, {bool isPromo = false}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          Icon(icon, color: isPromo ? Colors.green : Colors.orange),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: TextStyle(color: isPromo ? Colors.green : Colors.black))),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isTotal ? Colors.black : Colors.grey, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 16 : 14)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTotal ? 18 : 14, color: isTotal ? const Color(0xFFFF4D2D) : Colors.black)),
      ],
    );
  }
}