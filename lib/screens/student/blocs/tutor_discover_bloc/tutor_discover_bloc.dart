import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutor_repository/tutor_repository.dart';

part 'tutor_discover_event.dart';
part 'tutor_discover_state.dart';

class TutorDiscoverBloc extends Bloc<TutorDiscoverEvent, TutorDiscoverState> {
  final TutorRepo _tutorRepo;

  TutorDiscoverBloc(this._tutorRepo) : super(TutorDiscoverInitial()) {
    on<LoadTopRatedTutors>((event, emit) async {
      emit(TutorDiscoverLoading());
      try {
        final tutors = await _tutorRepo.getTopRatedTutors();
        emit(TutorDiscoverSuccess(tutors));
      } catch (e) {
        emit(TutorDiscoverFailure());
      }
    });

    on<SearchTutorsBySubject>((event, emit) async {
      emit(TutorDiscoverLoading());
      try {
        final tutors = await _tutorRepo.getTutorsBySubject(event.subject);
        emit(TutorDiscoverSuccess(tutors));
      } catch (e) {
        emit(TutorDiscoverFailure());
      }
    });
  }
}