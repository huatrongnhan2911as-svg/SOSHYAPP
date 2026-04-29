import 'package:flutter/material.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'order_page.dart';
import 'cart_manager.dart'; // File này chứa biến cartCount và danh sách tempCart

void main() {
  runApp(const SoshyApp());
}

class SoshyApp extends StatelessWidget {
  const SoshyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SoShy Sushi',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF4D2D),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

// Khai báo Key toàn cục để trang Home có thể tìm thấy vị trí của Tab Order
final GlobalKey cartKey = GlobalKey();

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // Danh sách các trang
  final List<Widget> _pages = [
    const HomePage(),
    const MenuPage(initialCategoryName: "Nigiri"),
    const OrderPage(),
    const Scaffold(body: Center(child: Text("Profile Page"))), // Tạm thời thay Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dùng IndexedStack để khi chuyển Tab không bị load lại dữ liệu từ đầu
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF4D2D),
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          
          // TAB ORDER CÓ HIỆN SỐ 1, 2, 3...
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<int>(
              valueListenable: cartCount, // Lắng nghe biến đếm từ cart_manager.dart
              builder: (context, count, child) {
                return Stack(
                  key: cartKey, // GẮN KEY Ở ĐÂY ĐỂ LÀM ĐIỂM ĐẾN CHO HIỆU ỨNG BAY
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.receipt_long_outlined),
                    if (count > 0) // Chỉ hiện số nếu giỏ hàng có món
                      Positioned(
                        right: -5,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Order',
          ),
          
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}