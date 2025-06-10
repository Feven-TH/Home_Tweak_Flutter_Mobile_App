import '../data/provider_model.dart';

class ProviderState {
  final bool isLoading;
  final List<Provider> providers;
  final Provider? selectedProvider;
  final String? errorMessage;

  const ProviderState({
    this.isLoading = false,
    this.providers = const [],
    this.selectedProvider,
    this.errorMessage,
  });

  ProviderState copyWith({
    bool? isLoading,
    List<Provider>? providers,
    Provider? selectedProvider,
    String? errorMessage,
  }) {
    return ProviderState(
      isLoading: isLoading ?? this.isLoading,
      providers: providers ?? this.providers,
      selectedProvider: selectedProvider ?? this.selectedProvider,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
