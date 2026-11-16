import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/MarketTicker.dart';
import 'ApiClient.dart';

class TickerService {
  TickerService({http.Client? client})
    : _client = client ?? ApiClient.instance;

  static final Uri _endpoint = Uri.parse(
    'http://localhost:8080/api-externa/tickers',
  );
  static final Uri _portfolioEndpoint = Uri.parse(
    'http://localhost:8080/api/carteira',
  );

  final http.Client _client;

  Future<List<PortfolioPosition>> listarCarteira() async {
    final response = await _client
        .get(_portfolioEndpoint)
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao carregar carteira (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Resposta da carteira inválida.');
    }
    return decoded.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Posição inválida na carteira.');
      }
      return PortfolioPosition.fromJson(item);
    }).toList();
  }

  Future<PortfolioPosition> adicionarNaCarteira({
    required String symbol,
    required double averagePrice,
  }) async {
    final response = await _client
        .post(
          _portfolioEndpoint,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'symbol': symbol,
            'averagePrice': averagePrice,
          }),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 201) {
      throw Exception(
        'Falha ao salvar ticker (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Resposta ao salvar ticker inválida.');
    }
    return PortfolioPosition.fromJson(decoded);
  }

  Future<void> removerDaCarteira(int id) async {
    final response = await _client
        .delete(
          _portfolioEndpoint.replace(
            path: '${_portfolioEndpoint.path}/$id',
          ),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 204) {
      throw Exception(
        'Falha ao remover ticker (${response.statusCode}): ${response.body}',
      );
    }
  }

  Future<List<MarketTicker>> buscarTickers(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return [];

    final uri = _endpoint.replace(
      queryParameters: {'search': normalizedQuery},
    );
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Falha ao buscar tickers (${response.statusCode}): ${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> || decoded['results'] is! List) {
      throw const FormatException('Resposta de tickers inválida.');
    }

    return (decoded['results'] as List)
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Ticker inválido na resposta.');
          }
          return MarketTicker.fromJson(item);
        })
        .toList();
  }

  Future<MarketTicker> buscarTickerPorSimbolo(String symbol) async {
    final tickers = await buscarTickers(symbol);
    for (final ticker in tickers) {
      if (ticker.symbol.toUpperCase() == symbol.toUpperCase()) {
        return ticker;
      }
    }
    throw StateError('Ticker $symbol não encontrado.');
  }
}
