import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/features/provider/presentation/provider_notifier.dart';
import 'package:frontend/features/provider/presentation/providers_provider.dart';
import 'package:frontend/features/provider/presentation/provider_state.dart';
import 'package:frontend/core/widgets/category_item.dart';
import 'package:frontend/core/widgets/provider_card.dart';
import 'package:frontend/views/customer/book_service_screen.dart';

class Category {
  final int id;
  final String label;
  final String iconPath;

  const Category({required this.id, required this.label, required this.iconPath});
}

const List<Category> mockCategories = [
  Category(id: 1, label: 'Plumber', iconPath: 'assets/images/plumber.png'),
  Category(id: 2, label: 'Painter', iconPath: 'assets/images/painter.png'),
  Category(id: 3, label: 'Carpenter', iconPath: 'assets/images/carpenter.png'),
  Category(id: 4, label: 'Electrician', iconPath: 'assets/images/electrician.png'),
  Category(id: 5, label: 'Contractor', iconPath: 'assets/images/subcontractor.png'),
  Category(id: 6, label: 'Gardener', iconPath: 'assets/images/gardner.png'),
];

// Your HomePage as a ConsumerStatefulWidget
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedCategoryId;
  int _currentNavBarIndex = 0; // State to manage selected bottom navigation item

  @override
  void initState() {
    super.initState();
    // Trigger initial fetch of all providers when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(providerNotifierProvider.notifier).fetchAllProviders();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider's state for UI updates
    final providerState = ref.watch(providerNotifierProvider);
    // Read the notifier to call its methods
    final providerNotifier = ref.read(providerNotifierProvider.notifier);

    // Listen for error messages as side effects
    ref.listen<ProviderState>(providerNotifierProvider, (previousState, newState) {
      if (newState.errorMessage != null && newState.errorMessage != previousState?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${newState.errorMessage}'),
            backgroundColor: AppColors.accent,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildHomePageContent(providerState, providerNotifier),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildHomePageContent(ProviderState providerState, ProviderNotifier providerNotifier) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Search Input Field
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, left: 8.0, right: 8.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for services',
                  hintStyle: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
                  isDense: true,
                ),
                style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    providerNotifier.searchProviders(query);
                    setState(() {
                      _selectedCategoryId = null;
                    });
                  } else {
                    providerNotifier.fetchAllProviders();
                  }
                },
                onChanged: (query) {
                  if (query.isEmpty) {
                    providerNotifier.fetchAllProviders();
                    setState(() {
                      _selectedCategoryId = null;
                    });
                  }
                },
              ),
            ),

            // 2. Categories Heading
            Text(
              'Categories',
              style: AppTextStyles.header.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            // 3. Horizontal Scrollable List of Category Items
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mockCategories.length,
                itemBuilder: (context, index) {
                  final category = mockCategories[index];
                  return CategoryItem(
                    iconPath: category.iconPath,
                    label: category.label,
                    isSelected: _selectedCategoryId == category.id,
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = category.id;
                        _searchController.clear();
                      });
                      providerNotifier.fetchProvidersByCategory(category.id);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 4. "Top Rated" Heading
            Text(
              _searchController.text.isNotEmpty
                  ? 'Search Results'
                  : (_selectedCategoryId != null ? 'Filtered by Category' : 'Top Rated'),
              style: AppTextStyles.header.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            // 5. List of Providers
            Expanded(
              child: _buildProviderList(providerState, providerNotifier),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderList(ProviderState state, ProviderNotifier notifier) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load providers: ${state.errorMessage}',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                notifier.fetchAllProviders();
                setState(() {
                  _selectedCategoryId = null;
                  _searchController.clear();
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
              child: Text(
                'Retry',
                style: AppTextStyles.button.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else if (state.providers.isEmpty) {
      return const Center(
        child: Text(
          'No service providers found.',
          style: AppTextStyles.body,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: state.providers.length,
        itemBuilder: (context, index) {
          final provider = state.providers[index];
          return ProviderCard(
            provider: provider,
            onDetailsTap: () {
              notifier.fetchProviderDetails(provider.id);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProviderDetailsScreen(providerId: provider.id),
              ));
            },
          );
        },
      );
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentNavBarIndex,
      onTap: (index) {
        setState(() {
          _currentNavBarIndex = index;
        });
      },
      backgroundColor: AppColors.cardBackground,
      selectedItemColor: AppColors.accent,
      unselectedItemColor: AppColors.textSecondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
