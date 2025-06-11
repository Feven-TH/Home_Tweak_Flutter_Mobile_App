import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/user/presentation/user_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  final VoidCallback onSignInClick;

  const SignUpScreen({super.key, required this.onSignInClick});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  String? _selectedRole;
  final _roles = ['customer', 'serviceProvider'];

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    final userNotifier = ref.read(userNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/home_tweak_logo.jpg', height: 150),
              const SizedBox(height: 20),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF04285E)),
              ),
              const SizedBox(height: 32),
              const Text('Create new account', style: TextStyle(fontSize: 20, color: Color(0xFF4F5255))),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFF1E8),
                  hintText: 'Enter your username',
                  prefixIcon: Icon(Icons.person, color: Color(0xFF4F5255)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFF1E8),
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email, color: Color(0xFF4F5255)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFF1E8),
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF4F5255)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFF1E8),
                  hintText: 'Select your role',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                ),
                items: _roles.map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                height: 65,
                child: ElevatedButton(
                  onPressed: userState.isLoading
                      ? null
                      : () async {
                    await userNotifier.register(
                      _usernameController.text.trim(),
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                      _selectedRole ?? '',
                    );
                    if (userState.error == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration successful")));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                  child: userState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up", style: TextStyle(fontSize: 28, color: Colors.white)),
                ),
              ),
              if (userState.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(userState.error!, style: const TextStyle(color: Colors.red)),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?", style: TextStyle(fontSize: 16, color: Color(0xFF4F5255))),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onSignInClick,
                    child: const Text("Sign in", style: TextStyle(fontSize: 16, color: Color(0xFFFF6B00), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
