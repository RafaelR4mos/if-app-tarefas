import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todoappv2/model/task.dart';
import 'package:todoappv2/service/auth_service.dart';

class TaskService {
  static const String baseUrl =
      'http://10.0.2.2:8080'; // A ponta para o IP da máquina local.
  static const String tokenKey = 'jwt_token';

  static Future<bool> createTask(Task task) async {
    final url = Uri.parse('$baseUrl/task');
    final token = await AuthService.getToken();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'nomeTask': task.nomeTarefa,
        'description': task.descricao,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Erro ao criar tarefa: ${response.body}');
      return false;
    }
  }

  static Future<List<Task>> fetchTasks() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/task/by-user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = jsonDecode(response.body);
      return responseBody.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar tarefas: ${response.statusCode}');
    }
  }

  static Future<bool> deleteTask(int idTarefa) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/task/$idTarefa');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception("Erro ao deletar tarefa: ${response.statusCode}");
    }
  }

  static Future<bool> updateTask(
    int idTarefa,
    String nomeTarefa,
    String descricao,
  ) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/task/$idTarefa');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nomeTask': nomeTarefa, 'descricao': descricao}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Erro ao editar tarefa: ${response.statusCode}");
    }
  }

  static Future<bool> finalizarTask(int idTarefa) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/task/$idTarefa/complete');

    final response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      print('Erro ao finalizar tarefa: ${response.statusCode}');
      return false;
    }

    return response.statusCode == 204;
  }

  static Future<bool> desfinalizarTask(int idTarefa) async {
    final token = await AuthService.getToken();
    final url = Uri.parse('$baseUrl/task/$idTarefa/uncomplete');

    final response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 204) {
      print('Erro ao desfinalizar tarefa: ${response.statusCode}');
      return false;
    }

    return response.statusCode == 204;
  }
}
