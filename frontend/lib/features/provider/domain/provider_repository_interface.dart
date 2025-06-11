import '../data/provider_model.dart';

abstract class IProviderRepository {
  Future<ServiceProvider> createProvider(ServiceProvider provider);
  Future<ServiceProvider> updateProvider(int id, ServiceProvider provider);
  Future<List<ServiceProvider>> getAllProviders();
  Future<List<ServiceProvider>> getProvidersByCategory(int categoryId);
  Future<ServiceProvider> getProviderDetails(int providerId);
  Future<List<ServiceProvider>> searchProvidersByName(String query);
}
