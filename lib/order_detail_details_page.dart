import 'package:flutter/material.dart';

class OrderDetailDetailsPage extends StatelessWidget {
  const OrderDetailDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. THANH TIÊU ĐỀ (NÚT X)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      "Hang is there, we're on it!",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 30),

                    // 2. CARD THÔNG TIN CỬA HÀNG VÀ ẢNH MÓN ĂN
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8))
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.wb_sunny_outlined, color: Colors.orange, size: 22),
                                    const SizedBox(width: 10),
                                    const Text("Sakura sushi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: const Color(0xFFFFEAE6), borderRadius: BorderRadius.circular(6)),
                                      child: const Text("Preparing Order", style: TextStyle(color: Color(0xFFFF4D2D), fontSize: 10, fontWeight: FontWeight.bold)),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text("Estimated arrival", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                const SizedBox(height: 5),
                                const Text("30-49 minutes", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // ẢNH MÓN ĂN (Món Sushi salmon)
                          Image.network(
                            "https://i.imgur.com/v2Vz6R7.png", // Link dĩa sushi
                            width: 105,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 3. BANNER TRẠNG THÁI (THUMB UP)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4E6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.thumb_up, color: Colors.orange, size: 22),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Sakura sushi is preparing your order. Fresh rolls are on the way!",
                              style: TextStyle(color: Colors.brown, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 4. BANNER UNLOCK FREE DELIVERY (3D CHARACTER)
                    Container(
                      width: double.infinity,
                      height: 170,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF0FF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Unlock Free Delivery!", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                const SizedBox(
                                  width: 160,
                                  child: Text("Get more exclusive deals and discounts.", style: TextStyle(color: Colors.grey, fontSize: 13)),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text("Explore Now", style: TextStyle(fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                          // ẢNH NHÂN VIÊN GIAO HÀNG 3D
                          Positioned(
                            right: -5,
                            bottom: 0,
                            child: Image.network(
                              "https://i.imgur.com/mOIn9kL.png", // Link nhân vật 3D
                              height: 155,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 5. FOOTER (DELIVERING TO)
            Container(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.home_outlined, color: Colors.orange, size: 24),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Delivering to", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Text("Home, Expected in 25 mins", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

