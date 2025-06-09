import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/booking_model.dart';
import 'booking_state.dart';

// Use Cases
import '../domain/booking_usecases/create_bookings.dart';
import '../domain/booking_usecases/cancel_bookings.dart';
import '../domain/booking_usecases/get_bookings.dart';
import '../domain/booking_usecases/reschedule_booking.dart';
import '../domain/booking_usecases/update_booking_status.dart';

class BookingNotifier extends StateNotifier<BookingState> {
  final CreateBooking _createBooking;
  final GetBookingsByUserAndStatus  _fetchBookingsByUserAndStatus;
  final CancelBooking _cancelBooking;
  final RescheduleBooking _rescheduleBooking;
  final UpdateBookingStatus _updateBookingStatus;

  BookingNotifier({
    required CreateBooking createBooking,
    required GetBookingsByUserAndStatus fetchBookingsByUserAndStatus,
    required CancelBooking cancelBooking,
    required RescheduleBooking rescheduleBooking,
    required UpdateBookingStatus updateBookingStatus,
  })  : _createBooking = createBooking,
        _fetchBookingsByUserAndStatus = fetchBookingsByUserAndStatus,
        _cancelBooking = cancelBooking,
        _rescheduleBooking = rescheduleBooking,
        _updateBookingStatus = updateBookingStatus,
        super(BookingState.initial());

  Future<void> loadBookings(int userId, String status) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final bookings = await _fetchBookingsByUserAndStatus(userId, status);
      state = state.copyWith(bookings: bookings, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> create(Booking booking) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _createBooking(booking);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> cancel(int bookingId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _cancelBooking(bookingId);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> reschedule(int bookingId, DateTime newDate) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _rescheduleBooking(bookingId, newDate);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateStatus(int bookingId, String newStatus) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _updateBookingStatus(bookingId, newStatus);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
