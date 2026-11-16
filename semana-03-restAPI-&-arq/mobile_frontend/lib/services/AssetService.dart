import 'dart:convert';

import '../models/Asset.dart';
import 'ApiClient.dart';

class AssetService {
  final ApiClient _client = ApiClient.instance;
  static final Uri _endpoint = Uri.parse(
    'http://localhost:8080/api-externa/dados',
  );

  Future<List<Asset>> buscarAtivos() async {
    final response = await _client
        .get(_endpoint)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao buscar ativos (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('A resposta de ativos não é uma lista.');
    }

    return decoded
        .map((item) => Asset.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
