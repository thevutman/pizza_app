import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tutor_repository/tutor_repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final TutorRepo _tutorRepo;

  BookingBloc(this._tutorRepo) : super(BookingInitial()) {
    on<CreateBooking>((event, emit) async {
      emit(BookingSubmitting());
      try {
        await _tutorRepo.createBooking(event.booking);
        emit(BookingSuccess());
      } catch (e) {
        emit(BookingFailure());
      }
    });
  }
}