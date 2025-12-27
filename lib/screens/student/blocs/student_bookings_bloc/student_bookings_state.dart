part of 'student_bookings_bloc.dart';

sealed class StudentBookingsState extends Equatable {
  const StudentBookingsState();

  @override
  List<Object> get props => [];
}

final class StudentBookingsLoading extends StudentBookingsState {}

final class StudentBookingsLoaded extends StudentBookingsState {
  final List<Booking> bookings;

  const StudentBookingsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}