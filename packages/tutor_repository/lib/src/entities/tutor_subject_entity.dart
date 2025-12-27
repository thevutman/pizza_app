class TutorSubjectEntity {
  String tutorId;
  String subjectName;
  String description;
  double pricePerHour;
  double rating;
  bool isVerified;

  TutorSubjectEntity({
    required this.tutorId,
    required this.subjectName,
    required this.description,
    required this.pricePerHour,
    required this.rating,
    required this.isVerified,
  });

  Map<String, Object?> toDocument() {
    return {
      'tutorId': tutorId,
      'subjectName': subjectName,
      'description': description,
      'pricePerHour': pricePerHour,
      'rating': rating,
      'isVerified': isVerified,
    };
  }

  static TutorSubjectEntity fromDocument(Map<String, dynamic> doc) {
    return TutorSubjectEntity(
      tutorId: doc['tutorId'],
      subjectName: doc['subjectName'],
      description: doc['description'],
      pricePerHour: (doc['pricePerHour'] as num).toDouble(),
      rating: (doc['rating'] as num).toDouble(),
      isVerified: doc['isVerified'],
    );
  }
}