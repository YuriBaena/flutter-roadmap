class Asset {
  const Asset({
    required this.symbol,
    required this.longName,
    required this.regularMarketPrice,
    required this.regularMarketTime,
    required this.logoUrl,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      symbol: json['symbol'] as String,
      longName: json['longName'] as String,
      regularMarketPrice: (json['regularMarketPrice'] as num).toDouble(),
      regularMarketTime: DateTime.parse(json['regularMarketTime'] as String),
      logoUrl: json['logourl'] as String,
    );
  }

  final String symbol;
  final String longName;
  final double regularMarketPrice;
  final DateTime regularMarketTime;
  final String logoUrl;
}
