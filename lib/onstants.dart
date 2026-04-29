import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Khi chạy trên Edge/Chrome
      return 'http://localhost/soshi_api';
    } else if (Platform.isAndroid) {
      // Khi chạy trên điện thoại thật A202ZT của ông
      // Đã thay 10.0.2.2 thành IP máy tính của ông
      return 'http://10.0.2.2/soshi_api'; 
    } else {
      return 'http://localhost/soshi_api';
    }
  }
}