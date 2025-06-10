import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final VoidCallback onSignInClick;

  const SignUpScreen({super.key, required this.onSignInClick});

  @override
  Widget build(BuildContext context) {
    final roles = ['customer', 'serviceProvider'];
    String? selectedRole;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset('assets/images/home_tweak_logo.jpg', height: 150),
              const SizedBox(height: 20),
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF04285E),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Create new account',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF4F5255),
                ),
              ),
              const SizedBox(height: 32),
              const TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFF1E8),
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email, color: Color(0xFF4F5255)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFF1E8),
                  hintText: 'Enter your password',
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF4F5255)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFF1E8),
                  hintText: 'Select your role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: roles
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(
                    role,
                    style: const TextStyle(color: Color(0xFF4F5255)),
                  ),
                ))
                    .toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                height: 65,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Color(0xFF4F5255), fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onSignInClick,
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        color: Color(0xFFFF6B00),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}