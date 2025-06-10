import '../data/booking_model.dart';

class BookingState {
  final List<Booking> bookings; 
  final bool isLoading;         
  final String? error;          

  BookingState({
    required this.bookings,
    required this.isLoading,
    this.error,
  });

  factory BookingState.initial() => BookingState(
        bookings: [],
        isLoading: false,
      );

  BookingState copyWith({
    List<Booking>? bookings,
    bool? isLoading,
    String? error,
  }) {
    return BookingState(
      bookings: bookings ?? this.bookings,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
