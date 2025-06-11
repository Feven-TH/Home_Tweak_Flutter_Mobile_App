import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/user/presentation/user_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onSignUpClick;
  final VoidCallback onForgotPasswordClick;

  const LoginScreen({
    super.key,
    required this.onSignUpClick,
    required this.onForgotPasswordClick,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = true;

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
              Image.asset('assets/images/home_tweak.jpg', height: 150),
              const SizedBox(height: 16),
              const Text("Login", style: TextStyle(color: Color(0xFF04285E), fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              const Text("Sign in to your account via email", style: TextStyle(color: Color(0xFF4F5255), fontSize: 18)),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFF1E8),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF4F5255)),
                  hintText: "Enter your email",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFFFF1E8),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF4F5255)),
                  hintText: "Enter your password",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide.none),
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
                    child: const Text("Forgot password?", style: TextStyle(fontSize: 18, color: Color(0xFF4F5255))),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width * 0.65,
                child: ElevatedButton(
                  onPressed: userState.isLoading
                      ? null
                      : () async {
                    await userNotifier.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );

                    if (userState.error == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successful")));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                  child: userState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login", style: TextStyle(fontSize: 28, color: Colors.white)),
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
                  const Text("Not a member?", style: TextStyle(fontSize: 16, color: Color(0xFF4F5255))),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onSignUpClick,
                    child: const Text("Create new account", style: TextStyle(fontSize: 16, color: Color(0xFFFF6B00), fontWeight: FontWeight.bold)),
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
