class Booking {
  final int? id;
  final int userId;
  final int providerId;
  final DateTime serviceDate;
  final DateTime? bookingDate;
  final String status;

  Booking({
    this.id,
    required this.userId,
    required this.providerId,
    required this.serviceDate,
    this.bookingDate,
    this.status = 'Pending',
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['userId'],
      providerId: json['providerId'],
      serviceDate: DateTime.parse(json['serviceDate']),
      bookingDate: json['bookingDate'] != null
          ? DateTime.tryParse(json['bookingDate'])
          : null,
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'providerId': providerId,
      'serviceDate': serviceDate.toIso8601String(),
      if (status.isNotEmpty) 'status': status,
    };
  }
}
