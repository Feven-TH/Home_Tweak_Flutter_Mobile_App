import 'package:dio/dio.dart';
import '../domain/provider_repository_interface.dart';
import 'provider_model.dart';
import '../../../core/constants/api_endpoints.dart';

class ProviderRepository implements IProviderRepository {
  final Dio _dio;

  ProviderRepository(this._dio);

  @override
  Future<ServiceProvider> createProvider(ServiceProvider provider) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createProvider,
        data: provider.toJson(),
      );
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create provider: $e');
    }
  }

  @override
  Future<ServiceProvider> updateProvider(int id, ServiceProvider provider) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateProvider(id),
        data: provider.toJson(),
      );
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update provider: $e');
    }
  }

  @override
  Future<List<ServiceProvider>> getAllProviders() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllProviders);
      final List data = response.data;
      return data.map((json) => ServiceProvider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load providers: $e');
    }
  }

  @override
  Future<List<ServiceProvider>> getProvidersByCategory(int categoryId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getProvidersByCategory(categoryId));
      final List data = response.data;
      return data.map((json) => ServiceProvider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load providers by category: $e');
    }
  }

    @override
  Future<ServiceProvider> getProviderDetails(int providerId) async {
    try {
      // Use the new getProviderById endpoint
      final response = await _dio.get(ApiEndpoints.getProviderById(providerId));
      return ServiceProvider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load provider details: $e');
    }
  }


 @override  
  Future<List<ServiceProvider>> searchProvidersByName(String query) async {
    try {
      final response = await _dio.get('${ApiEndpoints.searchProvidersByName}?name=$query');
      final List data = response.data;
      return data.map((json) => ServiceProvider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search providers: $e');
    }
  }

}