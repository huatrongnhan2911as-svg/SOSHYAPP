import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'detail_page.dart';
import 'cart_manager.dart'; // Quản lý giỏ hàng
import 'main.dart';         // Lấy cartKey cho hiệu ứng bay

class MenuPage extends StatefulWidget {
  final String initialCategoryName; 

  const MenuPage({super.key, required this.initialCategoryName});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late String selectedCategoryName;
  // Nhớ kiểm tra IP này có trùng với máy chạy XAMPP của ông không nhé
  final String baseUrl = "http://172.20.10.4/soshi_api"; 

  @override
  void initState() {
    super.initState();
    selectedCategoryName = widget.initialCategoryName;
  }

  // --- HÀM HIỆU ỨNG BAY (ĐỒNG BỘ VỚI HOME) ---
  void _runFlyAnimation(GlobalKey widgetKey, String imageUrl) async {
    RenderBox? box = widgetKey.currentContext?.findRenderObject() as RenderBox?;
    RenderBox? cartBox = cartKey.currentContext?.findRenderObject() as RenderBox?;

    if (box == null || cartBox == null) return;

    Offset startPosition = box.localToGlobal(Offset.zero);
    Offset endPosition = cartBox.localToGlobal(Offset.zero);

    OverlayEntry entry = OverlayEntry(
      builder: (context) => TweenAnimationBuilder<Offset>(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutBack,
        tween: Tween<Offset>(begin: startPosition, end: endPosition),
        builder: (context, value, child) {
          return Positioned(
            left: value.dx,
            top: value.dy,
            child: child!,
          );
        },
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);
    await Future.delayed(const Duration(milliseconds: 800));
    entry.remove();
  }

  // --- FETCH DỮ LIỆU ---
  Future<List<dynamic>> fetchFoodsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_monan.php')); 
      if (response.statusCode == 200) {
        List<dynamic> allFoods = json.decode(response.body);
        return allFoods.where((food) {
          String targetId = "";
          if (category == "Nigiri") targetId = "1";
          else if (category == "Sashimi") targetId = "2";
          else if (category == "Bento") targetId = "3";
          else if (category == "Maki") targetId = "4";
          else if (category == "Temaki") targetId = "5";
          return food['id_loai'].toString() == targetId;
        }).toList();
      } else {
        throw Exception('Lỗi kết nối Server');
      }
    } catch (e) {
      throw Exception('Lỗi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, 
        title: const Text("Menu", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // THANH CHỌN CATEGORY
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: ["Nigiri", "Sashimi", "Maki", "Bento", "Temaki"]
                    .map((name) => _buildCategoryChip(name))
                    .toList(),
              ),
            ),
          ),
          
          // DANH SÁCH MÓN ĂN
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchFoodsByCategory(selectedCategoryName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF4D2D)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Không tìm thấy món ăn"));
                }
                final foods = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, 
                    crossAxisSpacing: 15, 
                    mainAxisSpacing: 15, 
                    childAspectRatio: 0.65, // Tỉ lệ giống Home Page
                  ),
                  itemCount: foods.length,
                  itemBuilder: (context, index) => _buildDishCard(foods[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = selectedCategoryName == label;
    return GestureDetector(
      onTap: () => setState(() => selectedCategoryName = label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF4D2D) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected 
              ? [BoxShadow(color: const Color(0xFFFF4D2D).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] 
              : null,
          border: isSelected ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
          )
        ),
      ),
    );
  }

  Widget _buildDishCard(dynamic food) {
    String imageUrl = "$baseUrl/images/${food['HinhAnh']}";
    final GlobalKey imageKey = GlobalKey(); 

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(
          name: food['TenMon'] ?? "No Name", 
          price: food['Gia'].toString(), 
          imagePath: imageUrl,
          rating: "4.8",
          idLoai: food['id_loai'].toString(),
        )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ẢNH MÓN ĂN
            Expanded(
              flex: 5,
              child: ClipRRect(
                key: imageKey, 
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)), 
                child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity,
                  errorBuilder: (c, e, s) => const Icon(Icons.fastfood, color: Colors.grey)),
              ),
            ),
            
            // THÔNG TIN VÀ NÚT BẤM (HÌNH TRÒN ĐỒNG BỘ)
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    // CỘT BÊN TRÁI: TÊN + SAO + GIÁ
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            food['TenMon'] ?? "Unknown", 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), 
                            maxLines: 1, overflow: TextOverflow.ellipsis
                          ),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.orange, size: 12),
                              SizedBox(width: 2),
                              Text("4.8", style: TextStyle(fontSize: 10, color: Colors.grey)),
                              SizedBox(width: 8),
                              Icon(Icons.access_time, color: Colors.grey, size: 12),
                              SizedBox(width: 2),
                              Text("25m", style: TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          Text(
                            "${food['Gia']} VND", 
                            style: const TextStyle(color: Color(0xFFFF4D2D), fontWeight: FontWeight.bold, fontSize: 12)
                          ),
                        ],
                      ),
                    ),
                    // CỘT BÊN PHẢI: TIM + NÚT CỘNG TRÒN
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.favorite_border, color: Colors.red, size: 20),
                        GestureDetector(
                          onTap: () {
                            _runFlyAnimation(imageKey, imageUrl);
                            addToCart(food['TenMon'] ?? "Sushi", food['Gia'].toString(), imageUrl);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF4D2D), 
                              shape: BoxShape.circle, // HÌNH TRÒN CHUẨN ĐỒNG BỘ
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}