import '../provider_repository_interface.dart';
import '../../data/provider_model.dart';

class UpdateProvider {
  final IProviderRepository repository;

  UpdateProvider(this.repository);

  Future<ServiceProvider> call(int id, ServiceProvider provider) {
    return repository.updateProvider(id, provider);
  }
}