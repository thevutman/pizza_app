import '../entities/entities.dart';

enum UserRole {
  student,
  tutor,
  unknown,
}

class MyUser {
  String userId;
  String email;
  String name;
  UserRole role;

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.role,
  });

  static final empty = MyUser(
		userId: '', 
		email: '', 
		name: '',
    role: UserRole.unknown,
	);

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId, 
      email: email, 
      name: name,
      role: role.name,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId, 
      email: entity.email, 
      name: entity.name, 
      role: _roleFromString(entity.role),
    );
  }

  static UserRole _roleFromString(String value) {
    for (final role in UserRole.values) {
      if (role.name == value) {
        return role;
      }
    }
    return UserRole.unknown;
  }

  @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $role';
  }
}
