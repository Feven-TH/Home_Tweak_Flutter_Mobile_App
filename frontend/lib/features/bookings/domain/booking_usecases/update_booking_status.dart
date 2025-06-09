import '../../domain/booking_repository_interface.dart';

class UpdateBookingStatus {
  final IBookingRepository repository;

  UpdateBookingStatus(this.repository);

  Future<void> call(int bookingId, String status) {
    return repository.updateBookingStatus(bookingId, status);
  }
}
