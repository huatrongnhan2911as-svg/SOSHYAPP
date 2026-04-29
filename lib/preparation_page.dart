import 'package:flutter/material.dart';

class PreparationPage extends StatelessWidget {
  final String name;  // Biến nhận tên món
  final String image; // Biến nhận tên ảnh

  const PreparationPage({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hang is there, we're on it!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // Card hiện món
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Estimated arrival", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 5),
                        const Text("30-49 minutes", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("Món: $name", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  // Hiển thị ảnh
                  Image.asset(
                    "lib/images/$image", 
                    width: 100,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 50),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            const Text("Đang chuẩn bị đơn hàng cho Anh Ba Tàu...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}