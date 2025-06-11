import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/provider_usecases/create_provider.dart';
import '../domain/provider_usecases/get_all_providers.dart';
import '../domain/provider_usecases/update_provider.dart';
import '../domain/provider_usecases/get_providers_by_category.dart';
import '../domain/provider_usecases/get_provider_details.dart';
import '../domain/provider_usecases/search_providers_by_name.dart';
import 'provider_state.dart';


class ProviderNotifier extends StateNotifier<ProviderState> {
  final CreateProvider createProvider;
  final GetAllProviders getAllProviders;
  final UpdateProvider updateProvider;
  final GetProvidersByCategory getProvidersByCategory;
  final GetProviderDetails getProviderDetails;
  final SearchProvidersByName searchProvidersByName;

  ProviderNotifier({
    required this.createProvider,
    required this.getAllProviders,
    required this.updateProvider,
    required this.getProvidersByCategory,
    required this.getProviderDetails,
    required this.searchProvidersByName,
  }) : super(const ProviderState());

  /// Create a new provider
  Future<void> createNewProvider(Provider provider) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final newProvider = await createProvider(provider);
      state = state.copyWith(
        providers: [...state.providers, newProvider],
        isLoading: false,
        successMessage: 'Provider created successfully',
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to create provider: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch all providers
  Future<void> fetchAllProviders() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final providers = await getAllProviders();
      state = state.copyWith(providers: providers, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  /// Fetch providers by category ID
  Future<void> fetchProvidersByCategory(int categoryId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final providers = await getProvidersByCategory(categoryId);
      state = state.copyWith(providers: providers, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  /// Update an existing provider
  Future<void> updateExistingProvider(int providerId, Provider provider) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedProvider = await updateProvider(providerId, provider);
      state = state.copyWith(
        providers: state.providers.map((p) =>
        p.id == providerId ? updatedProvider : p
        ).toList(),
        selectedProvider: state.selectedProvider?.id == providerId
            ? updatedProvider
            : state.selectedProvider,
        isLoading: false,
        successMessage: 'Provider updated successfully',
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update provider: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch provider details by provider ID
  Future<void> fetchProviderDetails(int providerId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final providerDetails = await getProviderDetails(providerId);
      state = state.copyWith(selectedProvider: providerDetails, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  /// Search providers by name query
  Future<void> searchProviders(String query) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final providers = await searchProvidersByName(query);
      state = state.copyWith(providers: providers, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}
