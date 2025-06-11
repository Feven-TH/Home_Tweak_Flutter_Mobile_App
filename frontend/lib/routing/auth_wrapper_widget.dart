import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/user/data/user_model.dart';
import '../features/user/presentation/user_provider.dart';
import '../features/user/presentation/user_state.dart';
import '../views/common/login_screen.dart';
import '../views/customer/home_screen.dart';
import '../views/provider/dashboard_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userNotifierProvider);

    if (userState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userState.error != null) {
      return Center(child: Text('Error: ${userState.error}'));
    }

    if (userState.user == null) {
      return LoginScreen(
        onForgotPasswordClick: () {
          context.push('/forgot-password');
        },
        onSignUpClick: () {
          context.push('/signup');
        },
      );
    }

    return _buildRoleBasedScreen(userState.user!, ref);
  }

  Widget _buildRoleBasedScreen(UserModel user, WidgetRef ref) {
    switch (user.role) {
      case 'customer':
        return const HomePage();
      case 'serviceProvider':
        return ProviderDashboardScreen(
          providerId: user.userId!,
        );
      default:
        return Scaffold(
          body: Center(child: Text('Unknown user role: ${user.role}')),
        );
    }
  }
}