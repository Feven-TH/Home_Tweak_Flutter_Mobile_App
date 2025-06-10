import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/theme/app_text_style.dart';
import 'package:frontend/core/widgets/custom_button.dart'; 
import 'package:frontend/core/widgets/nav_bar.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  // Controllers for the input fields
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController; 

  // Global state for editing mode
  bool _isGlobalEditingMode = false;

  // Track initial values to determine if changes have been made
  String _initialUsername = 'current_username'; 
  String _initialEmail = 'user@example.com';   
  String _initialPassword = '••••••••';       
  bool _changesMade = false;

  
  int _selectedIndex = 2; 
  @override
  void initState() {
    super.initState();
    // In a real app, these would be initialized with data fetched from your user state notifier
    _usernameController = TextEditingController(text: _initialUsername);
    _emailController = TextEditingController(text: _initialEmail);
    _passwordController = TextEditingController(text: _initialPassword);

    // Add listeners to detect changes and enable/disable the confirm button
    _usernameController.addListener(_checkChanges);
    _emailController.addListener(_checkChanges);
    _passwordController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_checkChanges);
    _emailController.removeListener(_checkChanges);
    _passwordController.removeListener(_checkChanges);
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkChanges() {
    // Only check for changes if we are in editing mode
    if (_isGlobalEditingMode) {
      final currentChangesMade = (_usernameController.text != _initialUsername) ||
          (_emailController.text != _initialEmail) ||
          (_passwordController.text != _initialPassword);
      if (currentChangesMade != _changesMade) {
        setState(() {
          _changesMade = currentChangesMade;
        });
      }
    }
  }

  void _toggleGlobalEditMode() {
    setState(() {
      _isGlobalEditingMode = !_isGlobalEditingMode;
      if (!_isGlobalEditingMode) {
        // If exiting edit mode without confirming, revert changes
        _usernameController.text = _initialUsername;
        _emailController.text = _initialEmail;
        _passwordController.text = _initialPassword;
        _changesMade = false; // No changes to confirm
      }
    });
    // TODO: Initiate state notifier to indicate editing mode change (e.g., fetch original data if needed)
  }

  void _confirmChanges() {
    // TODO: Implement save changes logic (call notifier to update profile)
    // This is where your state notifier will initiate the POST request
    print('Confirming Changes:');
    print('Username: ${_usernameController.text}');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');

    
    setState(() {
      _initialUsername = _usernameController.text;
      _initialEmail = _emailController.text;
      _initialPassword = _passwordController.text; 
      _changesMade = false; 
      _isGlobalEditingMode = false; 
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile updated successfully!',
          style: AppTextStyles.body.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.textPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _logout() {
    // TODO: Implement logout logic (call auth notifier to log out)
    print('User Logout');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Logging out...',
          style: AppTextStyles.body.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.textSecondary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account',
          style: AppTextStyles.headline3.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you absolutely sure you want to delete your account? This action cannot be undone.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              // TODO: Trigger actual account deletion process
              print('User confirmed account deletion');
            },
            child: Text(
              'Delete',
              style: AppTextStyles.button.copyWith(color: Colors.red), // Changed to Colors.red
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Implement actual navigation logic based on index
    print('Tapped on index: $index');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: AppTextStyles.headline2.copyWith(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: const [], // Removed logout from AppBar actions
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Card
            Card(
              color: AppColors.cardBackground,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // "Update Profile" pencil icon/button (TOP RIGHT OF CARD)
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton.icon(
                        onPressed: _toggleGlobalEditMode,
                        icon: Icon(
                          _isGlobalEditingMode ? Icons.close : Icons.edit,
                          color: AppColors.accent,
                          size: 20,
                        ),
                        label: Text(
                          _isGlobalEditingMode ? 'Cancel Edit' : 'Update Profile',
                          style: AppTextStyles.subtitle.copyWith(color: AppColors.accent),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Clickable Profile Picture Section
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement image selection logic
                        print('Change profile picture (Card Clickable)');
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.accent.withOpacity(0.2),
                              backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.accent,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Username Input Field
                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person,
                      readOnly: !_isGlobalEditingMode,
                    ),
                    const SizedBox(height: 16),

                    // Email Input Field
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),

                    // Password Input Field
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      readOnly: !_isGlobalEditingMode,
                    ),
                    const SizedBox(height: 24),

                    // Confirm Changes Button (only visible and enabled in edit mode with changes)
                    if (_isGlobalEditingMode)
                      Center(
                        child: AppButton(
                          text: 'Save Changes',
                          onPressed: _changesMade ? _confirmChanges : null,
                          isEnabled: _changesMade,
                          type: ButtonType.primary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40), // Space between card and buttons column

            
            Center( 
              child: Column(
                children: [
                  TextButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: AppColors.textSecondary, size: 24),
                    label: Text(
                      'Logout',
                      style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.textSecondary, width: 1.5),
                      ),
                      backgroundColor: AppColors.cardBackground.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Delete Account Button
                  TextButton.icon(
                    onPressed: () => _showDeleteAccountConfirmation(context),
                    icon: const Icon(Icons.delete_forever, color: Colors.red, size: 24),
                    label: Text(
                      'Delete Account',
                      style: AppTextStyles.button.copyWith(color: Colors.red), 
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.red, width: 1.5), 
                      ),
                      backgroundColor: AppColors.cardBackground.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24), // Space at bottom
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  // _buildTextField helper
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          obscureText: obscureText,
          style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }
}