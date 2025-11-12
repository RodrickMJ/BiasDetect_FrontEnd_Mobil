import 'package:bias_detect/features/auth/domain/entities/User.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory UserModel.fromResponse(Map<String, dynamic> json) {
    return UserModel(
      id: json["user"]["id"],
      name: json["user"]["name"],
      email: json["user"]["email"],
      token: json["token"],
    );
  }
}
