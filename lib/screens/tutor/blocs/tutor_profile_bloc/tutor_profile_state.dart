part of 'tutor_profile_bloc.dart';

sealed class TutorProfileState extends Equatable {
  const TutorProfileState();

  @override
  List<Object?> get props => [];
}

final class TutorProfileLoading extends TutorProfileState {}

final class TutorProfileSaving extends TutorProfileState {}

final class TutorProfileFailure extends TutorProfileState {}

final class TutorProfileLoaded extends TutorProfileState {
  final TutorSubject? profile;

  const TutorProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

final class TutorProfileSaved extends TutorProfileState {
  final TutorSubject profile;

  const TutorProfileSaved(this.profile);

  @override
  List<Object?> get props => [profile];
}