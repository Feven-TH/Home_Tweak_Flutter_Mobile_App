import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/provider/presentation/provider_notifier.dart';
import 'package:frontend/features/provider/data/provider_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/features/provider/domain/provider_usecases/create_provider.dart';
import 'package:frontend/features/provider/domain/provider_usecases/update_provider.dart';
import 'package:frontend/features/provider/domain/provider_usecases/get_all_providers.dart';
import 'package:frontend/features/provider/domain/provider_usecases/get_providers_by_category.dart';
import 'package:frontend/features/provider/domain/provider_usecases/get_provider_details.dart';
import 'package:frontend/features/provider/domain/provider_usecases/search_providers_by_name.dart';

// Generate mocks for all these classes
@GenerateMocks([
  GetAllProviders,
  GetProvidersByCategory,
  GetProviderDetails,
  SearchProvidersByName,
  CreateProvider,   // Added for completeness
  UpdateProvider,   // Added for completeness
])
import 'provider_notifier_test.mocks.dart';

void main() {
  late ProviderNotifier notifier;

  // Declare the generated mock instances
  late MockGetAllProviders mockGetAllProviders;
  late MockGetProvidersByCategory mockGetProvidersByCategory;
  late MockGetProviderDetails mockGetProviderDetails;
  late MockSearchProvidersByName mockSearchProvidersByName;
  late MockCreateProvider mockCreateProvider;
  late MockUpdateProvider mockUpdateProvider;

  setUp(() {
    // Instantiate the generated mock classes
    mockGetAllProviders = MockGetAllProviders();
    mockGetProvidersByCategory = MockGetProvidersByCategory();
    mockGetProviderDetails = MockGetProviderDetails();
    mockSearchProvidersByName = MockSearchProvidersByName();
    mockCreateProvider = MockCreateProvider();  // new
    mockUpdateProvider = MockUpdateProvider();  // new

    notifier = ProviderNotifier(
      getAllProviders: mockGetAllProviders,
      getProvidersByCategory: mockGetProvidersByCategory,
      getProviderDetails: mockGetProviderDetails,
      searchProvidersByName: mockSearchProvidersByName,
      createProvider: mockCreateProvider, // no longer null
      updateProvider: mockUpdateProvider, // no longer null
    );
  });

  test('Initial state should be correct', () {
    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.providers, isEmpty);
    expect(notifier.state.selectedProvider, isNull);
    expect(notifier.state.errorMessage, isNull);
  });

  test('fetchAllProviders success', () async {
    final mockProviders = [
      Provider(
        id: 1,
        userId: 1,
        phoneNumber: '0911223344',
        hourlyRate: 50.00,
        yearsOfExperience: 5,
        categoryId: 1,
        serviceDescription: 'Test service description',
        username: 'test_user',
        category: 'Test Category',
      )
    ];

    when(mockGetAllProviders.call()).thenAnswer((_) async => mockProviders);

    await notifier.fetchAllProviders();

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.providers, mockProviders);
    expect(notifier.state.errorMessage, isNull);
  });

  test('fetchAllProviders failure', () async {
    when(mockGetAllProviders.call()).thenThrow(Exception('Failed to load providers'));

    await notifier.fetchAllProviders();

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.providers, isEmpty);
    expect(notifier.state.errorMessage, contains('Failed to load providers'));
  });

  test('fetchProvidersByCategory success', () async {
    final mockProviders = [
      Provider(
        id: 2,
        userId: 1,
        phoneNumber: '0911223344',
        hourlyRate: 60.00,
        yearsOfExperience: 3,
        categoryId: 2,
        serviceDescription: 'Category-specific service',
        username: 'cat_user',
        category: 'Category Two',
      )
    ];
    const categoryId = 2;
    when(mockGetProvidersByCategory.call(categoryId)).thenAnswer((_) async => mockProviders);

    await notifier.fetchProvidersByCategory(categoryId);

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.providers, mockProviders);
    expect(notifier.state.errorMessage, isNull);
  });

  test('fetchProviderDetails success', () async {
    final mockProvider = Provider(
      id: 3,
      userId: 1,
      phoneNumber: '0911223344',
      hourlyRate: 70.00,
      yearsOfExperience: 10,
      categoryId: 1,
      serviceDescription: 'Detailed service info',
      username: 'detail_user',
      category: 'Main Category',
    );
    const providerId = 3;
    when(mockGetProviderDetails.call(providerId)).thenAnswer((_) async => mockProvider);

    await notifier.fetchProviderDetails(providerId);

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.selectedProvider, mockProvider);
    expect(notifier.state.errorMessage, isNull);
    expect(notifier.state.providers, isEmpty);
  });

  test('searchProviders success', () async {
    final mockProviders = [
      Provider(
        id: 4,
        userId: 1,
        phoneNumber: '0911223344',
        hourlyRate: 45.00,
        yearsOfExperience: 2,
        categoryId: 1,
        serviceDescription: 'Search result service',
        username: 'search_user',
        category: 'Search Category',
      )
    ];
    const query = 'searchterm';
    when(mockSearchProvidersByName.call(query)).thenAnswer((_) async => mockProviders);

    await notifier.searchProviders(query);

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.providers, mockProviders);
    expect(notifier.state.errorMessage, isNull);
  });

  // You can add failure cases for other methods similarly.
}
