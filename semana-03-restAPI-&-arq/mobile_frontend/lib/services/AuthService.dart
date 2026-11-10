// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http; 

class AuthService {
  final String _baseUrl = 'http://localhost:8080/auth';

  Future<bool> registrar({required String email, required String senha}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Sucesso
      } else {
        throw Exception('Erro ao registrar: ${response.body}');
      }         
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }

  Future<bool> logar({required String email, required String senha}) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return true; // Sucesso
      } else {
        throw Exception('Erro ao fazer login: ${response.body}');
      }         
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }
}