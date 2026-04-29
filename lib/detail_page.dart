import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'order_page.dart';
import 'cart_manager.dart'; // 1. PHẢI CÓ DÒNG NÀY ĐỂ DÙNG HÀM LƯU MÓN

class DetailPage extends StatelessWidget {
  final String name;
  final String imagePath;
  final String price;
  final String rating;
  final String idLoai;

  const DetailPage({
    super.key,
    required this.name,
    required this.imagePath,
    required this.price,
    required this.rating,
    required this.idLoai,
  });

  // HÀM LẤY DỮ LIỆU TỪ SERVER XAMPP THEO LOẠI
  Future<List<dynamic>> fetchOtherFoods(String id) async {
    try {
      final response = await http.get(
        Uri.parse('http://172.20.10.4/soshi_api/get_monan_theo_loai.php?id_loai=$id')
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.where((item) => item['TenMon'] != name).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E8),
      body: Stack(
        children: [
          // 1. PHẦN ĐẦU: ẢNH MÓN CHÍNH
          Positioned(
            top: 0, left: 0, right: 0,
            height: 350,
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.orange.shade100,
                child: const Icon(Icons.fastfood, size: 80, color: Colors.orange),
              ),
            ),
          ),

          // 2. NÚT ĐIỀU HƯỚNG
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite_border, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),

          // 3. NỘI DUNG CHI TIẾT
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  children: [
                    // Tên món và Giá
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text("$price VND",
                            style: const TextStyle(fontSize: 18, color: Color(0xFFFF4D2D), fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Rating và Thời gian
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        Text(" $rating", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Text(" (1.2k reviewers)  ", style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const Icon(Icons.access_time, color: Colors.orange, size: 20),
                        const Text(" 25 mins", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    
                    const SizedBox(height: 25),

                    // --- PHẦN MÔ TẢ ---
                    const Text(
                      "Description",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Món ăn này được chế biến từ những nguyên liệu tươi ngon nhất trong ngày. Hương vị đặc trưng của sốt Soshi kết hợp cùng kỹ thuật chế biến điêu luyện sẽ mang lại cho bạn một trải nghiệm ẩm thực Nhật Bản đúng nghĩa. Thưởng thức ngay khi còn nóng để cảm nhận trọn vẹn vị ngon!",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 25),
                    const Text("Popular Sets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),

                    FutureBuilder<List<dynamic>>(
                      future: fetchOtherFoods(idLoai),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFFFF4D2D)));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text("Không có món tương tự cùng loại này", style: TextStyle(color: Colors.grey)),
                          );
                        }

                        final listTuongTu = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                          ),
                          itemCount: listTuongTu.length > 4 ? 4 : listTuongTu.length,
                          itemBuilder: (context, index) {
                            var mon = listTuongTu[index];
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: const Color(0xFFF1F1F1)),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.network(
                                        "http://172.20.10.4/soshi_api/images/${mon['HinhAnh']}",
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.fastfood, color: Colors.orange, size: 40),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    mon['TenMon'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${mon['Gia']} VND",
                                          style: const TextStyle(color: Color(0xFFFF4D2D), fontSize: 11, fontWeight: FontWeight.bold)),
                                      const Icon(Icons.add_circle, color: Color(0xFFFF4D2D), size: 22),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 120), 
                  ],
                ),
              );
            },
          ),

          // 4. THANH TOÁN DƯỚI CÙNG
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$price VND", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text("Total Price", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // --- SỬA TẠI ĐÂY ---
                      // Bước 1: Gọi hàm lưu món vào danh sách Order trước
                      addToCart(name, price, imagePath); 

                      // Bước 2: Chuyển trang sang OrderPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderPage(
                            currentName: name,
                            currentPrice: price,
                            currentImage: imagePath,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4D2D),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      "Go to orders", 
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}