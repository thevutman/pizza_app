import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutor_repository/tutor_repository.dart';

part 'tutor_profile_event.dart';
part 'tutor_profile_state.dart';

class TutorProfileBloc extends Bloc<TutorProfileEvent, TutorProfileState> {
  final TutorRepo _tutorRepo;

  TutorProfileBloc(this._tutorRepo) : super(TutorProfileLoading()) {
    on<LoadTutorProfile>((event, emit) async {
      emit(TutorProfileLoading());
      try {
        final profile = await _tutorRepo.getTutorProfile(event.tutorId);
        emit(TutorProfileLoaded(profile));
      } catch (e) {
        emit(TutorProfileFailure());
      }
    });

    on<SaveTutorProfile>((event, emit) async {
      emit(TutorProfileSaving());
      try {
        await _tutorRepo.createTutorProfile(event.profile);
        emit(TutorProfileSaved(event.profile));
      } catch (e) {
        emit(TutorProfileFailure());
      }
    });
  }
}