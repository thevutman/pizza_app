part of 'tutor_discover_bloc.dart';

sealed class TutorDiscoverState extends Equatable {
  const TutorDiscoverState();

  @override
  List<Object> get props => [];
}

final class TutorDiscoverInitial extends TutorDiscoverState {}

final class TutorDiscoverLoading extends TutorDiscoverState {}

final class TutorDiscoverFailure extends TutorDiscoverState {}

final class TutorDiscoverSuccess extends TutorDiscoverState {
  final List<TutorSubject> tutors;

  const TutorDiscoverSuccess(this.tutors);

  @override
  List<Object> get props => [tutors];
}