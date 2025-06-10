import '../data/provider_model.dart';

abstract class IProviderRepository {
  Future<Provider> createProvider(Provider provider);
  Future<Provider> updateProvider(int id, Provider provider);
  Future<List<Provider>> getAllProviders();
  Future<List<Provider>> getProvidersByCategory(int categoryId);
  Future<Provider> getProviderDetails(int providerId);
  Future<List<Provider>> searchProvidersByName(String query);
}
