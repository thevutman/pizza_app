import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_repository/tutor_repository.dart';

class FirebaseTutorRepo implements TutorRepo {
  final CollectionReference<Map<String, dynamic>> tutorSubjectsCollection =
      FirebaseFirestore.instance.collection('tutorSubjects');
  final CollectionReference<Map<String, dynamic>> bookingsCollection =
      FirebaseFirestore.instance.collection('bookings');

  @override
  Future<List<TutorSubject>> getTutorsBySubject(String subject) async {
    try {
      return await tutorSubjectsCollection
          .where('subjectName', isEqualTo: subject)
          .where('isVerified', isEqualTo: true)
          .get()
          .then(
            (value) => value.docs
                .map(
                  (e) => TutorSubject.fromEntity(
                    TutorSubjectEntity.fromDocument(e.data()),
                  ),
                )
                .toList(),
          );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createTutorProfile(TutorSubject tutor) async {
    try {
      await tutorSubjectsCollection
          .doc(tutor.tutorId)
          .set(tutor.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<TutorSubject>> getTopRatedTutors() async {
    try {
      return await tutorSubjectsCollection
          .where('isVerified', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(10)
          .get()
          .then(
            (value) => value.docs
                .map(
                  (e) => TutorSubject.fromEntity(
                    TutorSubjectEntity.fromDocument(e.data()),
                  ),
                )
                .toList(),
          );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<TutorSubject?> getTutorProfile(String tutorId) async {
    try {
      return await tutorSubjectsCollection.doc(tutorId).get().then((value) {
        if (!value.exists || value.data() == null) {
          return null;
        }
        return TutorSubject.fromEntity(
          TutorSubjectEntity.fromDocument(value.data()!),
        );
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createBooking(Booking booking) async {
    try {
      await bookingsCollection
          .doc(booking.bookingId)
          .set(booking.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<Booking>> getBookingsForTutor(String tutorId) {
    return bookingsCollection
        .where('tutorId', isEqualTo: tutorId)
        .orderBy('scheduledDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Booking.fromEntity(
                  BookingEntity.fromDocument(doc.data()),
                ),
              )
              .toList(),
        );
  }

  @override
  Stream<List<Booking>> getBookingsForStudent(String studentId) {
    return bookingsCollection
        .where('studentId', isEqualTo: studentId)
        .orderBy('scheduledDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Booking.fromEntity(
                  BookingEntity.fromDocument(doc.data()),
                ),
              )
              .toList(),
        );
  }
}
