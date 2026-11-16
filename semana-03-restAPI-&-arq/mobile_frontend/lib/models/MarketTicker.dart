class MarketTicker {
  const MarketTicker({
    required this.symbol,
    required this.name,
    required this.lastPrice,
  });

  factory MarketTicker.fromJson(Map<String, dynamic> json) {
    final symbol = json['symbol'];
    final name = json['name'];
    final quote = json['quote'];
    final lastPrice = quote is Map<String, dynamic>
        ? quote['lastPrice']
        : null;

    if (symbol is! String || name is! String) {
      throw const FormatException('Ticker sem símbolo ou nome válido.');
    }

    return MarketTicker(
      symbol: symbol,
      name: name,
      lastPrice: lastPrice is num ? lastPrice.toDouble() : null,
    );
  }

  final String symbol;
  final String name;
  final double? lastPrice;
}

class PortfolioPosition {
  const PortfolioPosition({
    required this.id,
    required this.ticker,
    required this.averagePrice,
  });

  factory PortfolioPosition.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final symbol = json['symbol'];
    final averagePrice = json['averagePrice'];
    if (id is! int || symbol is! String || averagePrice is! num) {
      throw const FormatException('Posição inválida na carteira.');
    }

    return PortfolioPosition(
      id: id,
      ticker: MarketTicker(symbol: symbol, name: symbol, lastPrice: null),
      averagePrice: averagePrice.toDouble(),
    );
  }

  final int id;
  final MarketTicker ticker;
  final double averagePrice;

  double? get profitPerShare {
    final currentPrice = ticker.lastPrice;
    return currentPrice == null ? null : currentPrice - averagePrice;
  }

  double? get returnPercent {
    final profit = profitPerShare;
    return profit == null ? null : profit / averagePrice * 100;
  }
}
