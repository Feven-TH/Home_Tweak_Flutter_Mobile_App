import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/provider_usecases/get_all_providers.dart';
import '../domain/provider_usecases/get_providers_by_category.dart';
import '../domain/provider_usecases/get_provider_details.dart';
import '../domain/provider_usecases/search_providers_by_name.dart';
import 'provider_state.dart';


class ProviderNotifier extends StateNotifier<ProviderState> {
  final GetAllProviders getAllProviders;
  final GetProvidersByCategory getProvidersByCategory;
  final GetProviderDetails getProviderDetails;
  final SearchProvidersByName searchProvidersByName;

  ProviderNotifier({
    required this.getAllProviders,
    required this.getProvidersByCategory,
    required this.getProviderDetails,
    required this.searchProvidersByName,
  }) : super(const ProviderState());

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
