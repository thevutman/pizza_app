part of 'tutor_bookings_bloc.dart';

sealed class TutorBookingsState extends Equatable {
  const TutorBookingsState();

  @override
  List<Object> get props => [];
}

final class TutorBookingsLoading extends TutorBookingsState {}

final class TutorBookingsLoaded extends TutorBookingsState {
  final List<Booking> bookings;

  const TutorBookingsLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}