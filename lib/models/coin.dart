enum ViewState { loading, error, empty, success }

class Coin {
  final String id;
  final String symbol;
  final String name;
  final int rank;
  final double price;
  final double change24h;
  final String volume24h;
  final String marketCap;
  final String circulatingSupply;
  final double allTimeHigh;
  final List<double> sparklinePoints;
  final Map<String, List<double>> rangeData;
  bool isStarred;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.rank,
    required this.price,
    required this.change24h,
    required this.volume24h,
    required this.marketCap,
    required this.circulatingSupply,
    required this.allTimeHigh,
    required this.sparklinePoints,
    required this.rangeData,
    this.isStarred = false,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    List<double> parsePoints(dynamic pointsJson) {
      if (pointsJson is List) {
        return pointsJson.map((e) => (e as num).toDouble()).toList();
      }
      return [100.0, 102.0, 101.0, 105.0];
    }

    Map<String, List<double>> parseRangeMap(dynamic rangeJson) {
      if (rangeJson is Map) {
        final Map<String, List<double>> map = {};
        rangeJson.forEach((key, val) {
          if (val is List) {
            map[key.toString()] = val.map((e) => (e as num).toDouble()).toList();
          }
        });
        return map;
      }
      return {};
    }

    return Coin(
      id: json['id']?.toString() ?? 'unknown',
      symbol: json['symbol']?.toString().toUpperCase() ?? 'COIN',
      name: json['name']?.toString() ?? 'Cryptocurrency',
      rank: (json['rank'] as num?)?.toInt() ?? 99,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      change24h: (json['change24h'] as num?)?.toDouble() ?? 0.0,
      volume24h: json['volume24h']?.toString() ?? 'N/A',
      marketCap: json['marketCap']?.toString() ?? 'N/A',
      circulatingSupply: json['circulatingSupply']?.toString() ?? 'N/A',
      allTimeHigh: (json['allTimeHigh'] as num?)?.toDouble() ?? 0.0,
      sparklinePoints: parsePoints(json['sparklinePoints']),
      rangeData: parseRangeMap(json['rangeData']),
      isStarred: json['isStarred'] == true,
    );
  }
}

class MarketStatsData {
  final String totalMarketCap;
  final double marketCapChange24h;
  final List<Coin> topGainers;
  final List<Coin> topLosers;

  MarketStatsData({
    required this.totalMarketCap,
    required this.marketCapChange24h,
    required this.topGainers,
    required this.topLosers,
  });
}

