import '../provider_repository_interface.dart';
import '../../data/provider_model.dart';

class GetProvidersByCategory {
  final IProviderRepository repository;

  GetProvidersByCategory(this.repository);

  Future<List<ServiceProvider>> call(int categoryId) {
    return repository.getProvidersByCategory(categoryId);
  }
}
