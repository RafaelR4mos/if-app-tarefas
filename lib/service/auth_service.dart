import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoappv2/model/erro_response.dart';
import 'package:todoappv2/model/exception/api_exception.dart';
import 'package:todoappv2/model/user.dart';
import 'package:todoappv2/util/json_parser.dart';

class AuthService {
  static const String baseUrl =
      'http://10.0.2.2:8080'; // A ponta para o IP da máquina local.
  static const String tokenKey = 'jwt_token';

  static Future<bool> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'emailUsuario': email, 'senhaUsuario': senha}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final token = json['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(tokenKey, token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<User> cadastro(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJsonCadastro()),
      );

      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        final erro = ErroResponse.fromJson(JsonParser.parseJsonUtf8(response));
        throw ApiException(erro.message);
      }
    } catch (e) {
      debugPrint("entrou");
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
