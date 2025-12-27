import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutor_repository/tutor_repository.dart';

part 'student_bookings_event.dart';
part 'student_bookings_state.dart';

class StudentBookingsBloc extends Bloc<StudentBookingsEvent, StudentBookingsState> {
  final TutorRepo _tutorRepo;
  StreamSubscription<List<Booking>>? _subscription;

  StudentBookingsBloc(this._tutorRepo) : super(StudentBookingsLoading()) {
    on<StudentBookingsRequested>((event, emit) {
      _subscription?.cancel();
      _subscription = _tutorRepo
          .getBookingsForStudent(event.studentId)
          .listen((bookings) {
        add(StudentBookingsUpdated(bookings));
      });
    });

    on<StudentBookingsUpdated>((event, emit) {
      emit(StudentBookingsLoaded(event.bookings));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}