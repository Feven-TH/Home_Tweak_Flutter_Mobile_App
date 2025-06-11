import '../provider_repository_interface.dart';
import '../../data/provider_model.dart';

class GetAllProviders {
  final IProviderRepository repository;

  GetAllProviders(this.repository);

  Future<List<ServiceProvider>> call() {
    return repository.getAllProviders();
  }
}
