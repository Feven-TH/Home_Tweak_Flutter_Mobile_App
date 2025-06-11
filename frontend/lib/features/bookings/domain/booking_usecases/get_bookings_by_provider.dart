import '../booking_repository_interface.dart';
import '../../data/booking_model.dart';

class GetBookingsByProvider {
  final IBookingRepository repository;

  GetBookingsByProvider(this.repository);

  Future<List<Booking>> call(int providerId) {
    return repository.getBookingsByProvider(providerId);
  }
}
