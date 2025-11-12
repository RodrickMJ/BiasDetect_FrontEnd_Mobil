import 'dart:convert';
import 'package:bias_detect/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class ServiceAuth {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
}

final baseUrl = "https://z1bn8fjr-3000.usw3.devtunnels.ms/auth";

class ServiceAuthImpl implements ServiceAuth {
  final http.Client client;
  ServiceAuthImpl(this.client);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse("$baseUrl/access"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Credenciales incorrectas");
    }

    final decoded = json.decode(response.body);
    return UserModel.fromResponse(decoded);
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"name": name, "email": email, "password": password}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al registrar usuario");
    }

    final decoded = json.decode(response.body);
    return UserModel.fromResponse(decoded);
  }
}
