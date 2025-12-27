part of 'tutor_bookings_bloc.dart';

sealed class TutorBookingsEvent extends Equatable {
  const TutorBookingsEvent();

  @override
  List<Object> get props => [];
}

class TutorBookingsRequested extends TutorBookingsEvent {
  final String tutorId;

  const TutorBookingsRequested(this.tutorId);

  @override
  List<Object> get props => [tutorId];
}

class TutorBookingsUpdated extends TutorBookingsEvent {
  final List<Booking> bookings;

  const TutorBookingsUpdated(this.bookings);

  @override
  List<Object> get props => [bookings];
}