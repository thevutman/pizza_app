import 'models/models.dart';

abstract class TutorRepo {
  Future<List<TutorSubject>> getTutorsBySubject(String subject);
  Future<void> createTutorProfile(TutorSubject tutor);
  Future<List<TutorSubject>> getTopRatedTutors();
  Future<TutorSubject?> getTutorProfile(String tutorId);
  Future<void> createBooking(Booking booking);
  Stream<List<Booking>> getBookingsForTutor(String tutorId);
  Stream<List<Booking>> getBookingsForStudent(String studentId);
}
