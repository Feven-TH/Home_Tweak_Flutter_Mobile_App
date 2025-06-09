import '../provider_repository_interface.dart';
import '../../data/provider_model.dart';

class GetProviderDetails {
  final IProviderRepository repository;

  GetProviderDetails(this.repository);

  Future<Provider> call(int providerId) {
    return repository.getProviderDetails(providerId);
  }
}
