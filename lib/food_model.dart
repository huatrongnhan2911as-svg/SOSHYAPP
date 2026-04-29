class Food {
  final String id;
  final String name;
  final String price;
  final String imagePath;

  Food({required this.id, required this.name, required this.price, required this.imagePath});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['MaMonAn'].toString(),
      name: json['TenMon'],
      price: json['Gia'].toString(),
      imagePath: json['HinhAnh'],
    );
  }
}