// lib/services/auth_service.dart
import 'dart:convert';

import 'ApiClient.dart';

class AuthService {
  final String _baseUrl = 'http://localhost:8080/auth';
  final ApiClient _client = ApiClient.instance;

  Future<void> logout() => _client.clearToken();

  Future<bool> registrar({required String email, required String senha}) async {
    try {
      final response = await _client.post(
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
      await _client.clearToken();
      final response = await _client.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao fazer login: ${response.body}');
      }         

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> ||
          decoded['accessToken'] is! String) {
        throw const FormatException('Resposta de login sem accessToken.');
      }
      await _client.saveToken(decoded['accessToken'] as String);
      return true;
    } catch (e) {
      throw Exception('Falha na conexão: $e');
    }
  }
}