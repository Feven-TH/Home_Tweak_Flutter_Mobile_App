import 'package:dio/dio.dart';
import '../domain/provider_repository_interface.dart';
import 'provider_model.dart';
import '../../../core/constants/api_endpoints.dart';

class ProviderRepository implements IProviderRepository {
  final Dio _dio;

  ProviderRepository(this._dio);

  @override
  Future<Provider> createProvider(Provider provider) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createProvider,
        data: provider.toJson(),
      );
      return Provider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create provider: $e');
    }
  }

  @override
  Future<Provider> updateProvider(int id, Provider provider) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.updateProvider(id),
        data: provider.toJson(),
      );
      return Provider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update provider: $e');
    }
  }

  @override
  Future<List<Provider>> getAllProviders() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllProviders);
      final List data = response.data;
      return data.map((json) => Provider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load providers: $e');
    }
  }

  @override
  Future<List<Provider>> getProvidersByCategory(int categoryId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getProvidersByCategory(categoryId));
      final List data = response.data;
      return data.map((json) => Provider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load providers by category: $e');
    }
  }

    @override
  Future<Provider> getProviderDetails(int providerId) async {
    try {
      // Use the new getProviderById endpoint
      final response = await _dio.get(ApiEndpoints.getProviderById(providerId));
      return Provider.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load provider details: $e');
    }
  }


 @override  
  Future<List<Provider>> searchProvidersByName(String query) async {
    try {
      final response = await _dio.get('${ApiEndpoints.searchProvidersByName}?name=$query');
      final List data = response.data;
      return data.map((json) => Provider.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search providers: $e');
    }
  }

}