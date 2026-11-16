import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobile_frontend/models/MarketTicker.dart';
import 'package:mobile_frontend/services/TickerService.dart';

void main() {
  test('searches tickers and parses the current quote', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'localhost');
      expect(request.url.path, '/api-externa/tickers');
      expect(request.url.queryParameters, {'search': 'PETR'});

      return http.Response(
        jsonEncode({
          'results': [
            {
              'symbol': 'PETR4',
              'name': 'Petroleo Brasileiro S.A.',
              'quote': {'lastPrice': 38.25},
            },
          ],
        }),
        200,
      );
    });
    final service = TickerService(client: client);

    final tickers = await service.buscarTickers('PETR');

    expect(tickers, hasLength(1));
    expect(tickers.single.symbol, 'PETR4');
    expect(tickers.single.lastPrice, 38.25);
  });

  test('calculates return per share and handles missing quotes', () {
    const position = PortfolioPosition(
      id: 1,
      ticker: MarketTicker(symbol: 'PETR4', name: 'Petrobras', lastPrice: 42),
      averagePrice: 40,
    );
    const positionWithoutQuote = PortfolioPosition(
      id: 2,
      ticker: MarketTicker(symbol: 'VALE3', name: 'Vale', lastPrice: null),
      averagePrice: 60,
    );

    expect(position.profitPerShare, 2);
    expect(position.returnPercent, 5);
    expect(positionWithoutQuote.profitPerShare, isNull);
    expect(positionWithoutQuote.returnPercent, isNull);
  });

  test(
    'loads and changes positions through the authenticated backend routes',
    () async {
      final client = MockClient((request) async {
        expect(request.url.host, 'localhost');
        expect(request.url.path, startsWith('/api/carteira'));

        if (request.method == 'GET') {
          return http.Response(
            jsonEncode([
              {'id': 7, 'symbol': 'PETR4', 'averagePrice': 32.5},
            ]),
            200,
          );
        }
        if (request.method == 'POST') {
          expect(jsonDecode(request.body), {
            'symbol': 'VALE3',
            'averagePrice': 65.5,
          });
          return http.Response(
            jsonEncode({'id': 8, 'symbol': 'VALE3', 'averagePrice': 65.5}),
            201,
          );
        }
        expect(request.method, 'DELETE');
        expect(request.url.path, '/api/carteira/8');
        return http.Response('', 204);
      });
      final service = TickerService(client: client);

      final loadedPositions = await service.listarCarteira();
      final savedPosition = await service.adicionarNaCarteira(
        symbol: 'VALE3',
        averagePrice: 65.5,
      );
      await service.removerDaCarteira(savedPosition.id);

      expect(loadedPositions.single.id, 7);
      expect(loadedPositions.single.averagePrice, 32.5);
      expect(savedPosition.id, 8);
    },
  );
}
