part of 'tutor_profile_bloc.dart';

sealed class TutorProfileEvent extends Equatable {
  const TutorProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadTutorProfile extends TutorProfileEvent {
  final String tutorId;

  const LoadTutorProfile(this.tutorId);

  @override
  List<Object> get props => [tutorId];
}

class SaveTutorProfile extends TutorProfileEvent {
  final TutorSubject profile;

  const SaveTutorProfile(this.profile);

  @override
  List<Object> get props => [profile];
}