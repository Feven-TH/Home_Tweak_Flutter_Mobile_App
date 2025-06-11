import '../provider_repository_interface.dart';
import '../../data/provider_model.dart';

class SearchProvidersByName {
  final IProviderRepository repository;

  SearchProvidersByName(this.repository);

  Future<List<ServiceProvider>> call(String query) {
    return repository.searchProvidersByName(query);
  }
}
