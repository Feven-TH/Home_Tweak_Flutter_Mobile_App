import '../provider_repository_interface.dart';
import '../../data/provider_model.dart';

class CreateProvider {
  final IProviderRepository repository;

  CreateProvider(this.repository);

  Future<Provider> call(Provider provider) {
    return repository.createProvider(provider);
  }
}
