import '../data/provider_model.dart';

abstract class IProviderRepository {
  Future<List<Provider>> getAllProviders();
  Future<List<Provider>> getProvidersByCategory(int categoryId);
  Future<Provider> getProviderDetails(int providerId);
  Future<List<Provider>> searchProvidersByName(String query);
}
