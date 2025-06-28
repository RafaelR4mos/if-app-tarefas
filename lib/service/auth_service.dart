import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

      debugPrint(response.body);

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

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
