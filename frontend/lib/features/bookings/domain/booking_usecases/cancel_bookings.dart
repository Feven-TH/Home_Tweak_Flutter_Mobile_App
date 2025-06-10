import '../../domain/booking_repository_interface.dart';

class CancelBooking {
  final IBookingRepository repository;

  CancelBooking(this.repository);

  Future<void> call(int bookingId) {
    return repository.cancelBooking(bookingId);
  }
}
