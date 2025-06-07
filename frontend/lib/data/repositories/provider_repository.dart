import 'package:dio/dio.dart';
import '../../models/provider_model.dart';
import '../../data/dio_client.dart';

class ProviderRepository {
  final Dio _dio = DioClient.createDio();

  //Get all service providers from the backend
  Future<List<Provider>> getAllProviders() async {
    try {
      final response = await _dio.get('/providers'); 
      final List data = response.data; 
      return data.map((json) => Provider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load providers: $e');
    }
  }

  //Get providers filtered by a specific category (e.g., electrician, plumber)
  Future<List<Provider>> getProvidersByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/providers/category/$categoryId'); 
      final List data = response.data;
      return data.map((json) => Provider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load providers by category: $e');
    }
  }

  // 🔹 Get details of a single provider by ID
  Future<Provider> getProviderDetails(int providerId) async {
    try {
      final response = await _dio.get('/providers/$providerId'); 
      return Provider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load provider details: $e');
    }
  }
}
