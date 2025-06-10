class Booking {
  final int? id;
  final int userId;
  final int providerId;
  final DateTime serviceDate;
  final DateTime? bookingDate;
  final String status;
  final DateTime? createdAt; // Added: For completeness, as seen in backend JSON
  final DateTime? updatedAt; // Added: For completeness, as seen in backend JSON
  final String? providerName; // Added: Field for provider's username from backend
  final String? categoryName; // Added: Field for service category name from backend

  Booking({
    this.id,
    required this.userId,
    required this.providerId,
    required this.serviceDate,
    this.bookingDate,
    this.status = 'Pending', 
    this.createdAt, 
    this.updatedAt, 
    this.providerName, 
    this.categoryName, 
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse a DateTime
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
      'status': status, // Assuming status should always be sent or can be defaulted on backend
    };
  }
}