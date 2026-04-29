import 'package:flutter/material.dart';

// --- 1. TRANG THANH TOÁN (PAYMENT PAGE) ---
class PaymentPage extends StatefulWidget {
  final double totalFromOrder;

  const PaymentPage({super.key, required this.totalFromOrder});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedMethod = "Google Pay";

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // MAP TRANG PAYMENT
            Container(
              margin: const EdgeInsets.all(20),
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Stack(
                  children: [
                    Image.network(
                      "https://static-maps.yandex.ru/1.x/?ll=106.697,10.902&size=600,300&z=14&l=map",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    const Center(child: Icon(Icons.location_on, color: Color(0xFFFF4D2D), size: 40)),
                  ],
                ),
              ),
            ),

            _buildInfoCard([
              _buildInfoTile(Icons.home_outlined, "Home", "Lái Thiêu, Thuận An, Bình Dương"),
              _buildInfoTile(Icons.phone_outlined, "Phone", "+84 987 654 321"),
            ]),

            const SizedBox(height: 20),

            _buildInfoCard([
              _buildPaymentOption("Google Pay", "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Google_Pay_Logo.svg/512px-Google_Pay_Logo.svg.png"),
              _buildPaymentOption("Master Card (xxxx-9010)", "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/1280px-Mastercard-logo.svg.png"),
            ]),
            
            const SizedBox(height: 120), 
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 35),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total", style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text(
                  "${widget.totalFromOrder.toStringAsFixed(0)} VND", 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF4D2D))
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4D2D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderTrackingPage()));
                },
                child: const Text("Place Order", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
    child: Column(children: children),
  );

  Widget _buildInfoTile(IconData icon, String title, String sub) => ListTile(
    leading: Icon(icon, color: Colors.orange),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(sub),
  );

  Widget _buildPaymentOption(String title, String url) => RadioListTile(
    value: title,
    groupValue: selectedMethod,
    activeColor: const Color(0xFFFF4D2D),
    onChanged: (val) => setState(() => selectedMethod = val.toString()),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}

// --- 2. TRANG THEO DÕI (ORDER TRACKING PAGE) ---
class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // LỚP 1: BẢN ĐỒ TRẮNG (Dùng link dự phòng cực ổn định)
          Positioned.fill(
            child: Image.network(
              "https://www.google.com/maps/vt/pb=!1m4!1m3!1i15!2i26088!3i14407!2m3!1e0!2sm!3i605151515!3m8!2svi!3sUS!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i1301875",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.map, size: 80, color: Colors.grey)),
              ),
            ),
          ),

          // LỚP 2: NÚT X VÀ HELP (CÓ SHADOW)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: _buildCircleTool(Icons.close),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: const Text("Help", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),

          // LỚP 3: ICON SHIPPER NỔI TRÊN MAP
          Positioned(
            top: 250,
            left: 150,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                  ),
                  child: const Icon(Icons.local_shipping, color: Color(0xFFFF4D2D), size: 28),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
              ],
            ),
          ),

          // LỚP 4: BOTTOM PANEL
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 430,
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 45, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 25),
                  const Text("Heading your way", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Arriving now", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 30),
                  
                  // STEPPER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStep(Icons.restaurant, true),
                      _buildLine(true),
                      _buildStep(Icons.store, true),
                      _buildLine(true),
                      _buildStep(Icons.local_shipping, true),
                      _buildLine(false),
                      _buildStep(Icons.home, false),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text("Give DN TruongUy a moment to drop off your order.", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 30),

                  // SHIPPER PROFILE
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network("https://i.pravatar.cc/100?u=dn", width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("Deliverer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("DN TruongUy", style: TextStyle(color: Colors.grey)),
                      ])),
                      _buildCircleIcon(Icons.chat_bubble_outline),
                      const SizedBox(width: 12),
                      _buildCircleIcon(Icons.phone),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity, height: 58,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4D2D), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 0
                      ),
                      child: const Text("Order Details", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // HÀM BỔ TRỢ UI
  Widget _buildCircleTool(IconData icon) => Container(
    padding: const EdgeInsets.all(10),
    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
    child: Icon(icon, color: Colors.black, size: 24),
  );

  Widget _buildStep(IconData icon, bool active) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: active ? const Color(0xFFFF4D2D) : const Color(0xFFFFF0ED), shape: BoxShape.circle),
    child: Icon(icon, color: active ? Colors.white : const Color(0xFFFF4D2D), size: 20),
  );

  Widget _buildLine(bool active) => Expanded(child: Container(height: 3, color: active ? const Color(0xFFFF4D2D) : const Color(0xFFFFF0ED)));

  Widget _buildCircleIcon(IconData icon) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
    child: Icon(icon, color: Colors.grey[600], size: 22),
  );
}