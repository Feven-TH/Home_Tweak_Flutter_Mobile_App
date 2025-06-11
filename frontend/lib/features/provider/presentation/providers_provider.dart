import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/dio_client.dart';
import '../data/provider_repository.dart';
import '../domain/provider_repository_interface.dart';
import '../domain/provider_usecases/create_provider.dart';
import '../domain/provider_usecases/update_provider.dart';
import 'provider_notifier.dart';
import 'provider_state.dart';

// Use Cases
import '../domain/provider_usecases/get_all_providers.dart';
import '../domain/provider_usecases/get_providers_by_category.dart';
import '../domain/provider_usecases/get_provider_details.dart';
import '../domain/provider_usecases/search_providers_by_name.dart';

final dioProvider = Provider<Dio>((ref) => DioClient.createDio());

final providerRepositoryProvider = Provider<IProviderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProviderRepository(dio);
});

// UseCase Providers
final createProviderUseCaseProvider = Provider<CreateProvider>((ref) {
  return CreateProvider(ref.watch(providerRepositoryProvider));
});

final getAllProvidersUseCaseProvider = Provider<GetAllProviders>((ref) {
  return GetAllProviders(ref.watch(providerRepositoryProvider));
});

final updateProviderUseCaseProvider = Provider<UpdateProvider>((ref) {
  return UpdateProvider(ref.watch(providerRepositoryProvider));
});

final getProvidersByCategoryUseCaseProvider = Provider<GetProvidersByCategory>((ref) {
  return GetProvidersByCategory(ref.watch(providerRepositoryProvider));
});

final getProviderDetailsUseCaseProvider = Provider<GetProviderDetails>((ref) {
  return GetProviderDetails(ref.watch(providerRepositoryProvider));
});

final searchProvidersByNameUseCaseProvider = Provider<SearchProvidersByName>((ref) {
  return SearchProvidersByName(ref.watch(providerRepositoryProvider));
});

// Notifier Provider
final providerNotifierProvider =
    StateNotifierProvider<ProviderNotifier, ProviderState>((ref) {
  return ProviderNotifier(
    createProvider: ref.watch(createProviderUseCaseProvider),
    getAllProviders: ref.watch(getAllProvidersUseCaseProvider),
    updateProvider: ref.watch(updateProviderUseCaseProvider),
    getProvidersByCategory: ref.watch(getProvidersByCategoryUseCaseProvider),
    getProviderDetails: ref.watch(getProviderDetailsUseCaseProvider),
    searchProvidersByName: ref.watch(searchProvidersByNameUseCaseProvider),
  );
});
