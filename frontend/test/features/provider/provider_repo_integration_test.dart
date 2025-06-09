import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/dio_client.dart';
import 'package:frontend/features/provider/data/provider_model.dart';
import 'package:frontend/features/provider/data/provider_repository.dart';

void main() {
  final Dio dio = DioClient.createDio();
  final repository = ProviderRepository(dio);

  group('ProviderRepository Integration Test', () {

    test('Fetch all providers returns non-empty list', () async {
      final providers = await repository.getAllProviders();
      expect(providers, isA<List<Provider>>());
      expect(providers.isNotEmpty, true, reason: 'Provider list should not be empty');
    });

    test('Fetch providers by category returns list', () async {
      final categoryId = 1; // Replace with an actual categoryId in your backend
      final providers = await repository.getProvidersByCategory(categoryId);
      expect(providers, isA<List<Provider>>());
    });

    test('Fetch single provider details returns a valid Provider', () async {
      final providerId = 1; // Replace with an actual providerId from your backend
      final provider = await repository.getProviderDetails(providerId);
      expect(provider, isA<Provider>());
      expect(provider.id, equals(providerId));
    });

  });
}
