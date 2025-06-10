import 'package:dio/dio.dart';

class DioClient {
  static Dio createDio() {
    return Dio(
      BaseOptions(
        baseUrl: 'http://http://localhost:5000',
        // baseUrl: 'http://192.168.1.6:5000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN', // ✅ Only add this if using auth later
        },
      ),
    );
  }
}
