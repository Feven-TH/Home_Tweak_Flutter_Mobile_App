class Booking {
  final int id;
  final int userId;
  final int providerId;
  final DateTime serviceDate;
  final DateTime bookingDate;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.providerId,
    required this.serviceDate,
    required this.bookingDate,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        userId: json['userId'],
        providerId: json['providerId'],
        serviceDate: DateTime.parse(json['serviceDate']),
        bookingDate: DateTime.parse(json['bookingDate']),
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'providerId': providerId,
        'serviceDate': serviceDate.toIso8601String(),
        'bookingDate': bookingDate.toIso8601String(),
        'status': status,
      };
}
