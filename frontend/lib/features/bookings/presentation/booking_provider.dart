import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../../core/dio_client.dart';
import '../presentation/booking_notifier.dart';
import '../data/booking_repository.dart';
import '../domain/booking_repository_interface.dart';
import 'booking_state.dart';

// Use Cases
import '../domain/booking_usecases/create_bookings.dart';
import '../domain/booking_usecases/cancel_bookings.dart';
import '../domain/booking_usecases/get_bookings.dart';
import '../domain/booking_usecases/reschedule_booking.dart';
import '../domain/booking_usecases/update_booking_status.dart';


final dioProvider = Provider<Dio>((ref) => DioClient.createDio());

/// Booking repository provider
final bookingRepositoryProvider = Provider<IBookingRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return BookingRepositoryImpl(dio);
});

/// Use case providers
final createBookingUseCaseProvider = Provider<CreateBooking>((ref) {
  return CreateBooking(ref.watch(bookingRepositoryProvider));
});

final fetchBookingsByUserAndStatusProvider = Provider<GetBookingsByUserAndStatus>((ref) {
  return GetBookingsByUserAndStatus(ref.watch(bookingRepositoryProvider));
});

final cancelBookingUseCaseProvider = Provider<CancelBooking>((ref) {
  return CancelBooking(ref.watch(bookingRepositoryProvider));
});

final rescheduleBookingUseCaseProvider = Provider<RescheduleBooking>((ref) {
  return RescheduleBooking(ref.watch(bookingRepositoryProvider));
});

final updateBookingStatusUseCaseProvider = Provider<UpdateBookingStatus>((ref) {
  return UpdateBookingStatus(ref.watch(bookingRepositoryProvider));
});

/// BookingNotifier provider using injected use cases
final bookingNotifierProvider =
    StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier(
    createBooking: ref.watch(createBookingUseCaseProvider),
    fetchBookingsByUserAndStatus: ref.watch(fetchBookingsByUserAndStatusProvider),
    cancelBooking: ref.watch(cancelBookingUseCaseProvider),
    rescheduleBooking: ref.watch(rescheduleBookingUseCaseProvider),
    updateBookingStatus: ref.watch(updateBookingStatusUseCaseProvider),
  );
});

 //add the provier listeners in the ui 