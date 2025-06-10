// frontend/lib/views/customer/book_service_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_style.dart';
import '../../core/widgets/custom_button.dart';
import '../../features/bookings/data/booking_model.dart';
import '../../features/bookings/presentation/booking_provider.dart';
import '../../features/provider/presentation/providers_provider.dart';


class ProviderDetailsScreen extends ConsumerStatefulWidget {
  final int providerId;

  const ProviderDetailsScreen({super.key, required this.providerId});

  @override
  ConsumerState<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends ConsumerState<ProviderDetailsScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchProviderDetails());
  }

  Future<void> _fetchProviderDetails() async {
    final providerNotifier = ref.read(providerNotifierProvider.notifier);
    await providerNotifier.fetchProviderDetails(widget.providerId);
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accent, 
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accent, 
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary, 
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _confirmBooking() async {
    final providerState = ref.read(providerNotifierProvider);
    final currentProvider = providerState.selectedProvider;

    if (currentProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Provider details not loaded yet. Cannot book.')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date for the service.')),
      );
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time for the service.')),
      );
      return;
    }

    final bookingNotifier = ref.read(bookingNotifierProvider.notifier);

    const int currentUserId = 1; // IMPORTANT: Replace with actual logged-in user ID

    final DateTime serviceDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final newBooking = Booking(
      userId: currentUserId,
      providerId: widget.providerId,
      serviceDate: serviceDateTime,
      status: 'Pending',
    );

    await bookingNotifier.create(newBooking);

    final bookingState = ref.read(bookingNotifierProvider);

    if (bookingState.error != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed: ${bookingState.error}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!bookingState.isLoading) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Booking confirmed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(providerNotifierProvider);
    final bookingState = ref.watch(bookingNotifierProvider);

    final provider = providerState.selectedProvider;

    final isConfirmButtonEnabled = _selectedDate != null && _selectedTime != null && !bookingState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Details'),
        backgroundColor: AppColors.accent,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: providerState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : providerState.errorMessage != null
              ? Center(child: Text('Error: ${providerState.errorMessage}', style: AppTextStyles.body.copyWith(color: Colors.red)))
              : provider == null
                  ? const Center(child: Text('Provider not found.', style: AppTextStyles.body,))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  // ignore: deprecated_member_use
                                  backgroundColor: AppColors.accent.withOpacity(0.2),
                                  backgroundImage: (provider.imageUrl != null && provider.imageUrl!.isNotEmpty)
                                      ? NetworkImage(provider.imageUrl!)
                                      : null,
                                  child: (provider.imageUrl == null || provider.imageUrl!.isEmpty)
                                      ? Text(
                                          provider.username?.isNotEmpty == true
                                              ? provider.username![0].toUpperCase()
                                              : '?',
                                          style: AppTextStyles.headline1.copyWith(color: AppColors.accent),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  provider.username ?? 'Unknown Provider',
                                  style: AppTextStyles.headline2.copyWith(color: AppColors.accent),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  provider.category ?? 'Service Category',
                                  style: AppTextStyles.headline5.copyWith(color: AppColors.accent),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${provider.rating != null ? provider.rating!.toStringAsFixed(1) : 'N/A'} / 5 Stars',
                                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 32, thickness: 1),

                          Text(
                            'About Service',
                            style: AppTextStyles.headline4,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.serviceDescription ?? 'No description available.',
                            style: AppTextStyles.body,
                          ),
                          const SizedBox(height: 16),

                          // These now directly pass double/int values to _buildDetailRow
                          _buildDetailRow(Icons.location_on, 'Location', provider.location ?? 'N/A'),
                          _buildDetailRow(Icons.phone, 'Contact', provider.phoneNumber),
                          _buildDetailRow(Icons.attach_money, 'Hourly Rate', provider.hourlyRate),
                          _buildDetailRow(Icons.work, 'Experience', provider.yearsOfExperience),
                          _buildDetailRow(Icons.badge, 'Certification', provider.certificate ?? 'Not specified'),
                          const SizedBox(height: 24),

                          Text(
                            'Schedule Your Service',
                            style: AppTextStyles.headline4,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickDate(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: AppColors.textSecondary),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            _selectedDate == null
                                                ? 'Select Date'
                                                : DateFormat('MMM dd, EEEE').format(_selectedDate!),
                                            style: AppTextStyles.body,
                                            maxLines: 1, 
                                            overflow: TextOverflow.ellipsis, 
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickTime(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      border: Border.all(color: AppColors.textSecondary.withOpacity(0.3)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.access_time, color: AppColors.textSecondary),
                                        const SizedBox(width: 10),
                                        Expanded( 
                                          child: Text(
                                            _selectedTime == null
                                                ? 'Select Time'
                                                : _selectedTime!.format(context),
                                            style: AppTextStyles.body,
                                            maxLines: 1, 
                                            overflow: TextOverflow.ellipsis, 
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          Center(
                            child: AppButton(
                              text: bookingState.isLoading ? 'Confirming...' : 'Confirm Booking',
                              onPressed: _confirmBooking,
                              isLoading: bookingState.isLoading,
                              isEnabled: isConfirmButtonEnabled,
                              type: ButtonType.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  // Updated _buildDetailRow to expect numeric types for Hourly Rate and Experience
Widget _buildDetailRow(IconData icon, String title, dynamic value) {
  String displayValue;

  if (value == null) {
    displayValue = 'N/A';
  } else if (title == 'Hourly Rate') {
    displayValue = '\$${(value as num).toStringAsFixed(2)}';
  } else if (title == 'Experience') {
    displayValue = '${(value as num).toInt()} Years';
  } else {
    displayValue = value.toString();
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textPrimary, size: 20),
        const SizedBox(width: 10),
        Expanded( 
          flex: 1, 
          child: Text(
            '$title:',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          flex: 2,
          child: Text(
            displayValue,
            style: AppTextStyles.body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
}