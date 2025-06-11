import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/user/presentation/user_provider.dart';
import '../views/common/forgot_password_screen.dart';
import '../views/common/login_screen.dart';
import '../views/common/reset_password_screen.dart';
import '../views/common/signup_screen.dart';
import '../views/customer/book_service_screen.dart';
import '../views/customer/customer_profile_screen.dart';
import '../views/customer/home_screen.dart';
import '../views/customer/my_bookings_screen.dart';
import '../views/provider/dashboard_screen.dart';
import '../views/provider/finish_signup_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (BuildContext context, GoRouterState state) {
      final user = ref.read(userNotifierProvider).user;
      final location = state.uri.path; // Use uri.path instead of location

      // If user is logged in and trying to access auth pages, redirect to home
      if (user != null &&
          (location == '/login' || location == '/signup')) {
        return user.role == 'customer'
            ? '/customer-home'
            : '/provider-home';
      }

      // If user is not logged in and trying to access protected pages
      if (user == null &&
          (location.startsWith('/customer-home') ||
              location.startsWith('/provider-home'))) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
          onForgotPasswordClick: () => context.push('/forgot-password'),
          onSignUpClick: () => context.push('/signup'),
        ),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpScreen(
          onSignInClick: () => context.push('/login'),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => ResetPasswordScreen(
          email: state.uri.queryParameters['email'] ?? '',
          resetCode: state.uri.queryParameters['resetCode'] ?? '',
        ),
      ),
      GoRoute(
        path: '/customer-home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/provider-dashboard/:providerId',
        builder: (context, state) {
          // Get providerId and ensure it's an int
          final providerId = int.tryParse(state.pathParameters['providerId'] ?? '');

          if (providerId == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid Provider ID')),
            );
          }

          return ProviderDashboardScreen(
            providerId: providerId,
            // Convert other numeric parameters if needed
            // initialTab: int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0,
          );
        },
      ),
      GoRoute(
        path: '/finish-signup',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return FinishSigningUpScreen(
            providerId: args['providerId'] as int,
            isServiceProvider: args['isServiceProvider'] as bool,
          );
        },
      ),
      GoRoute(
        path: '/book-service/:providerId',
        builder: (context, state) {
          final providerId = int.parse(state.pathParameters['providerId']!);
          return ProviderDetailsScreen(providerId: providerId);
        },
      ),
      GoRoute(
        path: '/my-bookings',
        builder: (context, state) => const MyBookingsScreen(),
      ),
      GoRoute(
        path: '/customer-profile',
        builder: (context, state) => const UpdateProfileScreen(),
      ),
    ],
  );
});