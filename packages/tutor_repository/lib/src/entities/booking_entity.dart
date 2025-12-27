class BookingEntity {
  String bookingId;
  String studentId;
  String tutorId;
  DateTime scheduledDate;
  String status;
  String meetLink;

  BookingEntity({
    required this.bookingId,
    required this.studentId,
    required this.tutorId,
    required this.scheduledDate,
    required this.status,
    required this.meetLink,
  });

  Map<String, Object?> toDocument() {
    return {
      'bookingId': bookingId,
      'studentId': studentId,
      'tutorId': tutorId,
      'scheduledDate': scheduledDate.millisecondsSinceEpoch,
      'status': status,
      'meetLink': meetLink,
    };
  }

  static BookingEntity fromDocument(Map<String, dynamic> doc) {
    return BookingEntity(
      bookingId: doc['bookingId'],
      studentId: doc['studentId'],
      tutorId: doc['tutorId'],
      scheduledDate: DateTime.fromMillisecondsSinceEpoch(doc['scheduledDate']),
      status: doc['status'],
      meetLink: doc['meetLink'],
    );
  }
}