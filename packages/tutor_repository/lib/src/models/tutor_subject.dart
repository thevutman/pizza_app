import '../entities/entities.dart';

class TutorSubject {
  String tutorId;
  String subjectName;
  String description;
  double pricePerHour;
  double rating;
  bool isVerified;

  TutorSubject({
    required this.tutorId,
    required this.subjectName,
    required this.description,
    required this.pricePerHour,
    required this.rating,
    required this.isVerified,
  });

  TutorSubjectEntity toEntity() {
    return TutorSubjectEntity(
      tutorId: tutorId,
      subjectName: subjectName,
      description: description,
      pricePerHour: pricePerHour,
      rating: rating,
      isVerified: isVerified,
    );
  }

  static TutorSubject fromEntity(TutorSubjectEntity entity) {
    return TutorSubject(
      tutorId: entity.tutorId,
      subjectName: entity.subjectName,
      description: entity.description,
      pricePerHour: entity.pricePerHour,
      rating: entity.rating,
      isVerified: entity.isVerified,
    );
  }
}