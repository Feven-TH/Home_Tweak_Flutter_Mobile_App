import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/provider/presentation/provider_state.dart';
import '../../features/provider/presentation/providers_provider.dart';
import '../../features/provider/data/provider_model.dart';
import '../../features/user/data/user_model.dart';
import '../../features/user/presentation/user_provider.dart';
import '../../features/user/presentation/user_state.dart';

class ProviderProfileScreen extends ConsumerStatefulWidget {
  final int providerId;

  const ProviderProfileScreen({super.key, required this.providerId});

  @override
  ConsumerState<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends ConsumerState<ProviderProfileScreen> {
  int? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(providerNotifierProvider.notifier).fetchProviderDetails(widget.providerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerNotifierProvider);
    final provider = state.selectedProvider;
    userId = provider?.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Provider Profile'),
        actions: [
          if (provider != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(context, provider),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody(state, provider)),
          if (provider != null) _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildBody(ProviderState state, ServiceProvider? provider) {
    if (state.isLoading && provider == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider == null) {
      return const Center(child: Text('Provider not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(provider),
          const SizedBox(height: 24),
          _buildServiceInfoCard(provider),
          const SizedBox(height: 16),
          _buildContactInfoCard(provider),
          const SizedBox(height: 16),
          _buildServiceDetailsCard(provider),
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ServiceProvider provider) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: provider.imageUrl != null
              ? NetworkImage(provider.imageUrl!)
              : const AssetImage('assets/default_profile.png') as ImageProvider,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.username,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              provider.category!,
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (provider.yearsOfExperience != null)
              Text(
                '${provider.yearsOfExperience} years experience',
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceInfoCard(ServiceProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Service Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildInfoRow('Category', provider.category!),
            if (provider.hourlyRate != null) _buildInfoRow('Hourly Rate', '\$${provider.hourlyRate}/hr'),
            if (provider.yearsOfExperience != null) _buildInfoRow('Experience', '${provider.yearsOfExperience} years'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCard(ServiceProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contact Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (provider.location != null && provider.location!.isNotEmpty)
              _buildInfoRow('Location', provider.location!),
            if (provider.phoneNumber != null && provider.phoneNumber!.isNotEmpty)
              _buildInfoRow('Phone', provider.phoneNumber!),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDetailsCard(ServiceProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Service Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (provider.serviceDescription != null && provider.serviceDescription!.isNotEmpty)
              _buildInfoRow('Description', provider.serviceDescription!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ServiceProvider provider) {
    final hourlyRateController = TextEditingController(text: provider.hourlyRate?.toString() ?? '');
    final experienceController = TextEditingController(text: provider.yearsOfExperience?.toString() ?? '');
    final descController = TextEditingController(text: provider.serviceDescription ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Provider Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: hourlyRateController,
                  decoration: const InputDecoration(labelText: 'Hourly Rate'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: experienceController,
                  decoration: const InputDecoration(labelText: 'Years of Experience'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Service Description'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final updatedProvider = ServiceProvider(
                  id: provider.id,
                  userId: provider.userId,
                  username: provider.username,
                  category: provider.category,
                  imageUrl: provider.imageUrl,
                  phoneNumber: provider.phoneNumber,
                  hourlyRate: double.tryParse(hourlyRateController.text) ?? provider.hourlyRate,
                  yearsOfExperience: int.tryParse(experienceController.text) ?? provider.yearsOfExperience,
                  serviceDescription: descController.text,
                  certificate: provider.certificate,
                  location: provider.location,
                );
                ref.read(providerNotifierProvider.notifier).updateExistingProvider(provider.id, updatedProvider as Provider);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => _showLogoutConfirmation(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () => _showDeleteAccountConfirmation(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Delete Account', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logoutUser();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This will permanently delete your account. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAccount();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _logoutUser() async {
    try {
      if (userId != null) {
        await ref.read(userNotifierProvider.notifier).logout(userId!);
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Logout failed: ${e.toString()}')));
    }
  }

  Future<void> _deleteAccount() async {
    try {
      if (userId != null) {
        await ref.read(userNotifierProvider.notifier).deleteUserAccount(userId!);
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account deletion failed: ${e.toString()}')));
    }
  }
}
