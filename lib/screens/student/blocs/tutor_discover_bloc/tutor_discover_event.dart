part of 'tutor_discover_bloc.dart';

sealed class TutorDiscoverEvent extends Equatable {
  const TutorDiscoverEvent();

  @override
  List<Object> get props => [];
}

class LoadTopRatedTutors extends TutorDiscoverEvent {}

class SearchTutorsBySubject extends TutorDiscoverEvent {
  final String subject;

  const SearchTutorsBySubject(this.subject);

  @override
  List<Object> get props => [subject];
}