class MockData {
  static List<Coin> get mockCoins => [
    Coin(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      rank: 1,
      price: 64250.80,
      change24h: 3.45,
      volume24h: '\$34.8B',
      marketCap: '\$1.26T',
      circulatingSupply: '19.75M BTC',
      allTimeHigh: 73750.07,
      isStarred: true,
      sparklinePoints: [62100, 62400, 62000, 62800, 63100, 63700, 64250.80],
      rangeData: {
        '1H': [64100, 64150, 64080, 64200, 64180, 64250.80],
        '1D': [62100, 62500, 61900, 63200, 63800, 64250.80],
        '1W': [58900, 60100, 61200, 60800, 63000, 64250.80],
        '1M': [54000, 56500, 59000, 61500, 62000, 64250.80],
        '1Y': [27000, 35000, 42000, 52000, 68000, 64250.80],
      },
    ),
    Coin(
      id: 'ethereum',
      symbol: 'ETH',
      name: 'Ethereum',
      rank: 2,
      price: 3480.20,
      change24h: 2.18,
      volume24h: '\$18.4B',
      marketCap: '\$418.5B',
      circulatingSupply: '120.2M ETH',
      allTimeHigh: 4891.70,
      isStarred: true,
      sparklinePoints: [3400, 3410, 3390, 3440, 3450, 3470, 3480.20],
      rangeData: {
        '1H': [3470, 3475, 3472, 3478, 3480.20],
        '1D': [3400, 3420, 3390, 3450, 3480.20],
        '1W': [3200, 3300, 3350, 3400, 3480.20],
        '1M': [2900, 3100, 3300, 3250, 3480.20],
        '1Y': [1600, 2100, 2800, 3500, 3480.20],
      },
    ),
    Coin(
      id: 'solana',
      symbol: 'SOL',
      name: 'Solana',
      rank: 3,
      price: 145.60,
      change24h: -1.85,
      volume24h: '\$4.2B',
      marketCap: '\$68.1B',
      circulatingSupply: '467.8M SOL',
      allTimeHigh: 260.06,
      isStarred: false,
      sparklinePoints: [149, 148, 147.5, 146.2, 147.0, 145.6],
      rangeData: {
        '1H': [146.5, 146.2, 146.0, 145.8, 145.6],
        '1D': [149.0, 147.8, 148.2, 146.0, 145.6],
        '1W': [135.0, 140.0, 148.0, 150.0, 145.6],
        '1M': [120.0, 130.0, 145.0, 155.0, 145.6],
        '1Y': [20.0, 45.0, 95.0, 180.0, 145.6],
      },
    ),
    Coin(
      id: 'tether',
      symbol: 'USDT',
      name: 'Tether',
      rank: 4,
      price: 1.0002,
      change24h: 0.01,
      volume24h: '\$42.1B',
      marketCap: '\$118.2B',
      circulatingSupply: '118.2B USDT',
      allTimeHigh: 1.32,
      isStarred: false,
      sparklinePoints: [1.0, 1.0001, 1.0, 1.0003, 1.0002],
      rangeData: {
        '1H': [1.0, 1.0001, 1.0002],
        '1D': [1.0, 1.0003, 1.0002],
        '1W': [0.9998, 1.0004, 1.0002],
        '1M': [0.9995, 1.0005, 1.0002],
        '1Y': [0.9980, 1.0020, 1.0002],
      },
    ),
    Coin(
      id: 'binancecoin',
      symbol: 'BNB',
      name: 'BNB',
      rank: 5,
      price: 578.40,
      change24h: 4.12,
      volume24h: '\$1.9B',
      marketCap: '\$84.5B',
      circulatingSupply: '146.1M BNB',
      allTimeHigh: 720.67,
      isStarred: true,
      sparklinePoints: [550, 555, 560, 565, 572, 578.40],
      rangeData: {
        '1H': [575, 576, 578, 578.40],
        '1D': [550, 560, 570, 578.40],
        '1W': [520, 540, 565, 578.40],
        '1M': [480, 510, 550, 578.40],
        '1Y': [210, 320, 590, 578.40],
      },
    ),
    Coin(
      id: 'ripple',
      symbol: 'XRP',
      name: 'XRP',
      rank: 6,
      price: 0.5620,
      change24h: -3.40,
      volume24h: '\$2.1B',
      marketCap: '\$31.4B',
      circulatingSupply: '56.1B XRP',
      allTimeHigh: 3.84,
      isStarred: false,
      sparklinePoints: [0.585, 0.580, 0.575, 0.570, 0.562],
      rangeData: {
        '1H': [0.565, 0.564, 0.562],
        '1D': [0.585, 0.575, 0.562],
        '1W': [0.540, 0.610, 0.562],
        '1M': [0.480, 0.590, 0.562],
        '1Y': [0.450, 0.650, 0.562],
      },
    ),
    Coin(
      id: 'cardano',
      symbol: 'ADA',
      name: 'Cardano',
      rank: 7,
      price: 0.3850,
      change24h: 1.15,
      volume24h: '\$410M',
      marketCap: '\$13.8B',
      circulatingSupply: '35.8B ADA',
      allTimeHigh: 3.10,
      isStarred: false,
      sparklinePoints: [0.378, 0.380, 0.382, 0.381, 0.385],
      rangeData: {
        '1H': [0.384, 0.385],
        '1D': [0.378, 0.381, 0.385],
        '1W': [0.350, 0.370, 0.385],
        '1M': [0.320, 0.360, 0.385],
        '1Y': [0.240, 0.450, 0.385],
      },
    ),
    Coin(
      id: 'dogecoin',
      symbol: 'DOGE',
      name: 'Dogecoin',
      rank: 8,
      price: 0.1240,
      change24h: -5.22,
      volume24h: '\$890M',
      marketCap: '\$18.1B',
      circulatingSupply: '145.8B DOGE',
      allTimeHigh: 0.7376,
      isStarred: false,
      sparklinePoints: [0.131, 0.129, 0.128, 0.125, 0.124],
      rangeData: {
        '1H': [0.125, 0.124],
        '1D': [0.131, 0.127, 0.124],
        '1W': [0.115, 0.135, 0.124],
        '1M': [0.100, 0.140, 0.124],
        '1Y': [0.060, 0.180, 0.124],
      },
    ),
  ];
}
