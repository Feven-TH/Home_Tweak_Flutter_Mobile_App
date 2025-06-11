import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onSignUpClick;
  final VoidCallback onForgotPasswordClick;

  const LoginScreen({
    super.key,
    required this.onSignUpClick,
    required this.onForgotPasswordClick,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = true;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/home_tweak_logo.jpg', // Ensure asset exists in pubspec.yaml
                height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                "Login",
                style: TextStyle(
                  color: Color(0xFF04285E),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Sign in to your account via email",
                style: TextStyle(
                  color: Color(0xFF4F5255),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFF1E8),
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF4F5255)),
                  hintText: "Enter your email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFF1E8),
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF4F5255)),
                  hintText: "Enter your password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (val) => setState(() => rememberMe = val ?? true),
                        activeColor: Colors.black,
                      ),
                      const Text("Remember me", style: TextStyle(fontSize: 18, color: Color(0xFF4F5255))),
                    ],
                  ),
                  InkWell(
                    onTap: widget.onForgotPasswordClick,
                    child: const Text(
                      "Forgot password?",
                      style: TextStyle(fontSize: 18, color: Color(0xFF4F5255)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width * 0.65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    // TODO: Replace with real login logic
                    if (email.isEmpty || password.isEmpty) {
                      setState(() => errorMessage = "Email and password cannot be empty.");
                    } else {
                      setState(() => errorMessage = null);
                      // Simulate success or call API
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login successful")),
                      );
                    }
                  },
                  child: const Text("Login", style: TextStyle(fontSize: 28, color: Colors.white)),
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?", style: TextStyle(fontSize: 16, color: Color(0xFF4F5255))),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onSignUpClick,
                    child: const Text(
                      "Create new account",
                      style: TextStyle(fontSize: 16, color: Color(0xFFFF6B00), fontWeight: FontWeight.bold),
                    ),
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