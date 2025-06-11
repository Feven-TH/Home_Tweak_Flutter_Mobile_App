import 'package:dio/dio.dart';

class DioClient {
  static Dio createDio() {
    return Dio(
      BaseOptions(
        // baseUrl: 'http://http://localhost:5000',
        baseUrl: 'http://192.168.213.216:5000',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN', // ✅ Only add this if using auth later
        },
      ),
    );
  }
}