import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/provider/presentation/providers_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../features/provider/data/provider_model.dart' as models;
// import '../../features/provider/data/category_model.dart';

class FinishSigningUpScreen extends ConsumerStatefulWidget {
  const FinishSigningUpScreen({super.key});

  @override
  ConsumerState<FinishSigningUpScreen> createState() => _FinishSigningUpScreenState();
}

class _FinishSigningUpScreenState extends ConsumerState<FinishSigningUpScreen> {
  // Controllers for text input fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _externalLinksController = TextEditingController();
  final TextEditingController _experienceLevelController = TextEditingController();
  final TextEditingController _hourlyRateController = TextEditingController();
  final TextEditingController _servicesProvidedController = TextEditingController();
  final TextEditingController _certificationsLicensesController = TextEditingController();

  // State for the category dropdown
  String? _selectedCategory;
  final List<String> _categories = [
    'Plumbing',
    'Electrician',
    'Carpentry',
    'Cleaning',
    'Gardening',
    'Other'
  ];

  // Global key for the form, used for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks when the widget is removed from the tree
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _locationController.dispose();
    _externalLinksController.dispose();
    _hourlyRateController.dispose();
    _servicesProvidedController.dispose();
    _certificationsLicensesController.dispose();
    super.dispose();
  }

  // Function to handle saving changes when the "Save changes" button is pressed.
  // It validates the form, creates a Provider model, and calls the createNewProvider
  // method on the ProviderNotifier.
  void _saveChanges() async {
    // Validate all form fields
    if (_formKey.currentState?.validate() ?? false) {
      // Create a Provider object from the current form data
      final newProvider = models.ServiceProvider(
        // Mapping UI fields to models.Provider fields
        id: 0, // Placeholder: id is required in your model, usually set by backend.
        userId: 0, // Placeholder: userId is required in your model, usually set during auth.
        username: _fullNameController.text, // Assuming fullName maps to username
        phoneNumber: _phoneNumberController.text,
        hourlyRate: double.tryParse(_hourlyRateController.text) ?? 0.0,
        yearsOfExperience: int.tryParse(_experienceLevelController.text) ?? 0, // Attempt to parse experienceLevel to int
        location: _locationController.text,
        category: _selectedCategory, // category is nullable string in model
        serviceDescription: _servicesProvidedController.text, // servicesProvided maps to serviceDescription
        certificate: _certificationsLicensesController.text,
      );

      // Access the ProviderNotifier using ref.read and call createNewProvider
      final providerNotifier = ref.read(providerNotifierProvider.notifier);
      await providerNotifier.createNewProvider(newProvider as Provider);

      // After the operation, check the state for success or error
      final state = ref.read(providerNotifierProvider);
      if (state.errorMessage != null) {
        _showMessage('Error: ${state.errorMessage}', isError: true);
      } else {
        _showMessage('Provider information saved successfully!');
        // Optionally, clear the form fields after successful submission
        _clearFormFields();
      }
    }
  }

  // Helper function to clear all text input fields and reset dropdown
  void _clearFormFields() {
    _fullNameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    _locationController.clear();
    _externalLinksController.clear();
    _experienceLevelController.clear();
    _hourlyRateController.clear();
    _servicesProvidedController.clear();
    _certificationsLicensesController.clear();
    setState(() {
      _selectedCategory = null; // Reset dropdown selection
    });
  }

  // Helper function to show messages to the user using a SnackBar.
  // This replaces `alert()` or `confirm()` as they are not suitable for Flutter UIs.
  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade600 : AppColors.accent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the loading state from the ProviderNotifier to disable the button during submission
    final providerState = ref.watch(providerNotifierProvider);
    final isLoading = providerState.isLoading;

    return Scaffold(
      appBar: AppBar(
        // Leading icon for the app bar (pencil icon)
        leading: const Icon(Icons.edit_outlined),
        // Title of the app bar, styled using AppTextStyles
        title: Text('Finish Signing Up', style: AppTextStyles.headline3.copyWith(color: AppColors.textPrimary)),
        centerTitle: false, // Align title to the left
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Assign the form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Basic Information Section
                _buildSection(
                  context,
                  title: 'Basic information',
                  children: [
                    _buildInputField(
                      controller: _fullNameController,
                      labelText: 'Full name:',
                      hintText: 'Enter your full name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    _buildInputField(
                      controller: _emailController,
                      labelText: 'Email:',
                      hintText: 'Enter your email address',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        // Basic email validation regex
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    _buildInputField(
                      controller: _phoneNumberController,
                      labelText: 'Phone Number:',
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number cannot be empty';
                        }
                        // Basic phone number validation (digits only)
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    _buildInputField(
                      controller: _locationController,
                      labelText: 'Location:',
                      hintText: 'Enter your location',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Location cannot be empty';
                        }
                        return null;
                      },
                    ),
                    _buildInputField(
                      controller: _externalLinksController,
                      labelText: 'External links:',
                      hintText: 'e.g., your portfolio, social media',
                      // No specific validator, optional field
                    ),
                  ],
                ),
                const SizedBox(height: 24), // Spacer between sections

                // Professional Details Section
                _buildSection(
                  context,
                  title: 'Professional Details',
                  children: [
                    _buildCategoryDropdown(), // Custom dropdown widget
                    _buildInputField(
                      controller: _experienceLevelController,
                      labelText: 'Experience Level:',
                      hintText: 'e.g., Junior, Mid, Senior',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Experience level cannot be empty';
                        }
                        return null;
                      },
                    ),
                    _buildInputField(
                      controller: _hourlyRateController,
                      labelText: 'Hourly Rate:',
                      hintText: 'e.g., 25.00',
                      keyboardType: TextInputType.number, // Numeric input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Hourly rate cannot be empty';
                        }
                        // Validate if it's a valid positive number
                        if (double.tryParse(value) == null || double.parse(value) <= 0) {
                          return 'Enter a valid positive number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Services Provided Section
                _buildSection(
                  context,
                  title: 'Services provided',
                  children: [
                    _buildMultiLineInputField(
                      controller: _servicesProvidedController,
                      labelText: 'List them here please:',
                      hintText: 'e.g., Leak repair, Electrical wiring, Cabinet installation',
                      maxLines: 5, // Allow multiple lines of input
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Services provided cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Certifications / Licenses Section
                _buildSection(
                  context,
                  title: 'Certifications / Licenses',
                  children: [
                    _buildMultiLineInputField(
                      controller: _certificationsLicensesController,
                      labelText: 'List them here please:',
                      hintText: 'e.g., Certified Electrician, Plumbing License #12345',
                      maxLines: 5, // Allow multiple lines of input
                      // No specific validator, optional field
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Save Changes Button - uses your AppButton widget
                AppButton(
                  text: 'Save changes',
                  onPressed: isLoading ? null : _saveChanges, // Disable button if loading
                  isLoading: isLoading, // Show loading indicator if true
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a section container with a title and a list of children.
  // It applies consistent styling for section cards.
  Widget _buildSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.headline4.copyWith(color: AppColors.textPrimary),
              ),
              if (title == 'Basic information') // Add plus icon only for Basic information
                Icon(Icons.add, color: AppColors.textPrimary.withOpacity(0.7)),
            ],
          ),
          const SizedBox(height: 16), // Space between title and first input field
          ...children.map((widget) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0), // Add consistent vertical padding between form fields
            child: widget,
          )).toList(),
        ],
      ),
    );
  }

  // Helper method to build a single-line text input field.
  // Applies the theme's input decoration and custom text styles.
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppTextStyles.label, // Use your defined label style
        ),
        const SizedBox(height: 8), // Space between label and input field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary), // Text style for input
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validator: validator, // Pass the validator function
        ),
      ],
    );
  }

  // Helper method to build a multi-line text input field.
  // Similar to _buildInputField but configured for multiple lines.
  Widget _buildMultiLineInputField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppTextStyles.label, // Use your defined label style
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: TextInputType.multiline, // Enable multi-line input
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            alignLabelWithHint: true, // Align hint text to the top for multi-line fields
          ),
          validator: validator, // Pass the validator function
        ),
      ],
    );
  }

  // Helper method to build the category dropdown field.
  // Uses DropdownButtonFormField for built-in validation and styling.
  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category:',
          style: AppTextStyles.label, // Use your defined label style
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            hintText: 'Select a category',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
        ),
      ],
    );
  }
}
