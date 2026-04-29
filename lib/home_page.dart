import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb; 
import 'menu_page.dart'; 
import 'detail_page.dart';
import 'cart_manager.dart'; 
import 'main.dart'; 

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost/soshi_api';
    return 'http://172.20.10.4/soshi_api'; 
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- BIẾN QUẢN LÝ TÌM KIẾM ---
  List<dynamic> allFoods = []; // Danh sách gốc từ Server
  List<dynamic> filteredFoods = []; // Danh sách sau khi tìm kiếm
  String searchQuery = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Tải dữ liệu lần đầu
  Future<void> _loadInitialData() async {
    try {
      final data = await fetchFoods();
      setState(() {
        allFoods = data;
        filteredFoods = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // Hàm lọc món ăn theo tên
  void _filterSearch(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredFoods = allFoods;
      } else {
        filteredFoods = allFoods
            .where((food) => food['TenMon']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

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

  Future<List<dynamic>> fetchFoods() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/get_monan.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Không thể tải món ăn');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER & SEARCH BAR ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFFFF4D2D)),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Deliver now", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("Lái Thiêu, Bình Dương", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.notifications_none_outlined),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // THANH TÌM KIẾM ĐÃ CẬP NHẬT
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white, 
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                      ),
                      child: TextField(
                        onChanged: (value) => _filterSearch(value), // LỌC KHI GÕ
                        decoration: const InputDecoration(
                          hintText: "Search sushi, rolls, sashimi...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- BANNER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(colors: [Color(0xFFFF4D2D), Color(0xFFFF835D)]),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Get Special Discount", style: TextStyle(color: Colors.white, fontSize: 14)),
                        Text("Up to 50% OFF", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),

              // --- CATEGORIES ---
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
                child: Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double itemWidth = (constraints.maxWidth) / 5;
                    return Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        _buildCategoryItem(context, "Nigiri", "nigiri1.jpg", itemWidth), 
                        _buildCategoryItem(context, "Sashimi", "sashimi2.png", itemWidth),
                        _buildCategoryItem(context, "Bento", "bento1.jpg", itemWidth),
                        _buildCategoryItem(context, "Maki", "maki1.jpg", itemWidth),
                        _buildCategoryItem(context, "Temaki", "temaki2.jpg", itemWidth),
                      ],
                    );
                  }
                ),
              ),

              // --- EXPLORE LIST ---
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 25, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Explore Sushi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("See All", style: TextStyle(color: Color(0xFFFF4D2D), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF4D2D)))
                  : filteredFoods.isEmpty 
                    ? const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("No sushi found! 🍣"),
                      ))
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, 
                          crossAxisSpacing: 15, 
                          mainAxisSpacing: 15, 
                          childAspectRatio: 0.65, 
                        ),
                        itemCount: filteredFoods.length,
                        itemBuilder: (context, index) {
                          return _buildFoodCard(context, filteredFoods[index]);
                        },
                      ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, dynamic food) {
    String imageUrl = "${ApiConfig.baseUrl}/images/${food['HinhAnh']}";
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
            Expanded(
              flex: 5,
              child: ClipRRect(
                key: imageKey, 
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)), 
                child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity,
                  errorBuilder: (c, e, s) => const Icon(Icons.fastfood, size: 40, color: Colors.grey)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
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
                            decoration: const BoxDecoration(color: Color(0xFFFF4D2D), shape: BoxShape.circle),
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

  Widget _buildCategoryItem(BuildContext context, String title, String fileName, double width) {
    String categoryImageUrl = "${ApiConfig.baseUrl}/images/$fileName";
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => MenuPage(initialCategoryName: title),
          ));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 55, height: 55,
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(categoryImageUrl, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const Icon(Icons.restaurant, color: Colors.orange)),
              ),
            ),
            const SizedBox(height: 8),
            Text(title, 
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}