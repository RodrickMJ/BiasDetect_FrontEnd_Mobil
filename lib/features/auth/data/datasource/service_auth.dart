import 'dart:convert';
import 'package:bias_detect/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class ServiceAuth {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
}

class ServiceAuthImpl implements ServiceAuth {
  final http.Client client;
  ServiceAuthImpl(this.client);

  final baseUrl = "https://73vp4s6n-3000.usw3.devtunnels.ms/auth";

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse("$baseUrl/access"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error en al inicio de sesión: ${response.body}");
    }

    final decoded = json.decode(response.body);
    return UserModel.fromJson(decoded["data"]);
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse("$baseUrl/create"),
      headers: {"Content-Type": "application/jason"},
      body: json.encode({
        "name": name,
        "email": email,
        "password": password,
      })
    );

    if (response.statusCode != 200 ){
      throw Exception("Error en el registro: ${response.body}");
    }

    final decoded = json.decode(response.body);
    return UserModel.fromJson(decoded["data"]);
  }

}