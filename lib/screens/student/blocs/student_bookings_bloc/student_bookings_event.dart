part of 'student_bookings_bloc.dart';

sealed class StudentBookingsEvent extends Equatable {
  const StudentBookingsEvent();

  @override
  List<Object> get props => [];
}

class StudentBookingsRequested extends StudentBookingsEvent {
  final String studentId;

  const StudentBookingsRequested(this.studentId);

  @override
  List<Object> get props => [studentId];
}

class StudentBookingsUpdated extends StudentBookingsEvent {
  final List<Booking> bookings;

  const StudentBookingsUpdated(this.bookings);

  @override
  List<Object> get props => [bookings];
}