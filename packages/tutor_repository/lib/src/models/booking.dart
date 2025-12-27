import '../entities/entities.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled,
}

class Booking {
  String bookingId;
  String studentId;
  String tutorId;
  DateTime scheduledDate;
  BookingStatus status;
  String meetLink;

  Booking({
    required this.bookingId,
    required this.studentId,
    required this.tutorId,
    required this.scheduledDate,
    required this.status,
    required this.meetLink,
  });

  BookingEntity toEntity() {
    return BookingEntity(
      bookingId: bookingId,
      studentId: studentId,
      tutorId: tutorId,
      scheduledDate: scheduledDate,
      status: status.name,
      meetLink: meetLink,
    );
  }

  static Booking fromEntity(BookingEntity entity) {
    return Booking(
      bookingId: entity.bookingId,
      studentId: entity.studentId,
      tutorId: entity.tutorId,
      scheduledDate: entity.scheduledDate,
      status: _statusFromString(entity.status),
      meetLink: entity.meetLink,
    );
  }

  static BookingStatus _statusFromString(String value) {
    for (final status in BookingStatus.values) {
      if (status.name == value) {
        return status;
      }
    }
    return BookingStatus.pending;
  }
}