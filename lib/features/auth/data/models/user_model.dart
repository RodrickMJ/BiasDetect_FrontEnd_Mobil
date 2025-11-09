import 'package:bias_detect/features/auth/domain/entities/User.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"], 
      name: json["name"], 
      email: json["email"], 
      token: json["token"],
    );
  }
}