import '../data/booking_model.dart';

abstract class IBookingRepository {
  Future<List<Booking>> getBookingsByUserAndStatus(int userId, String status);
  Future<Booking> createBooking(Booking booking);
  Future<void> cancelBooking(int bookingId);
  Future<void> rescheduleBooking(int bookingId, DateTime newDate);
  Future<void> updateBookingStatus(int bookingId, String status);
  Future<List<Booking>> getBookingsByProvider(int providerId);
}
