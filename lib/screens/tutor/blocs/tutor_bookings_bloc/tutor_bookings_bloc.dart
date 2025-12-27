import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutor_repository/tutor_repository.dart';

part 'tutor_bookings_event.dart';
part 'tutor_bookings_state.dart';

class TutorBookingsBloc extends Bloc<TutorBookingsEvent, TutorBookingsState> {
  final TutorRepo _tutorRepo;
  StreamSubscription<List<Booking>>? _subscription;

  TutorBookingsBloc(this._tutorRepo) : super(TutorBookingsLoading()) {
    on<TutorBookingsRequested>((event, emit) {
      _subscription?.cancel();
      _subscription = _tutorRepo
          .getBookingsForTutor(event.tutorId)
          .listen((bookings) {
        add(TutorBookingsUpdated(bookings));
      });
    });

    on<TutorBookingsUpdated>((event, emit) {
      emit(TutorBookingsLoaded(event.bookings));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}