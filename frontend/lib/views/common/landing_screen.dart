import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Optional: Use MediaQuery if you want to adapt for different screen sizes
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F5), // OffWhite
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),

            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/home_tweak_logo.jpg', // make sure this asset exists
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),
            // App Name
            Text(
              'HomeTweak',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: const Color(0xFF0A2A66), // DarkBlue
              ),
            ),

            // Tagline
            Text(
              'One Tap To Better Home',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF9E9E9E), // MutedGrey
              ),
            ),

            const SizedBox(height: 40),

            // Circular App Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/hometweak.png', // make sure this asset exists
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 40),

            // Get Started Button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/login'); // GoRouter route
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6F00), // SafetyOrange
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: Text(
                  'Get Started',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
