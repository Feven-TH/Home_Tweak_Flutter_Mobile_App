import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/repositories/provider_repository.dart';

void main() {
  final repo = ProviderRepository();

  test('Get providers by category', () async {
    int testCategoryId = 1;
    final providers = await repo.getProvidersByCategory(testCategoryId);
    expect(providers.isNotEmpty, true);

    // Optional: Make sure all returned providers match the category
    for (var p in providers) {
      expect(p.categoryId, testCategoryId);
    }
  });
}
