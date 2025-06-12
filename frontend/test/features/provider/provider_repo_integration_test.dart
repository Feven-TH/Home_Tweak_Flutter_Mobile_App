import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/dio_client.dart';
import 'package:frontend/features/provider/data/provider_model.dart';
import 'package:frontend/features/provider/data/provider_repository.dart';

void main() {
  // Create an instance of Dio HTTP client using a custom DioClient
  final Dio dio = DioClient.createDio();

  // Instantiate the ProviderRepository with the Dio client for API calls
  final repository = ProviderRepository(dio);

  // Group related tests for ProviderRepository integration
  group('ProviderRepository Integration Test', () {

    // Test to ensure fetching all providers returns a list that is not empty
    test('Fetch all providers returns non-empty list', () async {
      // Call the method to get all providers
      final providers = await repository.getAllProviders();

      // Check that the result is a list of Provider objects
      expect(providers, isA<List<Provider>>());

      // Assert that the list is not empty, meaning providers were fetched successfully
      expect(providers.isNotEmpty, true, reason: 'Provider list should not be empty');
    });

    // Test fetching providers filtered by a specific category
    test('Fetch providers by category returns list', () async {
      // Define a category ID to filter providers by
      final categoryId = 1; // TODO: Replace with a valid categoryId from your backend data

      // Call the method to get providers by category
      final providers = await repository.getProvidersByCategory(categoryId);

      // Verify that the returned data is a list of Provider objects
      expect(providers, isA<List<Provider>>());
    });

    // Test fetching detailed information about a single provider by ID
    test('Fetch single provider details returns a valid Provider', () async {
      // Define a provider ID to fetch details for
      final providerId = 1; // TODO: Replace with a valid providerId from your backend data

      // Call the method to get provider details by ID
      final provider = await repository.getProviderDetails(providerId);

      // Assert the returned object is a Provider instance
      expect(provider, isA<Provider>());

      // Assert the provider's ID matches the requested ID to ensure correctness
      expect(provider.id, equals(providerId));
    });

  });
}
