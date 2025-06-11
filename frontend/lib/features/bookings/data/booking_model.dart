class Booking {
  final int? id;
  final int userId;
  final int providerId;
  final DateTime serviceDate;
  final DateTime? bookingDate;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? customerUsername; // ADDED: Field for customer's username
  final String? providerName;
  final String? categoryName;

  Booking({
    this.id,
    required this.userId,
    required this.providerId,
    required this.serviceDate,
    this.bookingDate,
    this.status = 'Pending',
    this.createdAt,
    this.updatedAt,
    this.customerUsername, // ADDED: Include in constructor
    this.providerName,
    this.categoryName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic value) {
      if (value is String) {
        return DateTime.tryParse(value);
      }
      return null;
    }

    return Booking(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      providerId: json['providerId'] as int,
      serviceDate: parseDateTime(json['serviceDate'])!,
      bookingDate: parseDateTime(json['bookingDate']),
      status: json['status'] as String? ?? 'Pending',
      createdAt: parseDateTime(json['createdAt']),
      updatedAt: parseDateTime(json['updatedAt']),
      customerUsername: json['customer'] != null && json['customer']['username'] is String // CHANGED: Safely parse customerUsername
          ? json['customer']['username'] as String
          : null,
      providerName: json['providerName'] as String?,
      categoryName: json['categoryName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'providerId': providerId,
      'serviceDate': serviceDate.toIso8601String(),
      if (bookingDate != null) 'bookingDate': bookingDate!.toIso8601String(),
      'status': status,
    };
  }
}